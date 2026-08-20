local autocmd = vim.api.nvim_create_autocmd
local nvim_create_augroup = vim.api.nvim_create_augroup
---@param name string
local function augroup(name)
    return nvim_create_augroup('self.config.autocmds.' .. name, {})
end

-- 複数ファイルを引数に渡して起動した場合でも,
-- 未編集の引数が残っていることによる E173 を発生させない.
autocmd('VimEnter', {
    group = augroup('prevent_E173'),
    callback = function()
        if vim.fn.argc() > 1 then
            vim.cmd('silent! args %')
        end
    end,
    desc = 'Prevent E173 when starting with multiple files',
})

-- ftplugin が設定した formatoptions から r と o を除き,
-- insert <CR> や normal o によるコメントの自動継続を無効化する.
-- NOTE: blink.cmp がポップアップを表示する度に formatoptions を変更してる為,
--       OptionSet ではなく FileType で妥協.
autocmd('FileType', {
    group = augroup('disable_comment_continuation'),
    callback = function(ctx)
        if vim.bo[ctx.buf].buftype ~= '' then
            return
        end

        -- メインループに積むことで, FileType で同期的に読み込まれる ftplugin の後に実行.
        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(ctx.buf) then
                return
            end
            vim.bo[ctx.buf].formatoptions = vim.bo[ctx.buf].formatoptions:gsub('[ro]', '')
        end)
    end,
    desc = 'Disable automatic comment continuation',
})

autocmd('FocusLost', {
    group = augroup('clipboard_to_unnamed.setup'),
    once = true,
    callback = function() require('self.modules.clipboard_to_unnamed').setup() end,
    desc = 'Setup clipboard_to_unnamed module',
})
