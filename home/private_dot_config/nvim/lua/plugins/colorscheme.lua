return {
    {
        'EdenEast/nightfox.nvim',
        version = '*',
        lazy = false,
        priority = 1000,
        cond = NOT_VSCODE,
        opts = function()
            return {
                palettes = {
                    carbonfox = {
                        -- status line and float
                        bg0 = '#111111',
                        -- default bg
                        bg1 = '#1E1E1E',
                        -- visual selection bg
                        sel0 = '#505050',
                    }
                }
            }
        end,
        init = function()
            vim.cmd.colorscheme('carbonfox')
        end,
    },
}
