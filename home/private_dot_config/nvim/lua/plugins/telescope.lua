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
            local fb_actions = telescope.extensions.file_browser.actions
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
                    file_browser = {
                        hijack_netrw = false, -- Because it is already set up.
                        initial_mode = 'normal',
                        mappings = {
                            n = {
                                ['h'] = fb_actions.goto_parent_dir,
                                ['l'] = actions.select_default,
                                ['.'] = fb_actions.toggle_hidden,
                                ['<leader>e'] = {
                                    actions.close,
                                    type = 'action',
                                    opts = { nowait = true, silent = true },
                                },
                            },
                            i = {
                                ['<C-.>'] = fb_actions.toggle_hidden,
                            },
                        },
                    },
                    frecency = {
                        sorter = native_fzf_sorter(),
                        db_safe_mode = false,
                        show_scores = true,
                        show_unindexed = false,
                        ignore_patterns = {
                            '*.git/*',
                            '*/tmp/*',
                            '*/node_modules/*',
                            'term://*',
                        },
                    },
                },
            }

            telescope.load_extension('fzf')
            telescope.load_extension('file_browser')

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
        'nvim-telescope/telescope-file-browser.nvim',
        keys = {
            { '<Leader>e', function()
                require('telescope').extensions.file_browser.file_browser()
            end, { desc = 'Telescope file_browser' } },
        },
        cond = NOT_VSCODE,
        init = function()
            -- Execute hijack_netrw functions directly here.
            -- https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/master/lua/telescope/_extensions/file_browser/config.lua
            local netrw_bufname
            vim.api.nvim_create_autocmd('BufEnter', {
                group = vim.api.nvim_create_augroup('telescope-file-browser.nvim', {}),
                pattern = '*',
                callback = function()
                    vim.schedule(function()
                        local bufname = vim.api.nvim_buf_get_name(0)
                        if vim.fn.isdirectory(bufname) == 0 then
                            _, netrw_bufname = pcall(vim.fn.expand, '#:p:h')
                            return
                        end
                        if netrw_bufname == bufname then
                            netrw_bufname = nil
                            return
                        else
                            netrw_bufname = bufname
                        end
                        vim.api.nvim_buf_set_option(0, 'bufhidden', 'wipe')
                        require('telescope').extensions.file_browser.file_browser { cwd = bufname }

                        vim.defer_fn(function()
                            if vim.bo[0].filetype ~= 'TelescopePrompt' then
                                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                                    if vim.bo[bufnr].filetype == 'TelescopePrompt' then
                                        vim.cmd.buffer(bufnr)
                                        break
                                    end
                                end
                            end
                        end, 100)
                    end)
                end,
                desc = 'telescope-file-browser.nvim replacement for netrw',
            })
        end,
    },
    {
        'nvim-telescope/telescope-frecency.nvim',
        event = { 'BufLeave', 'ExitPre' },
        keys = {
            { '<Leader>fr', function()
                require('telescope').extensions.frecency.frecency()
            end, { desc = 'Telescope frecency' } },
        },
        cond = NOT_VSCODE,
        config = function()
            require('telescope').load_extension('frecency')
            vim.api.nvim_exec_autocmds({ 'BufWinEnter', 'BufWritePost' }, {
                group = 'TelescopeFrecency',
            })
        end,
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
