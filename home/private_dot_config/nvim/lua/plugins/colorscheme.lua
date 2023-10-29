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
            vim.cmd.colorscheme('Carbonfox')
        end,
    },
    -- {
    --     'catppuccin/nvim',
    --     name = 'catppuccin',
    --     version = '*',
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         flavour = 'mocha',
    --         background = { -- :h background
    --             light = "latte",
    --             dark = "mocha",
    --         },
    --         transparent_background = false, -- disables setting the background color.
    --         show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
    --         term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    --         dim_inactive = {
    --             enabled = false, -- dims the background color of inactive window
    --             shade = "dark",
    --             percentage = 0.15, -- percentage of the shade to apply to the inactive window
    --         },
    --         no_italic = true,
    --         no_bold = false,
    --         no_underline = false,
    --         styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    --             comments = {},
    --             conditionals = {},
    --             loops = {},
    --             functions = {},
    --             keywords = {},
    --             strings = {},
    --             variables = {},
    --             numbers = {},
    --             booleans = {},
    --             properties = {},
    --             types = {},
    --             operators = {},
    --         },
    --         color_overrides = {},
    --         custom_highlights = {},
    --         integrations = {
    --             barbar = true,
    --             cmp = true,
    --             gitsigns = true,
    --             telescope = true,
    --             -- https://github.com/catppuccin/nvim#integrations
    --         }
    --     },
    --     init = function()
    --         vim.cmd.colorscheme('catppuccin')
    --     end,
    -- },
}

