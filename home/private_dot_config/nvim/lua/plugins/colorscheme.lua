return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        cond = NOT_VSCODE,
        build = function()
            require('nightfox').compile()
        end,
        config = function()
            require('nightfox').setup {
                palettes = {
                    carbonfox = { sel0 = '#404040' },
                },
                specs = {
                    carbonfox = { git = { changed = '#0081c0' } },
                },
            }
            vim.cmd.colorscheme('carbonfox')
        end,
    },
}
