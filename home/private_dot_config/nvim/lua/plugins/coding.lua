return {
    {
        'numToStr/Comment.nvim',
        version = '*',
        dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
        keys = {
            { 'gc', mode = { 'n', 'v' } },
            { 'gb', mode = { 'n', 'v' } },
        },
        config = function()
            require('Comment').setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end,
    },
    {
        'kylechui/nvim-surround',
        version = '*',
        keys = {
            { 'ys', mode = 'n' },
            { 'yS', mode = 'n' },
            { 'ds', mode = 'n' },
            { 'cs', mode = 'n' },
            { 'cS', mode = 'n' },
            { 'S', mode = 'v' },
            { 'gS', mode = 'v' },
        },
        config = true,
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
                function()
                    return require('dial.map').inc_normal()
                end,
                mode = 'n',
                expr = true,
                desc = 'Increment'
            },
            {
                '<C-x>',
                function()
                    return require('dial.map').dec_normal()
                end,
                mode = 'n',
                expr = true,
                desc = 'Decrement'
            },
            {
                'g<C-a>',
                function()
                    return require('dial.map').inc_gnormal()
                end,
                mode = 'n',
                expr = true,
                desc = 'Increment'
            },
            {
                'g<C-x>',
                function()
                    return require('dial.map').dec_gnormal()
                end,
                mode = 'n',
                expr = true,
                desc = 'Decrement'
            },
            {
                '<C-a>',
                function()
                    return require('dial.map').inc_visual()
                end,
                mode = 'v',
                expr = true,
                desc = 'Increment'
            },
            {
                '<C-x>',
                function()
                    return require('dial.map').dec_visual()
                end,
                mode = 'v',
                expr = true,
                desc = 'Decrement'
            },
            {
                'g<C-a>',
                function()
                    return require('dial.map').inc_gvisual()
                end,
                mode = 'v',
                expr = true,
                desc = 'Increment'
            },
            {
                'g<C-x>',
                function()
                    return require('dial.map').dec_gvisual()
                end,
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
    {
        'bronson/vim-visual-star-search',
        keys = { '*', mode = 'v', desc = 'vim visual star search' },
    },
    {
        'windwp/nvim-autopairs',
        event = 'VeryLazy',
        cond = NOT_VSCODE,
        -- <C-h>で空の括弧やクォートなどを一気に消せるようにする
        opts = { map_c_h = true },
    },
    -- {
    --     'gbprod/yanky.nvim',
    --     version = '*',
    --     dependencies = 'kkharji/sqlite.lua',
    --     keys = {
    --         'y', 'd',
    --         { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, silent = true, desc = 'YankyPutAfter' },
    --         { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, silent = true, desc = 'YankyPutBefore' },
    --         { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, silent = true, desc = 'YankyGPutAfter' },
    --         { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, silent = true, desc = 'YankyGPutBefore' },
    --         { '<C-n>', '<Plug>(YankyCycleForward)', mode = 'n', silent = true, desc = 'YankyCycleForward' },
    --         { '<C-p>', '<Plug>(YankyCycleBackward)', mode = 'n', silent = true, desc = 'YankyCycleBackward' },
    --
    --         { ']p', '<Plug>(YankyPutIndentAfterLinewise)', mode = 'n', silent = true, desc = 'YankyPutIndentAfterLinewise' },
    --         { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', mode = 'n', silent = true, desc = 'YankyPutIndentBeforeLinewise' },
    --         { ']P', '<Plug>(YankyPutIndentAfterLinewise)', mode = 'n', silent = true, desc = 'YankyPutIndentAfterLinewise' },
    --         { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', mode = 'n', silent = true, desc = 'YankyPutIndentBeforeLinewise' },
    --
    --         { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', mode = 'n', silent = true, desc = 'YankyPutIndentAfterShiftRight' },
    --         { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', mode = 'n', silent = true, desc = 'YankyPutIndentAfterShiftLeft' },
    --         { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', mode = 'n', silent = true, desc = 'YankyPutIndentBeforeShiftRight' },
    --         { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', mode = 'n', silent = true, desc = 'YankyPutIndentBeforeShiftLeft' },
    --
    --         { '=p', '<Plug>(YankyPutAfterFilter)', mode = 'n', silent = true, desc = 'YankyPutAfterFilter' },
    --         { '=P', '<Plug>(YankyPutBeforeFilter)', mode = 'n', silent = true, desc = 'YankyPutBeforeFilter' },
    --     },
    --     opts = {
    --         ring = {
    --             history_length = 30,
    --             storage = 'sqlite',
    --             sync_with_numbered_registers = true,
    --             cancel_event = 'update',
    --         },
    --     },
    -- },
}

