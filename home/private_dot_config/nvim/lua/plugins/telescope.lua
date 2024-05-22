return {
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'nvim-telescope/telescope-fzf-native.nvim',
        },
        keys = { '<Leader>f', '<Leader>p', '<Leader>*', { '<C-t>', mode = 'c' } },
        cmd = 'Telescope',
        cond = NOT_VSCODE,
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            local native_fzf_sorter = telescope.extensions.fzf.native_fzf_sorter
            telescope.setup {
                defaults = {
                    mappings = {
                        i = {
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                        },
                        n = {
                            ['<C-c>'] = {
                                actions.close,
                                type = 'action',
                                opts = { nowait = true, silent = true },
                            },
                            ['<Esc>'] = false,
                        },
                    },
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--glob=!.git/**',
                        '--hidden',
                        '--smart-case',
                        '--trim',
                        '--vimgrep',
                    },
                },
                pickers = {
                    buffers = {
                        mappings = {
                            i = {
                                ['<c-d>'] = actions.delete_buffer + actions.move_to_top,
                            },
                            n = {
                                ['d'] = actions.delete_buffer + actions.move_to_top,
                            },
                        },
                    },
                    command_history = {
                        mappings = {
                            i = {
                                ['<c-t>'] = actions.edit_command_line,
                            },
                        },
                    },
                },
                extensions = {
                    fzf = { fuzzy = false },
                },
            }

            telescope.load_extension('fzf')
            telescope.load_extension('notify')

            local keymap = vim.keymap.set
            local builtin = require('telescope.builtin')
            keymap('n', '<Leader>fa', function()
                builtin.builtin { include_extensions = true }
            end, { desc = 'Telescope' })
            keymap('n', '<Leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            keymap('n', '<Leader>fc', builtin.commands, { desc = 'Telescope commands' })
            keymap('n', '<Leader>ff', builtin.live_grep, { desc = 'Telescope live_grep' })
            keymap('n', '<Leader>fgb', builtin.git_branches, { desc = 'Telescope git_branches' })
            keymap('n', '<Leader>fgc', builtin.git_bcommits, { desc = 'Telescope git_bcommits' })
            -- keymap('x', '<Leader>fg', builtin.git_bcommits_range, { desc = 'Telescope git_bcommits_range' })
            keymap('n', '<Leader>fgC', builtin.git_commits, { desc = 'Telescope git_commits' })
            keymap('n', '<Leader>fgq', builtin.git_stash, { desc = 'Telescope git_stash' })
            keymap('n', '<Leader>fgs', builtin.git_status, { desc = 'Telescope git_status' })
            keymap('n', '<Leader>fgf', builtin.git_files, { desc = 'Telescope git_file' })
            keymap('n', '<Leader>fj', builtin.jumplist, { desc = 'Telescope jumplist' })
            keymap('n', '<Leader>fl', builtin.loclist, { desc = 'Telescope loclist' })
            keymap('n', '<Leader>fm', builtin.marks, { desc = 'Telescope marks' })
            keymap('n', '<Leader>fo', builtin.vim_options, { desc = 'Telescope vim_options' })
            keymap('n', '<Leader>fq', builtin.quickfixhistory, { desc = 'Telescope quickfixhistory' })
            keymap('n', '<Leader>fR', builtin.registers, { desc = 'Telescope registers' })
            keymap('n', '<Leader>ft', builtin.treesitter, { desc = 'Telescope treesitter' })
            keymap('n', '<Leader>p', builtin.fd, { desc = 'Telescope fd' })
            keymap('n', '<Leader>*', builtin.grep_string, { desc = 'Telescope grep_string' })
            keymap('c', '<C-t>', builtin.command_history, { desc = 'Telescope command_history' })

            local ext = telescope.extensions
            keymap('n', '<Leader>fn', ext.notify.notify, { desc = 'Telescope notify' })
        end,
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
    },
    {
        'nvim-telescope/telescope-project.nvim',
        keys = {
            { '<Leader>fp', function()
                require('telescope').extensions.project.project()
            end, { desc = 'Telescope project' } },
        },
        cond = NOT_VSCODE,
        config = function()
            require('telescope').load_extension('project')
        end,
    },
    {
        'nvim-telescope/telescope-ghq.nvim',
        keys = {
            { '<Leader>fgh', function()
                require('telescope').extensions.ghq.list()
            end, { desc = 'Telescope ghq' } },
        },
        cond = NOT_VSCODE,
        config = function()
            require('telescope').load_extension('ghq')
        end,
    },
}
