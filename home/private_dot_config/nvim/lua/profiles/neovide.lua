local vim_g = vim.g

vim_g.neovide_padding_bottom = 10

vim_g.neovide_hide_mouse_when_typing = true
vim_g.neovide_scroll_animation_length = 0.2
vim_g.neovide_cursor_animation_length = 0.1

-- macOS
vim_g.neovide_proxy_icon = true

do -- IME 有効・無効を切り替える (IME ソース切り替えではない).
    vim_g.neovide_input_ime = false

    local function set_ime(ctx)
        vim_g.neovide_input_ime = ctx.event:match('Enter$') ~= nil
    end

    local group = vim.api.nvim_create_augroup('profiles.neovide.input_ime', {})
    vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave' }, {
        group = group,
        callback = set_ime,
    })
    vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'CmdlineLeave' }, {
        group = group,
        pattern = '[\\/\\?]',
        callback = set_ime,
    })
end

---@module 'lazy'
require('plugins.lazy').add_specs {
    -- IME のプレエディット入力に対応させる.
    {
        'sevenc-nanashi/neov-ime.nvim',
        event = { 'InsertEnter', 'CmdlineEnter' },
    },
    -- mini.icons は未知のファイル名を判定する際にスクラッチバッファを生成し, BufFilePost を発火させる.
    -- Neovide がそのパスを拾ってプロキシアイコンを消してしまうため, 本家 nvim-web-devicons を使用する.
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { { 'nvim-tree/nvim-web-devicons', lazy = false } },
    },
}
