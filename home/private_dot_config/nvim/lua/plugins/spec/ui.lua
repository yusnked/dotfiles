return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-mini/mini.icons' },
        event = 'VeryLazy',
        init = function()
            vim.opt.laststatus = 0
        end,
        config = function()
            require('plugins.config.lualine').setup()
        end,
    },
    {
        'folke/which-key.nvim',
        dependencies = { 'nvim-mini/mini.icons' },
        event = 'VeryLazy',
        keys = {
            { '<leader>?', function() require('which-key').show() end, mode = { 'n', 'x' }, desc = 'Show keymaps' },
        },
        main = 'which-key',
        opts = {
            delay = function(ctx)
                return ctx.plugin and 0 or 500
            end,
        },
    },
    {
        'sphamba/smear-cursor.nvim',
        event = 'VeryLazy',
        main = 'smear_cursor',
        opts = {
            smear_insert_mode = false,
            min_vertical_distance_smear = 2,
            min_horizontal_distance_smear = 6,
        },
    },
}
