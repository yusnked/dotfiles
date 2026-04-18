-- NOTE: nvim-treesitter は neovim 0.11 からはかなり薄いプラグインで
-- パーサー/クエリのインストール管理と(実験的な)インデント関数の提供ぐらいなので
-- 常にロードしなくてもよい (公式にはlazy非対応)

local M = {}

local install_dir = vim.fn.stdpath('data') .. '/site'
local max_size_bytes = 2 * 1024 * 1024 -- 2MB

M.languages = {
    awk = true,
    bash = { ft = { 'bash', 'sh' }, indent = true },
    css = { indent = true },
    csv = true,
    diff = true,
    dockerfile = true,
    gitcommit = true,
    gitignore = true,
    html = { indent = true },
    http = true,
    ini = true,
    javascript = { indent = true },
    json = { indent = true },
    json5 = { ft = { 'json5', 'jsonc' } },
    lua = { indent = true },
    markdown = true,
    markdown_inline = true,
    python = { indent = true },
    query = true,
    regex = true,
    ruby = { indent = true },
    rust = { indent = true },
    scss = { indent = true },
    sql = { indent = true },
    toml = { indent = true },
    tsx = { ft = 'typescriptreact', indent = true },
    typescript = { indent = true },
    vim = true,
    vimdoc = true,
    xml = { indent = true },
    yaml = { indent = true },
    zsh = true,
}

local languages_ft = nil
function M.get_languages_ft()
    if languages_ft then
        return languages_ft
    end

    languages_ft = {}
    for k, v in pairs(M.languages) do
        if v == true then
            languages_ft[k] = k
        elseif type(v) == 'table' then
            if v.ft == nil then
                languages_ft[k] = k
            else
                if type(v.ft) == 'string' then
                    languages_ft[v.ft] = k
                elseif type(v.ft) == 'table' then
                    ---@diagnostic disable-next-line: param-type-mismatch
                    for _, x in ipairs(v.ft) do
                        languages_ft[x] = k
                    end
                end
            end
        end
    end
    return languages_ft
end

local function set_treesitter_indentexpr(bufnr, lang)
    local spec = M.languages[lang]
    if type(spec) == 'table' and spec.indent == true then
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
end

local function ts_stop(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end
    if vim.b[bufnr].__ts_attached_lang then
        local ok, _ = pcall(vim.treesitter.stop, bufnr)
        if ok then
            vim.b[bufnr].__ts_attached_lang = nil
        end
    end
end

function M.init()
    vim.opt.runtimepath:prepend(install_dir)

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('plugins_ts_lazy_loader', { clear = true }),
        callback = function(ctx)
            local bufnr = ctx.buf
            local ft = ctx.match
            local prev_lang = vim.b[bufnr].__ts_attached_lang
            local lang = (M.get_languages_ft())[ft]
            if not lang then
                if not prev_lang then
                    return
                end
                vim.schedule(function() ts_stop(bufnr) end)
                return
            end

            vim.defer_fn(function()
                if not vim.api.nvim_buf_is_valid(bufnr)
                    or vim.bo[bufnr].filetype ~= ft then
                    return
                end

                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname ~= '' then
                    local stat = vim.uv.fs_stat(bufname)
                    if stat and stat.size > max_size_bytes then
                        ts_stop(bufnr)
                        return
                    end
                end

                if prev_lang then
                    if prev_lang == lang then
                        return
                    end
                    ts_stop(bufnr)
                end

                -- デフォルトの仕組みにも一応登録.
                if lang ~= vim.treesitter.language.get_lang(ft) then
                    vim.treesitter.language.register(lang, ft)
                end

                local ok, _ = pcall(vim.treesitter.start, bufnr, lang)
                if ok then
                    vim.b[bufnr].__ts_attached_lang = lang

                    set_treesitter_indentexpr(bufnr, lang)

                    vim.api.nvim_exec_autocmds('User', {
                        pattern = 'TreesitterAttach',
                        data = { buf = bufnr, ft = ft, lang = lang },
                    })
                end
            end, 50)
        end,
    })
end

-- :TSUpdate 主にで呼ばれる想定.
function M.config()
    local ts = require('nvim-treesitter')
    ts.setup { install_dir = install_dir }
    ts.install(vim.tbl_keys(M.languages))
end

return M
