---@type LazySpec[]
return {
    {
        'neovim/nvim-lspconfig',
        init = function(plugin)
            vim.opt.runtimepath:append(plugin.dir)
        end,
    },
    {
        'mason-org/mason.nvim',
        cmd = { 'Mason' },
        init = function()
            vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

            vim.api.nvim_create_autocmd('User', {
                group = vim.api.nvim_create_augroup('plugins.mason.install', {}),
                pattern = 'LspRequestInstall',
                callback = function(ctx)
                    ---@type self.lsp.LspRequestInstallData
                    local data = ctx.data

                    require('plugins.config.mason').install_packages(data.lsp_names)
                end,
                desc = 'Install requested LSP packages with Mason',
            })
        end,
        ---@module 'mason'
        ---@type MasonSettings
        opts = { PATH = 'skip' },
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        ---@module 'lazydev'
        ---@type lazydev.Config
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
        -- LSP Capabilities を設定するので vim.lsp.enable の前に読み込む必要あり.
        event = { 'InsertEnter', 'CmdlineEnter', 'User LspEnablePre' },
        opts = function() return require('plugins.config.blink').opts end,
        opts_extend = { 'sources.default' },
        config = function(...) require('plugins.config.blink').config(...) end,
    },
    {
        'rafamadriz/friendly-snippets',
    },
}
