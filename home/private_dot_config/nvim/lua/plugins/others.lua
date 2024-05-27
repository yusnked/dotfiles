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

            local desc = require('desc')
            wk.register(desc.n)
            wk.register(desc.x, { mode = 'x' })
            wk.register(desc.i, { mode = 'i' })
            wk.register(desc.c, { mode = 'c' })
        end,
    },
}
