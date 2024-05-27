local desc = require('desc')

return {
    {
        'numToStr/Comment.nvim',
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        -- Desc is set by this plug-in.
        keys = desc.lazy_keys {
            { 'gc', mode = { 'n', 'x' } },
            { 'gb', mode = { 'n', 'x' } },
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
        keys = desc.lazy_keys {
            'ys', 'yss', 'yS', 'ySS', 'ds', 'cs', 'cS',
            { 'S', mode = 'x' },
            { 'gS', mode = 'x' },
            { '<C-g>s', mode = 'i' },
            { '<C-g>S', mode = 'i' },
        },
        opts = {},
    },
    {
        'gbprod/substitute.nvim',
        keys = desc.lazy_keys {
            '<Leader>s', '<Leader>ss', '<Leader>S', '<Leader>sx', '<Leader>sxx',
            { '<Leader>s', mode = 'x' },
            { '<Leader>S', mode = 'x' },
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
        keys = { { 'I', mode = { 'x' } }, { 'gI', mode = { 'x' } }, { 'A', mode = { 'x' } } },
    },
    {
        'mattn/emmet-vim',
        keys = { { '<C-y>', mode = 'i', desc = 'Emmet' } },
        init = function()
            vim.g.user_emmet_mode = 'i'
        end,
    },
}
