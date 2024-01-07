return {
    {
        'numToStr/Comment.nvim',
        version = '*',
        dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
        keys = { { 'gc', mode = { 'n', 'v' } }, { 'gb', mode = { 'n', 'v' } } },
        config = function()
            require('Comment').setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end,
    },
    {
        'kylechui/nvim-surround',
        version = '*',
        keys = { 'ys', 'yS', 'ds', 'cs', 'cS', { 'S', mode = 'v' }, { 'gS', mode = 'v' } },
        opts = {},
    },
    {
        'gbprod/substitute.nvim',
        version = '*',
        keys = {
            {
                's',
                function() return require('substitute').operator() end,
                mode = 'n',
                desc = 'Substitute.nvim Operator',
            },
            {
                'ss',
                function() return require('substitute').line() end,
                mode = 'n',
                desc = 'Substitute.nvim Line',
            },
            {
                'S',
                function() return require('substitute').eol() end,
                mode = 'n',
                desc = 'Substitute.nvim Eol',
            },
            {
                's',
                function() return require('substitute').visual() end,
                mode = 'x',
                desc = 'Substitute.nvim Visual',
            },
            {
                'sx',
                function() return require('substitute.exchange').operator() end,
                mode = 'n',
                desc = 'Substitute.nvim Exchange-operator',
            },
            {
                'sxx',
                function() return require('substitute.exchange').line() end,
                mode = 'n',
                desc = 'Substitute.nvim Exchange-line',
            },
            {
                'X',
                function() return require('substitute.exchange').visual() end,
                mode = 'x',
                desc = 'Substitute.nvim Exchange-visual',
            },
        },
        opts = {},
    },
    {
        'monaqa/dial.nvim',
        keys = {
            {
                '<C-a>',
                function() return require('dial.map').inc_normal() end,
                expr = true,
                desc = 'Increment'
            },
            {
                '<C-x>',
                function() return require('dial.map').dec_normal() end,
                expr = true,
                desc = 'Decrement'
            },
            {
                'g<C-a>',
                function() return require('dial.map').inc_gnormal() end,
                expr = true,
                desc = 'Increment'
            },
            {
                'g<C-x>',
                function() return require('dial.map').dec_gnormal() end,
                expr = true,
                desc = 'Decrement'
            },
            {
                '<C-a>',
                function() return require('dial.map').inc_visual() end,
                mode = 'v',
                expr = true,
                desc = 'Increment'
            },
            {
                '<C-x>',
                function() return require('dial.map').dec_visual() end,
                mode = 'v',
                expr = true,
                desc = 'Decrement'
            },
            {
                'g<C-a>',
                function() return require('dial.map').inc_gvisual() end,
                mode = 'v',
                expr = true,
                desc = 'Increment'
            },
            {
                'g<C-x>',
                function() return require('dial.map').dec_gvisual() end,
                mode = 'v',
                expr = true,
                desc = 'Decrement'
            },
        },
        config = function()
            local augend = require('dial.augend')
            require('dial.config').augends:register_group({
                default = {
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.date.alias['%Y/%m/%d'],
                    augend.date.alias['%Y-%m-%d'],
                    augend.date.alias['%m/%d'],
                    augend.date.alias['%H:%M'],
                    augend.constant.alias.ja_weekday_full,
                    augend.constant.alias.bool,
                    augend.semver.alias.semver,
                    augend.constant.new({ elements = { 'let', 'const' } }),
                },
            })
        end,
    },
    {
        'echasnovski/mini.align',
        version = '*',
        keys = {
            { 'gA', mode = { 'n', 'v' }, desc = 'mini.align start with preview' },
            { 'ga', mode = { 'n', 'v' }, desc = 'mini.align start' },
        },
        opts = {},
    },
    {
        'echasnovski/mini.bracketed',
        version = '*',
        opts = {},
    },
    {
        'sQVe/sort.nvim',
        cmd = 'Sort',
        opts = {
            -- List of delimiters, in descending order of priority, to automatically
            -- sort on.
            delimiters = {
                ',',
                '|',
                ';',
                ':',
                's', -- Space
                't', -- Tab
            },
        },
    },
    { 'bronson/vim-visual-star-search', keys = { '*', mode = 'v', desc = 'vim visual star search' } },
    {
        'windwp/nvim-autopairs',
        event = 'VeryLazy',
        cond = NOT_VSCODE,
        -- <C-h>で空の括弧やクォートなどを一気に消せるようにする
        opts = { map_c_h = true },
    },
}
