return {
    {
        'vim-jp/vimdoc-ja',
        keys = { { 'h', mode = 'c' } },
    },
    {
        'tpope/vim-fugitive',
        keys = { { 'G', mode = 'c' } },
        cond = NOT_VSCODE,
    },
    {
        'tpope/vim-repeat',
    },
    {
        'nvim-lua/plenary.nvim',
    },
    {
        'nvim-tree/nvim-web-devicons',
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        cond = NOT_VSCODE,
        init = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 500
        end,
        config = function()
            local wk = require('which-key')
            wk.setup {}
            wk.register {
                -- neoscroll.nvim
                ['<C-u>'] = 'Scroll upwards half a screen',
                ['<C-d>'] = 'Scroll downwords half a screen',
                ['<C-b>'] = 'Scroll upwards a screen',
                ['<C-f>'] = 'Scroll downwords a screen',
                -- oil.nvim
                ['-'] = 'Open parent dir by oil.nvim',
            }
        end,
    },
}
