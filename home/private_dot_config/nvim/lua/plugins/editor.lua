return {
    {
        'lukas-reineke/indent-blankline.nvim',
        version = '*',
        event = { 'BufNewFile', 'BufRead', 'InsertEnter' },
        cond = NOT_VSCODE,
        config = function()
            vim.opt.list = true
            vim.opt.listchars:append 'space:⋅'
            -- vim.opt.listchars:append 'eol:↴'

            require('indent_blankline').setup {
                space_char_blankline = ' ',
                show_current_context = true,
            }
        end,
    },
    {   -- Insert modeで行番号を絶対ナンバリングに切り替える
        "sitiom/nvim-numbertoggle",
        event = 'InsertEnter',
        cond = NOT_VSCODE,
    },
}

