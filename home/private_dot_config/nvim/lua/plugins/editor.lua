return {
    {
        'lukas-reineke/indent-blankline.nvim',
        dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
        event = { 'CursorHold', 'CursorHoldI' },
        cond = NOT_VSCODE,
        config = function()
            require('ibl').setup {
                scope = {
                    highlight = {
                        'RainbowDelimiterRed',
                        'RainbowDelimiterYellow',
                        'RainbowDelimiterBlue',
                        'RainbowDelimiterOrange',
                        'RainbowDelimiterGreen',
                        'RainbowDelimiterViolet',
                        'RainbowDelimiterCyan',
                    },
                },
            }

            local hooks = require('ibl.hooks')
            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

            require('self.helpers').exec_autocmds_filetype { group = 'TSRainbowDelimits' }
        end,
    },
    {
        'windwp/nvim-autopairs',
        event = { 'InsertEnter' },
        opts = {
            map_cr = NOT_VSCODE,
            map_c_h = true,
            map_c_w = true,
        },
    },
    {
        'NMAC427/guess-indent.nvim',
        event = { 'BufRead' },
        cmd = 'GuessIndent',
        cond = NOT_VSCODE,
        opts = {
            auto_cmd = true,
            override_editorconfig = false,
            filetype_exclude = {
                'TelescopePrompt',
                'TelescopeResults',
                'lazy',
            },
            buftype_exclude = {
                'help',
                'nofile',
                'terminal',
                'prompt',
            },
        },
    },
    {
        'karb94/neoscroll.nvim',
        keys = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb' },
        cond = NOT_VSCODE,
        config = function(plugin)
            require('neoscroll').setup {
                mappings = plugin.keys,
            }
            require('neoscroll.config').set_mappings {
                ['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '125' } },
                ['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '125' } },
                ['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '250' } },
                ['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '250' } },
                ['zt'] = { 'zt', { '125' } },
                ['zz'] = { 'zz', { '125' } },
                ['zb'] = { 'zb', { '125' } },
            }
        end,
    },
    {
        'RRethy/vim-illuminate',
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        config = function()
            local illuminate = require('illuminate')
            illuminate.configure {
                delay = 200,
                filetypes_denylist = {
                    'NvimTree',
                    'fugitive',
                    'lazy',
                },
            }
            -- Disable highlighting in visual mode.
            local group = vim.api.nvim_create_augroup('illuminate-invisible-visual', {})
            vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
                group = group,
                pattern = '[vV\x16]*:*',
                callback = illuminate.visible_buf,
            })
            vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
                group = group,
                pattern = '*:[vV\x16]*',
                callback = illuminate.invisible_buf,
            })
        end,
    },
    {
        'brenoprata10/nvim-highlight-colors',
        event = { 'CursorHold', 'CursorHoldI' },
        cond = NOT_VSCODE,
        keys = {
            {
                '<Leader>tc',
                function() require('nvim-highlight-colors').toggle() end,
                desc = 'Toggle highlight colors'
            },
        },
        opts = {
            render = 'virtual',
            virtual_symbol = '',
            virtual_symbol_position = 'eow',
            virtual_symbol_prefix = '',
            virtual_symbol_suffix = '',
            exclude_filetypes = { 'lazy' },
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        event = { 'CursorHold', 'CursorHoldI' },
        cond = NOT_VSCODE,
        opts = {
            attach_to_untracked = true,
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')
                local keymap = function(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                keymap('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal { ']c', bang = true }
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, { desc = 'Next git change' })
                keymap('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal { '[c', bang = true }
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, { desc = 'Previous git change' })

                keymap('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
                keymap('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
                keymap('v', '<leader>hs', function()
                    gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
                end, { desc = 'Stage hunk' })
                keymap('v', '<leader>hr', function()
                    gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
                end, { desc = 'Reset hunk' })
                keymap('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
                keymap('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
                keymap('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
                keymap('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
                keymap('n', '<leader>hb', function()
                    gitsigns.blame_line { full = true }
                end, { desc = 'Show git blame for cursor line' })
                keymap('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff against the index' })
                keymap('n', '<leader>hD', function()
                    gitsigns.diffthis('~1')
                end, { desc = 'Diff against the last commit' })
                keymap('n', '<leader>ht', gitsigns.toggle_deleted, { desc = 'Toggle display of deleted' })

                keymap({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'inner hunk' })
            end,
        },
    },
    {
        'jghauser/mkdir.nvim',
        event = { 'BufWritePre' },
        cond = NOT_VSCODE,
    },
}
