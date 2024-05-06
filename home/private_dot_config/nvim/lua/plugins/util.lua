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
        'rcarriga/nvim-notify',
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        config = function()
            vim.notify = require('notify')
        end,
    },
}
