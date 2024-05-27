local desc = require('desc')

return {
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'nvim-telescope/telescope-fzf-native.nvim',
        },
        keys = desc.lazy_keys {
            '<Leader>f', '<Leader>p', '<Leader>*',
            { '<C-t>', mode = 'c' },
        },
        cmd = 'Telescope',
        cond = NOT_VSCODE,
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
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
            telescope.load_extension('project')
            telescope.load_extension('ghq')
            telescope.load_extension('notify')

            local builtin = require('telescope.builtin')
            local keymap = desc.set_keymap
            keymap('n', '<Leader>fa', function() builtin.builtin { include_extensions = true } end)
            keymap('n', '<Leader>fb', builtin.buffers)
            keymap('n', '<Leader>fc', builtin.commands)
            keymap('n', '<Leader>ff', builtin.live_grep)
            keymap('n', '<Leader>fgb', builtin.git_branches)
            keymap('n', '<Leader>fgc', builtin.git_bcommits)
            -- keymap('x', '<Leader>fg', builtin.git_bcommits_range, { desc = 'Telescope git_bcommits_range' })
            keymap('n', '<Leader>fgC', builtin.git_commits)
            keymap('n', '<Leader>fgq', builtin.git_stash)
            keymap('n', '<Leader>fgs', builtin.git_status)
            keymap('n', '<Leader>fgf', builtin.git_files)
            keymap('n', '<Leader>fj', builtin.jumplist)
            keymap('n', '<Leader>fl', builtin.loclist)
            keymap('n', '<Leader>fm', builtin.marks)
            keymap('n', '<Leader>fo', builtin.vim_options)
            keymap('n', '<Leader>fq', builtin.quickfixhistory)
            keymap('n', '<Leader>fR', builtin.registers)
            keymap('n', '<Leader>ft', builtin.treesitter)
            keymap('n', '<Leader>p', builtin.fd)
            keymap('n', '<Leader>*', builtin.grep_string)
            keymap('c', '<C-t>', builtin.command_history)

            local ext = telescope.extensions
            keymap('n', '<Leader>fn', ext.notify.notify)
            keymap('n', '<Leader>fp', ext.project.project)
            keymap('n', '<Leader>fgh', ext.ghq.list)
        end,
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
    },
    {
        'nvim-telescope/telescope-project.nvim',
    },
    {
        'nvim-telescope/telescope-ghq.nvim',
    },
}
