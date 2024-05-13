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
                groups = {
                    all = {
                        RainbowDelimiterBlue = { fg = 'palette.blue.base' },
                        RainbowDelimiterCyan = { fg = 'palette.yellow.base' },
                        RainbowDelimiterGreen = { fg = 'palette.green.base' },
                        RainbowDelimiterOrange = { fg = 'palette.orange.base' },
                        RainbowDelimiterRed = { fg = 'palette.red.base' },
                        RainbowDelimiterViolet = { fg = 'palette.magenta.base' },
                        RainbowDelimiterYellow = { fg = 'palette.yellow.base' },
                    },
                },
            }
            vim.cmd.colorscheme('carbonfox')
        end,
    },
}
