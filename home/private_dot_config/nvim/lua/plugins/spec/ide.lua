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
        main = 'lazydev',
        ---@module 'lazydev'
        ---@type lazydev.Config
        opts = {
            library = {
                { path = 'snacks.nvim', words = { 'Snacks' } },
            },
        },
        init = function(plugin)
            vim.api.nvim_create_autocmd('User', {
                group = vim.api.nvim_create_augroup('plugins.lazydev.load', {}),
                pattern = 'LspEnablePre',
                callback = function(ctx)
                    ---@type self.lsp.LspEnablePreData
                    local data = ctx.data

                    if vim.tbl_contains(data.lsp_names, 'lua_ls') then
                        require('lazy').load { plugins = { plugin.name } }
                        return true
                    end
                end,
                desc = 'Load lazydev.nvim',
            })
        end,
    },
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        -- LSP Capabilities を設定するので vim.lsp.enable の前に読み込む必要あり.
        event = { 'InsertEnter', 'CmdlineEnter', 'User LspEnablePre' },
        main = 'blink.cmp',
        opts = function()
            vim.o.wildmenu = false
            return require('plugins.config.blink').opts
        end,
    },
    {
        'rafamadriz/friendly-snippets',
    },
}
