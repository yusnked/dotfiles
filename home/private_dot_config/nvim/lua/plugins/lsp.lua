return {
    {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        cond = NOT_VSCODE,
        config = true,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
        },
        event = { 'BufNewFile', 'BufRead', 'InsertEnter' },
        cond = NOT_VSCODE,
        config = function()
            require('mason-lspconfig').setup_handlers({ function(server)
                local opt = {
                    -- -- Function executed when the LSP server startup
                    on_attach = function(client, bufnr)
                        local keymap = vim.keymap.set
                        keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>',
                            { desc = 'vim.lsp.buf.hover' })
                        keymap('n', 'g<C-e>', '<cmd>lua vim.diagnostic.open_float()<CR>',
                            { desc = 'vim.diagnostic.open_float' })
                        keymap('n', 'g<C-f>', '<cmd>lua vim.lsp.buf.format()<CR>',
                            { desc = 'vim.lsp.buf.format' })
                        keymap('n', 'g<C-r>', '<cmd>lua vim.lsp.buf.rename()<CR>',
                            { desc = 'vim.lsp.buf.rename' })
                        keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>',
                            { desc = 'vim.lsp.buf.definition' })
                        keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>',
                            { desc = 'vim.lsp.buf.implementation' })
                        keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_next()<CR>',
                            { desc = 'vim.diagnostic.goto_next' })
                        keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_prev()<CR>',
                            { desc = 'vim.diagnostic.goto_prev' })
                    end,
                    capabilities = require('cmp_nvim_lsp').default_capabilities(
                        vim.lsp.protocol.make_client_capabilities()
                    )
                }
                require('lspconfig')[server].setup(opt)
            end })

            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    update_in_insert = false,
                    virtual_text = {
                        format = function(diagnostic)
                            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
                            -- diagnostic.code
                        end,
                    },
                })
        end,
    },
    {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        event = 'LspAttach',
        cond = NOT_VSCODE,
        config = true,
    },
}

