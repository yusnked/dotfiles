return {
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            style = 'night',
            on_highlights = function(hl, c)
                -- gitsigns.nvim
                hl.GitSignsAdd = { fg = c.green }
                hl.GitSignsChange = { fg = c.orange }
                hl.GitSignsDelete = { fg = c.red }
            end,
        },
        config = function(_, opts)
            require('tokyonight').setup(opts)
            vim.cmd.colorscheme('tokyonight')
        end,
    },
}
