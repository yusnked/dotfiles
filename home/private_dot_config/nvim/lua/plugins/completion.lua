return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-calc',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-path',
            'octaltree/cmp-look',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'onsails/lspkind.nvim',
        },
        event = { 'InsertEnter', 'CmdlineEnter' },
        cond = NOT_VSCODE,
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            cmp.setup {
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered {
                        border = 'single',
                    },
                    documentation = cmp.config.window.bordered {
                        border = 'single',
                    },
                },
                formatting = {
                    format = require('lspkind').cmp_format(),
                },
                mapping = {
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            if vim.api.nvim_get_mode().mode:match('^c') then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end
                    end, { 'i', 'c', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            if vim.api.nvim_get_mode().mode:match('^c') then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end
                    end, { 'i', 'c', 's' }),
                    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }, { 'i' }),
                    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }, { 'i' }),
                    ['<C-n>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                        else
                            fallback()
                        end
                    end, { 'i' }),
                    ['<C-p>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
                        else
                            fallback()
                        end
                    end, { 'i' }),
                    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    ['<C-e>'] = cmp.mapping(cmp.mapping.close(), { 'i', 'c' }),
                    ['<CR>'] = cmp.mapping(function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm()
                            end
                        else
                            fallback()
                        end
                    end, { 'i' }),
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'calc' },
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                }, {
                    { name = 'look', keyword_length = 3 },
                }),
            }
            cmp.setup.cmdline({ '/', '?' }, {
                sources = {
                    { name = 'buffer' },
                },
            })
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { name = 'path' },
                }, {
                    { name = 'cmdline' },
                }),
            })
            cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

            local set_hl = vim.api.nvim_set_hl
            set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
            set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
            set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
            set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
            set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
            set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
            set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
            set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
            set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
            set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
            set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

            local keymap = vim.keymap.set
            keymap('i', '<C-n>', '')
            keymap('i', '<C-p>', '')
        end,
    },
    {
        'hrsh7th/cmp-buffer',
    },
    {
        'hrsh7th/cmp-calc',
    },
    {
        'hrsh7th/cmp-cmdline',
    },
    {
        'hrsh7th/cmp-path',
    },
    {
        'octaltree/cmp-look',
    },
    {
        'hrsh7th/cmp-nvim-lsp',
    },
    {
        'onsails/lspkind.nvim',
    },
    {
        'saadparwaiz1/cmp_luasnip',
    },
    {
        'L3MON4D3/LuaSnip',
        version = '*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
            require('luasnip').setup {}
            require('luasnip.loaders.from_vscode').lazy_load()
        end,
    },
    {
        'rafamadriz/friendly-snippets',
    },
}
