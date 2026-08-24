---@type LazySpec
return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-mini/mini.icons' },
        event = 'VeryLazy',
        -- 起動時 Statusline を消してちらつきを抑える.
        init = function() vim.o.laststatus = 0 end,
        config = function() require('plugins.config.lualine').config() end,
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
}
