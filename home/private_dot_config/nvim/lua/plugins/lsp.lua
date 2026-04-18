return {
    {
        'neovim/nvim-lspconfig',
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require('lspconfig')['denols'].setup { capabilities = capabilities }

            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                callback = function()
                    require('self.helpers').exec_autocmds_filetype {
                        group = 'lspconfig',
                        pattern = vim.bo.filetype,
                    }
                end,
                once = true,
            })
        end,
    },
    {
        'williamboman/mason.nvim',
        cond = NOT_VSCODE,
        build = ':MasonUpdate',
        opts = {},
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
        },
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup { capabilities = capabilities }
                    end,
                },
            }
        end,
    },
    {
        'nvimdev/lspsaga.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        event = { 'LspAttach' },
        cond = NOT_VSCODE,
        config = function()
            require('lspsaga').setup {}

            local keymap = vim.keymap.set
            keymap('n', 'K', '<Cmd>Lspsaga hover_doc<CR>')
        end,
    },
}
