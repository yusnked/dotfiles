return {
    {
        'numToStr/Comment.nvim',
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        keys = { { 'gc', mode = { 'n', 'v' } }, { 'gb', mode = { 'n', 'v' } } },
        config = function()
            require('Comment').setup {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            }
        end,
    },
    {
        'kylechui/nvim-surround',
        keys = { 'ys', 'yS', 'ds', 'cs', 'cS', { 'S', mode = 'v' }, { 'gS', mode = 'v' } },
        opts = {},
    },
    {
        'ggandor/leap.nvim',
        dependencies = { 'tpope/vim-repeat' },
        keys = {
            { 's', mode = { 'n', 'x', 'o' } },
            { 'S', mode = { 'n' } },
            { 'gs', mode = { 'n', 'x', 'o' } },
        },
        config = function()
            require('leap').setup {}
            local keymap = vim.keymap.set
            keymap({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
            keymap({ 'n' }, 'S', '<Plug>(leap-from-window)')

            -- Select Tree-sitter nodes.
            local api = vim.api
            local ts = vim.treesitter
            local function get_ts_nodes()
                if not pcall(ts.get_parser) then return end
                local wininfo = vim.fn.getwininfo(api.nvim_get_current_win())[1]
                local cur_node = ts.get_node()
                if not cur_node then return end
                local nodes = { cur_node }
                local parent = cur_node:parent()
                while parent do
                    table.insert(nodes, parent)
                    parent = parent:parent()
                end
                local targets = {}
                local startline, startcol, endline, endcol
                for _, node in ipairs(nodes) do
                    startline, startcol, endline, endcol = node:range()
                    local startpos = { startline + 1, startcol + 1 }
                    local endpos = { endline + 1, endcol + 1 }
                    if startline + 1 >= wininfo.topline then
                        table.insert(targets, { pos = startpos, altpos = endpos })
                    end
                    if endline + 1 <= wininfo.botline then
                        table.insert(targets, { pos = endpos, altpos = startpos })
                    end
                end
                if #targets >= 1 then return targets end
            end
            local function select_node_range(target)
                local mode = api.nvim_get_mode().mode
                if not mode:match('no?') then vim.cmd('normal! ' .. mode) end
                vim.fn.cursor(target.pos[1], target.pos[2])
                local v = mode:match('V') and 'V' or mode:match('�') and '�' or 'v'
                vim.cmd('normal! ' .. v)
                vim.fn.cursor(target.altpos[1], target.altpos[2])
            end
            local function leap_ts()
                require('leap').leap {
                    target_windows = { api.nvim_get_current_win() },
                    targets = get_ts_nodes,
                    action = select_node_range,
                }
            end
            keymap({ 'n', 'x', 'o' }, 'gs', leap_ts, { desc = 'Select Tree-sitter nodes' })
        end,
    },
    {
        'ggandor/flit.nvim',
        dependencies = { 'ggandor/leap.nvim', 'tpope/vim-repeat' },
        keys = {
            { 'f', mode = { 'n', 'x', 'o' } },
            { 'F', mode = { 'n', 'x', 'o' } },
            { 't', mode = { 'n', 'x', 'o' } },
            { 'T', mode = { 'n', 'x', 'o' } },
        },
        opts = {
            labeled_modes = 'nvo',
            multiline = false,
        },
    },
    {
        'gbprod/substitute.nvim',
        keys = { { '<Leader>s', mode = { 'n', 'x' } }, '<Leader>ss', { '<Leader>S', mode = { 'n', 'x' } }, '<Leader>sx', '<Leader>sxx' },
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
            keymap('n', '<Leader>s', customize(sub.operator), { desc = 'Substitute.nvim Operator' })
            keymap('n', '<Leader>ss', customize(sub.line), { desc = 'Substitute.nvim Line' })
            keymap('n', '<Leader>S', customize(sub.eol), { desc = 'Substitute.nvim Eol' })
            keymap('x', '<Leader>s', customize(sub.visual), { desc = 'Substitute.nvim Visual' })
            keymap('n', '<Leader>sx', sub_ex.operator, { desc = 'Substitute.nvim Exchange-operator' })
            keymap('n', '<Leader>sxx', sub_ex.line, { desc = 'Substitute.nvim Exchange-line' })
            keymap('x', '<Leader>S', sub_ex.visual, { desc = 'Substitute.nvim Exchange-visual' })
        end,
    },
    {
        'monaqa/dial.nvim',
        keys = {
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
            keymap('n', '<C-a>', dial_map.inc_normal(), { desc = 'dial.nvim Increment Normal' })
            keymap('n', '<C-x>', dial_map.dec_normal(), { desc = 'dial.nvim Decrement Normal' })
            keymap('v', '<C-a>', dial_map.inc_visual(), { desc = 'dial.nvim Increment Visual' })
            keymap('v', '<C-x>', dial_map.dec_visual(), { desc = 'dial.nvim Decrement Visual' })
            keymap('n', 'g<C-a>', dial_map.inc_gnormal(), { desc = 'dial.nvim Increment GNormal' })
            keymap('n', 'g<C-x>', dial_map.dec_gnormal(), { desc = 'dial.nvim Decrement GNormal' })
            keymap('v', 'g<C-a>', dial_map.inc_gvisual(), { desc = 'dial.nvim Increment GVisual' })
            keymap('v', 'g<C-x>', dial_map.dec_gvisual(), { desc = 'dial.nvim Decrement GVisual' })

            keymap('n', '<Leader><C-a>', dial_map.inc_normal('case'), { desc = 'dial.nvim Increment Case Normal' })
            keymap('n', '<Leader><C-x>', dial_map.dec_normal('case'), { desc = 'dial.nvim Decrement Case Normal' })
            keymap('v', '<Leader><C-a>', dial_map.inc_visual('case'), { desc = 'dial.nvim Increment Case Visual' })
            keymap('v', '<Leader><C-x>', dial_map.dec_visual('case'), { desc = 'dial.nvim Decrement Case Visual' })
        end,
    },
    {
        'sQVe/sort.nvim',
        keys = { { 'go', mode = { 'x' } }, { 'gO', mode = { 'x' } } },
        cmd = 'Sort',
        config = function()
            -- List of delimiters, in descending order of priority, to automatically sort on.
            require('sort').setup { delimiters = { ',', '|', ';', ':', 's', 't' } }
            local keymap = vim.keymap.set
            keymap('x', 'go', ':Sort<CR>', { silent = true, desc = 'sort.nvim' })
            keymap('x', 'gO', ':Sort!<CR>', { silent = true, desc = 'sort.nvim' })
            keymap('x', 'g<C-o>', ':Sort ', { desc = 'sort.nvim' })
        end,
    },
    {
        'chrisgrieser/nvim-various-textobjs',
        event = { 'VeryLazy' },
        config = function()
            local textobjs = require('various-textobjs')
            textobjs.setup {}

            local keymap = vim.keymap.set
            keymap({ 'o' }, 'gc', textobjs.multiCommentedLines,
                { desc = 'various-textobjs multiCommentedLines' })
            keymap({ 'o', 'x' }, 'iS', function() textobjs.subword('inner') end,
                { desc = 'various-textobjs subword inner' })
            keymap({ 'o', 'x' }, 'aS', function() textobjs.subword('outer') end,
                { desc = 'various-textobjs subword outer' })
            keymap({ 'o', 'x' }, 'in', function() textobjs.number('inner') end,
                { desc = 'various-textobjs number inner' })
            keymap({ 'o', 'x' }, 'an', function() textobjs.number('outer') end,
                { desc = 'various-textobjs number outer' })
        end,
    },
    {
        'andymass/vim-matchup',
        version = '*',
        event = { 'VeryLazy' },
        config = function()
            require('helpers').exec_autocmds_filetype { group = 'matchup_filetype' }
        end,
    },
    {
        'kana/vim-niceblock',
        keys = { { 'I', mode = { 'v' } }, { 'gI', mode = { 'v' } }, { 'A', mode = { 'v' } } },
    },
    {
        'echasnovski/mini.bracketed',
        keys = { '[', ']' },
        opts = {
            buffer = { suffix = 'b', options = {} },
            quickfix = { suffix = 'q', options = {} },
        },
    },
}
