return {
    {
        'neovim/nvim-lspconfig',
        -- TODO: v0.12で LspStart -> lsp enable のように変更されるので設定を更新する.
        cmd = { 'LspInfo', 'LspStart', 'LspStop', 'LspRestart' },
        init = function(plugin)
            vim.opt.runtimepath:append(plugin.dir)
        end,
    },
    {
        'mason-org/mason.nvim',
        cmd = 'Mason',
        main = 'mason',
        opts = { PATH = 'skip' },
        init = function()
            vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH
        end,
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                'lazy.nvim',
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                { path = 'snacks.nvim', words = { 'Snacks' } },
            },
        },
    },
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        lazy = false,
        opts = function() return require('plugins.config.blink').opts end,
        opts_extend = { 'sources.default' },
        config = function(...) require('plugins.config.blink').config(...) end,
    },
    {
        'rafamadriz/friendly-snippets',
    },
}
