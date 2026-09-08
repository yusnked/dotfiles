-- Neovim デフォルトの ftplugin で起動される言語がある. (v0.12.5 時点では lua, markdown, query, help)
-- 同じバッファ・同じ parser で vim.treesitter.start() を呼んでも no-op なので気にする必要はない.

local ts_max_buf_size = 2 * 1024 * 1024 -- 2MiB

local install_dir = vim.fn.stdpath('data') .. '/site'

---@param ts_specs table<string, self.treesitter.Spec>
---@return table<string, string> ft_to_ts_name
local function index_by_filetype(ts_specs)
    local ft_to_ts_name = {}
    for ts_name, spec in pairs(ts_specs) do
        if spec.filetypes then
            for _, filetype in ipairs(spec.filetypes) do
                ft_to_ts_name[filetype] = ts_name
            end
        else
            ft_to_ts_name[ts_name] = ts_name
        end
    end
    return ft_to_ts_name
end

local ts_filetypes_registered = false
---@param ts_specs table<string, self.treesitter.Spec>
local function register_ts_filetypes(ts_specs)
    for ts_name, spec in pairs(ts_specs) do
        if spec.filetypes then
            vim.treesitter.language.register(ts_name, spec.filetypes)
        end
    end
    ts_filetypes_registered = true
end

---@param buf integer
local function fallback_highlight(buf)
    vim.b[buf].ts_highlight = nil
    vim.bo[buf].syntax = vim.bo[buf].filetype
end

---@class self.treesitter.TreesitterAttachData
---@field buf integer
---@field filetype string
---@field ts_name string
---@field spec self.treesitter.Spec

---@param ctx vim.api.keyset.create_autocmd.callback_args
---@param ts_specs table<string, self.treesitter.Spec>
---@param ft_to_ts_name table<string, string>
local function start_ts_highlight(ctx, ts_specs, ft_to_ts_name)
    local buf = ctx.buf
    local filetype = ctx.match
    local ts_name = ft_to_ts_name[filetype]

    if not ts_name then
        if vim.b[buf].ts_highlight then
            -- Tree-sitter ハイライト対象は start() が適切に処理するため stop() する必要は無い.
            vim.treesitter.stop(buf)

            -- start() 前に filetype が変わった場合は highlighter がまだ存在せず,
            -- stop() だけでは事前に設定したフラグが解除されないので解除する.
            if vim.b[buf].ts_highlight then
                fallback_highlight(buf)
            end
        end

        return
    end

    local generation = (vim.b[buf].ts_generation or 0) + 1
    vim.b[buf].ts_generation = generation

    -- b:ts_highlight を設定して正規表現ハイライトのロードを防止する.
    vim.b[buf].ts_highlight = true
    vim.bo[buf].syntax = ''

    vim.schedule(function()
        if not vim.api.nvim_buf_is_loaded(buf)
            or vim.b[buf].ts_generation ~= generation
            or vim.bo[buf].filetype ~= filetype then
            -- filetype が異なる場合, 下手に復元せず後続 FileType イベントに任せる.
            return
        end

        local buf_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
        if buf_size > ts_max_buf_size then
            -- 既にデフォルト ftplugin が start() している可能性があるため stop() する.
            vim.treesitter.stop(buf)
            fallback_highlight(buf)
            return
        end

        local ok = pcall(vim.treesitter.start, buf, ts_name)
        if not ok then
            fallback_highlight(buf)
            return
        end

        -- vim.treesitter のモジュールロードだけで 1ms 程度かかるので,
        -- Tree-sitter の起動でロードコストを払った後に標準の language mapping へ登録する.
        -- 当然それより前に get_lang しても標準フォールバックの値が返ることに注意.
        if not ts_filetypes_registered then
            register_ts_filetypes(ts_specs)
        end

        local spec = ts_specs[ts_name]

        vim.api.nvim_exec_autocmds('User', {
            pattern = 'TreesitterAttach',
            modeline = false,
            ---@type self.treesitter.TreesitterAttachData
            data = { buf = buf, filetype = filetype, ts_name = ts_name, spec = spec },
        })
    end)
end

vim.opt.runtimepath:prepend(install_dir)

local group = vim.api.nvim_create_augroup('self.treesitter.start', {})
vim.api.nvim_create_autocmd('FileType', {
    group = group,
    once = true,
    callback = function(initial_ctx)
        local ts_specs = require('self.treesitter.specs')
        local ft_to_ts_name = index_by_filetype(ts_specs)

        start_ts_highlight(initial_ctx, ts_specs, ft_to_ts_name)

        vim.api.nvim_create_autocmd('FileType', {
            group = group,
            callback = function(ctx)
                start_ts_highlight(ctx, ts_specs, ft_to_ts_name)
            end,
            desc = 'Enable Tree-sitter highlighting',
        })
    end,
    desc = 'Initialize Tree-sitter highlighting',
})
