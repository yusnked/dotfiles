local keydesc = require('plugins.util.keydesc')

---@type LazySpec
return {
    {
        'kylechui/nvim-surround',
        keys = {
            { 'ys', '<Plug>(nvim-surround-normal)', desc = 'Surround motion (surround)' },
            { 'yss', '<Plug>(nvim-surround-normal-cur)', desc = 'Surround line (surround)' },
            { 'cs', '<Plug>(nvim-surround-change)', desc = 'Change surround (surround)' },
            { 'ds', '<Plug>(nvim-surround-delete)', desc = 'Delete surround (surround)' },
            { 'S', '<Plug>(nvim-surround-visual)', mode = 'x', desc = 'Surround selection (surround)' },
        },
        init = function() vim.g.nvim_surround_no_mappings = true end,
        config = function()
            require('nvim-surround').setup { move_cursor = 'sticky' }
            require('lazy').load { plugins = { 'nvim-surround-wk' } }
        end,
    },
    {
        'gregorias/nvim-surround-wk',
        opts = {},
    },
    {
        'monaqa/dial.nvim',
        keys = keydesc.lazy {
            { '<C-a>', mode = { 'n', 'x' }, desc = 'Increment (dial)' },
            { '<C-x>', mode = { 'n', 'x' }, desc = 'Decrement (dial)' },
            { 'g<C-a>', desc = 'Increment additive repeat (dial)' },
            { 'g<C-x>', desc = 'Decrement additive repeat (dial)' },
            { 'g<C-a>', mode = 'x', desc = 'Increment sequence (dial)' },
            { 'g<C-x>', mode = 'x', desc = 'Decrement sequence (dial)' },
            { '<leader><C-a>', mode = { 'n', 'x' }, desc = 'Toggle case: snake ↔ camel (dial)' },
            { '<leader><C-x>', mode = { 'n', 'x' }, desc = 'Toggle case: snake ↔ kebab (dial)' },
        },
        config = function() require('plugins.config.dial').config() end,
    },
    {
        'gbprod/substitute.nvim',
        keys = keydesc.lazy {
            { '<leader>s', desc = 'Substitute (operator)' },
            { '<leader>ss', desc = 'Substitute line' },
            { '<leader>S', desc = 'Substitute to EOL' },
            { '<leader>s', mode = 'x', desc = 'Substitute selection' },
            { '<leader>sx', desc = 'Exchange (operator)' },
            { '<leader>sxx', desc = 'Exchange line' },
            { 'X', mode = 'x', desc = 'Exchange selection' },
        },
        config = function() require('plugins.config.substitute').config() end,
    },
    {
        'folke/flash.nvim',
        keys = function(plugin)
            local m = plugin.main
            local a = { actions = { S = 'next', s = 'prev' } }
            return {
                { 's', mode = { 'n', 'x', 'o' }, function() require(m).jump() end, desc = 'Flash' },
                { 'S', mode = { 'n', 'o' }, function() require(m).treesitter(a) end, desc = 'Flash Treesitter' },
                { 'r', mode = 'o', function() require(m).remote() end, desc = 'Remote Flash' },
            }
        end,
        main = 'flash',
        opts = {
            modes = { char = { enabled = false } },
            prompt = { prefix = { { '󱐋', 'FlashPromptIcon' } } },
        },
    },
    {
        'chrisgrieser/nvim-various-textobjs',
        keys = keydesc.lazy {
            { 'iS', mode = { 'o', 'x' }, desc = 'inner subword' },
            { 'aS', mode = { 'o', 'x' }, desc = 'subword' },
        },
        config = function() require('plugins.config.various-textobjs').config() end,
    },
    {
        'windwp/nvim-autopairs',
        event = { 'InsertEnter' },
        opts = { map_c_h = true, map_c_w = true },
    },
}
