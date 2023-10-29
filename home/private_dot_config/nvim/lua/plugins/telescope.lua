return {
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            {
                'nvim-lua/plenary.nvim',
                version = '*',
            },
            {
                'nvim-tree/nvim-web-devicons'
            },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                config = function()
                    require('telescope').load_extension('fzf')
                end,
            },
            {
                'nvim-telescope/telescope-file-browser.nvim',
            },
            {
                'nvim-telescope/telescope-frecency.nvim',
                dependencies = 'kkharji/sqlite.lua',
            },
        },
        cmd = 'Telescope',
        keys = {
            {
                '<Leader><Space>',
                '<Cmd>Telescope file_browser<CR>',
                mode = 'n',
                desc = 'Telescope file_browser',
            },
            {
                '<Leader>fa',
                '<Cmd>Telescope<CR>',
                mode = 'n',
                desc = 'Telescope',
            },
            {
                '<Leader>fb',
                function() require('telescope.builtin').buffers() end,
                mode = 'n',
                desc = 'Telescope buffers',
            },
            {
                '<Leader>fr',
                '<Cmd>Telescope frecency<CR>',
                mode = 'n',
                desc = 'Telescope frecency',
            },
        },
        cond = NOT_VSCODE,
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            local fb_actions = telescope.extensions.file_browser.actions

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ['<C-j>'] = {
                                actions.move_selection_next, type = "action",
                                opts = { nowait = true, silent = true }
                            },
                            ['<C-k>'] = {
                                actions.move_selection_previous, type = "action",
                                opts = { nowait = true, silent = true }
                            },
                            ['<C-;>'] = 'which_key',
                        },
                        n = {
                            ['<C-c>'] = {
                                actions.close, type = "action",
                                opts = { nowait = true, silent = true }
                            },
                            ['<Esc>'] = false,
                            ['<C-;>'] = 'which_key',
                        },
                    },
                },
                extensions = {
                    file_browser = {
                        initial_mode = 'normal',
                        mappings = {
                            n = {
                                ['h'] = fb_actions.goto_parent_dir,
                                ['l'] = actions.select_default,
                                ['<C-h>'] = fb_actions.toggle_hidden,
                                ['<leader><Space>'] = {
                                    actions.close, type = "action",
                                    opts = { nowait = true, silent = true }
                                },
                            },
                        },
                    },
                    frecency = {
                        show_scores = false,
                        ignore_patterns = {'*.git/*', '*/tmp/*'},
                    }
                },
            })
            telescope.load_extension('file_browser')
            telescope.load_extension('frecency')
        end,
    },
}

