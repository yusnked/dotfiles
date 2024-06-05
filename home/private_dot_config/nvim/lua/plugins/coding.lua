local desc = require('desc')

return {
    {
        'numToStr/Comment.nvim',
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        -- Desc is set by this plug-in.
        keys = desc.lazy_keys {
            { 'gc', mode = { 'n', 'x' } },
            { 'gb', mode = { 'n', 'x' } },
            { '<C-g>c', mode = 'i' },
        },
        init = function()
            vim.keymap.del('n', 'gcc')
        end,
        config = function()
            require('Comment').setup {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            }
            local insert_block_comment = function()
                local esc = require('helpers').get_escaped_key('<Esc>')
                vim.api.nvim_feedkeys(('|%sgblf|cl'):format(esc), 'm', false)
            end
            vim.keymap.set('i', '<C-g>c', insert_block_comment)
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
        keys = desc.lazy_keys {
            { '<C-a>', mode = { 'n', 'v' } },
            { '<C-x>', mode = { 'n', 'v' } },
            { 'g<C-a>', mode = { 'n', 'v' } },
            { 'g<C-x>', mode = { 'n', 'v' } },
            { '<Leader><C-a>', mode = { 'n', 'v' } },
            { '<Leader><C-x>', mode = { 'n', 'v' } },
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
        keys = desc.lazy_keys {
            { 'go', ':Sort<CR>', mode = 'x', silent = true },
            { 'gO', ':Sort!<CR>', mode = 'x', silent = true },
            { 'g<C-o>', ':Sort ', mode = 'x' },
        },
        cmd = 'Sort',
        opts = { delimiters = { ',', '|', ';', ':', 's', 't' } },
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
        keys = { desc.lazy_key { '<C-y>', mode = 'i' } },
        init = function()
            vim.g.user_emmet_mode = 'i'
        end,
    },
}
