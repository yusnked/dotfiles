return {
    {
        'lukas-reineke/indent-blankline.nvim',
        dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        config = function()
            local highlight = vim.g.rainbow_delimiters.highlight
            local hooks = require('ibl.hooks')
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, highlight[1], { fg = '#E06C75' })
                vim.api.nvim_set_hl(0, highlight[2], { fg = '#E5C07B' })
                vim.api.nvim_set_hl(0, highlight[3], { fg = '#61AFEF' })
                vim.api.nvim_set_hl(0, highlight[4], { fg = '#D19A66' })
                vim.api.nvim_set_hl(0, highlight[5], { fg = '#98C379' })
                vim.api.nvim_set_hl(0, highlight[6], { fg = '#C678DD' })
                vim.api.nvim_set_hl(0, highlight[7], { fg = '#56B6C2' })
            end)

            require('ibl').setup { scope = { highlight = highlight } }
            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

            require('helpers').exec_autocmds_filetype { group = 'TSRainbowDelimits' }
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
        'RRethy/vim-illuminate',
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
    },
    {
        'brenoprata10/nvim-highlight-colors',
        event = { 'FileType' },
        cond = NOT_VSCODE,
        opts = {},
    },
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        cond = NOT_VSCODE,
    },
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'petertriho/nvim-scrollbar' },
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        config = function()
            local gitsigns = require('gitsigns')
            gitsigns.setup {
                attach_to_untracked = true,
                on_attach = function(bufnr)
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
                    end)
                    keymap('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal { '[c', bang = true }
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end)

                    keymap('n', '<leader>hs', gitsigns.stage_hunk)
                    keymap('n', '<leader>hr', gitsigns.reset_hunk)
                    keymap('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                    keymap('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                    keymap('n', '<leader>hs', gitsigns.stage_buffer)
                    keymap('n', '<leader>hu', gitsigns.undo_stage_hunk)
                    keymap('n', '<leader>hr', gitsigns.reset_buffer)
                    keymap('n', '<leader>hp', gitsigns.preview_hunk)
                    keymap('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
                    keymap('n', '<leader>hd', gitsigns.diffthis)
                    keymap('n', '<leader>hd', function() gitsigns.diffthis('~') end)
                    keymap('n', '<leader>htd', gitsigns.toggle_deleted)

                    keymap({ 'o', 'x' }, 'ih', ':<c-u>gitsigns select_hunk<cr>')
                end,
            }

            require('scrollbar.handlers.gitsigns').setup()
        end,
    },
    {
        'jghauser/mkdir.nvim',
        event = { 'BufWritePre' },
        cond = NOT_VSCODE,
    },
}
