return {
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'nvim-telescope/telescope-fzf-native.nvim',
        },
        keys = {
            '<Leader>f',
            '<Leader>p',
            '<Leader>*',
            { '<C-t>', mode = 'c', desc = 'Telescope command_history' },
        },
        cmd = 'Telescope',
        cond = NOT_VSCODE,
        init = function()
            vim.api.nvim_create_autocmd({ 'User' }, {
                pattern = 'VeryLazy',
                once = true,
                callback = function()
                    local wk = require('which-key')
                    wk.register {
                        ['<Leader>f'] = {
                            name = '+telescope',
                            R = 'Telescope registers',
                            a = 'Telescope all pickers',
                            b = 'Telescope buffers',
                            c = 'Telescope commands',
                            f = 'Telescope live_grep',
                            j = 'Telescope jumplist',
                            l = 'Telescope loclist',
                            m = 'Telescope marks',
                            n = 'Telescope notify',
                            o = 'Telescope vim_options',
                            p = 'Telescope project',
                            q = 'Telescope quickfixhistory',
                            t = 'Telescope treesitter',
                        },
                        ['<Leader>fg'] = {
                            name = '+telescope-git',
                            C = 'Telescope git_commits',
                            b = 'Telescope git_branches',
                            c = 'Telescope git_bcommits',
                            f = 'Telescope git_file',
                            g = 'Telescope ghq',
                            q = 'Telescope git_stash',
                            s = 'Telescope git_status',
                        },
                        ['<Leader>p'] = 'Telescope fd',
                        ['<Leader>*'] = 'Telescope grep_string',
                    }
                end,
            })
        end,
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

            local keymap = vim.keymap.set
            local builtin = require('telescope.builtin')
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
