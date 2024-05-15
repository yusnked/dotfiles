return {
    {
        'numToStr/Comment.nvim',
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        keys = {
            { 'gc', mode = { 'n', 'x' }, desc = 'Comment toggle linewise' },
            { 'gb', mode = { 'n', 'x' }, desc = 'Comment toggle blockwise' },
            { 'gcc', desc = 'Comment toggle current line' },
            { 'gbb', desc = 'Comment toggle current block' },
            { 'gcO', desc = 'Comment insert below' },
            { 'gco', desc = 'Comment insert above' },
            { 'gcA', desc = 'Comment insert end of line' },
        },
        config = function()
            require('Comment').setup {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            }
            vim.keymap.set('x', 'gC', function()
                if require('Comment.ft').get(vim.bo.filetype) or vim.bo.commentstring ~= '' then
                    return ':<C-u>normal gvyPgvgc`[<CR>'
                end
                return ''
            end, { expr = true, silent = true, desc = 'Comment out and copy' })
        end,
    },
    {
        'kylechui/nvim-surround',
        keys = {
            { 'ys', desc = 'Add a surrounding pair around a motion' },
            { 'yss', desc = 'Add a surrounding pair around the current line' },
            { 'yS', desc = 'Add a surrounding pair around a motion, on new lines' },
            { 'ySS', desc = 'Add a surrounding pair around the current line, on new lines' },
            { 'ds', desc = 'Delete a surrounding pair' },
            { 'cs', desc = 'Change a surrounding pair' },
            { 'cS', desc = 'Change a surrounding pair, putting replacements on new lines' },
            { 'S', mode = 'x', desc = 'Add a surrounding pair around a visual selection' },
            { 'gS', mode = 'x', desc = 'Add a surrounding pair around a visual selection, on new lines' },
            { '<C-g>s', mode = 'i', desc = 'Add a surrounding pair around the cursor' },
            { '<C-g>S', mode = 'i', desc = 'Add a surrounding pair around the cursor, on new lines' },
        },
        opts = {},
    },
    {
        'gbprod/substitute.nvim',
        keys = {
            { '<Leader>s', desc = 'Substitute operator' },
            { '<Leader>ss', desc = 'Substitute line' },
            { '<Leader>S', desc = 'Substitute eol' },
            { '<Leader>s', mode = 'x', desc = 'Substitute visual' },
            { '<Leader>sx', desc = 'Substitute exchange-operator' },
            { '<Leader>sxx', desc = 'Substitute exchange-line' },
            { '<Leader>S', mode = 'x', desc = 'Substitute exchange-visual' },
        },
        config = function()
            local sub = require('substitute')
            local sub_ex = require('substitute.exchange')
            sub.setup {
                highlight_substituted_text = {
                    enabled = NOT_VSCODE,
                    timer = 500,
                },
            }

            local customize = function(func)
                return function()
                    func {
                        modifiers = function(state)
                            if state.vmode == 'line' then
                                return { 'reindent' }
                            end
                        end,
                    }
                end
            end
            local keymap = vim.keymap.set
            keymap('n', '<Leader>s', customize(sub.operator))
            keymap('n', '<Leader>ss', customize(sub.line))
            keymap('n', '<Leader>S', customize(sub.eol))
            keymap('x', '<Leader>s', customize(sub.visual))
            keymap('n', '<Leader>sx', sub_ex.operator)
            keymap('n', '<Leader>sxx', sub_ex.line)
            keymap('x', '<Leader>S', sub_ex.visual)
        end,
    },
    {
        'monaqa/dial.nvim',
        keys = {
            { '<C-a>', mode = { 'n', 'v' }, desc = 'Increment N to number' },
            { '<C-x>', mode = { 'n', 'v' }, desc = 'Decrement N from number' },
            { 'g<C-a>', mode = { 'n', 'v' }, desc = 'Increment N to number continuously' },
            { 'g<C-x>', mode = { 'n', 'v' }, desc = 'Decrement N from number continuously' },
            { '<Leader><C-a>', mode = { 'n', 'v' }, desc = 'Convert case next' },
            { '<Leader><C-x>', mode = { 'n', 'v' }, desc = 'Convert case previous' },
        },
        config = function()
            local augend = require('dial.augend')
            local config = require('dial.config')
            local options = {
                default = {
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.date.alias['%Y/%m/%d'],
                    augend.date.alias['%Y-%m-%d'],
                    augend.date.alias['%m/%d'],
                    augend.date.alias['%H:%M'],
                    augend.constant.alias.bool,
                    augend.semver.alias.semver,
                    augend.hexcolor.new { case = 'lower' },
                },
                extend_default = function(this, options)
                    local extended_options = {}
                    for _, v in ipairs(this.default) do
                        table.insert(extended_options, v)
                    end
                    for _, v in ipairs(options) do
                        table.insert(extended_options, v)
                    end
                    return extended_options
                end,
            }
            config.augends:register_group {
                default = options.default,
                case = {
                    augend.case.new {
                        types = { 'camelCase', 'snake_case', 'kebab-case' },
                        cyclic = true,
                    },
                    augend.case.new {
                        types = { 'PascalCase', 'SCREAMING_SNAKE_CASE' },
                        cyclic = true,
                    },
                },
            }
            local javascript_opts = options:extend_default {
                augend.constant.new { elements = { 'let', 'const' } },
            }
            config.augends:on_filetype {
                javascript = javascript_opts,
                typescript = javascript_opts,
                javascriptreact = javascript_opts,
                typescriptreact = javascript_opts,
            }

            local dial_map = require('dial.map')
            local keymap = vim.keymap.set
            keymap('n', '<C-a>', dial_map.inc_normal())
            keymap('n', '<C-x>', dial_map.dec_normal())
            keymap('v', '<C-a>', dial_map.inc_visual())
            keymap('v', '<C-x>', dial_map.dec_visual())
            keymap('n', 'g<C-a>', dial_map.inc_gnormal())
            keymap('n', 'g<C-x>', dial_map.dec_gnormal())
            keymap('v', 'g<C-a>', dial_map.inc_gvisual())
            keymap('v', 'g<C-x>', dial_map.dec_gvisual())
            keymap('n', '<Leader><C-a>', dial_map.inc_normal('case'))
            keymap('n', '<Leader><C-x>', dial_map.dec_normal('case'))
            keymap('v', '<Leader><C-a>', dial_map.inc_visual('case'))
            keymap('v', '<Leader><C-x>', dial_map.dec_visual('case'))
        end,
    },
    {
        'sQVe/sort.nvim',
        keys = {
            { 'go', mode = { 'x' }, desc = 'Sort the selection in ascending order' },
            { 'gO', mode = { 'x' }, desc = 'Sort the selection in descending order' },
            { 'g<C-o>', mode = { 'x' }, desc = 'Sort the selection by specifying arguments' },
        },
        cmd = 'Sort',
        config = function()
            -- List of delimiters, in descending order of priority, to automatically sort on.
            require('sort').setup { delimiters = { ',', '|', ';', ':', 's', 't' } }
            local keymap = vim.keymap.set
            keymap('x', 'go', ':Sort<CR>', { silent = true })
            keymap('x', 'gO', ':Sort!<CR>', { silent = true })
            keymap('x', 'g<C-o>', ':Sort ')
        end,
    },
    {
        'chrisgrieser/nvim-various-textobjs',
        event = { 'VeryLazy' },
        config = function()
            local textobjs = require('various-textobjs')
            textobjs.setup {}

            local keymap = vim.keymap.set
            keymap('o', 'gc', textobjs.multiCommentedLines,
                { desc = 'Consecutive, fully commented lines' })
            keymap({ 'o', 'x' }, 'iS', function() textobjs.subword('inner') end,
                { desc = 'inner subword' })
            keymap({ 'o', 'x' }, 'aS', function() textobjs.subword('outer') end,
                { desc = 'a subword' })
            keymap({ 'o', 'x' }, 'in', function() textobjs.number('inner') end,
                { desc = 'inner number' })
            keymap({ 'o', 'x' }, 'an', function() textobjs.number('outer') end,
                { desc = 'a number' })
        end,
    },
    {
        'kana/vim-niceblock',
        keys = { { 'I', mode = { 'v' } }, { 'gI', mode = { 'v' } }, { 'A', mode = { 'v' } } },
    },
}
