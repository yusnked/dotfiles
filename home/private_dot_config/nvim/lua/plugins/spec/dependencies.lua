return {
    {
        "nvim-mini/mini.icons",
        config = function(plugin)
            local icons = require(plugin.name)
            local function get(category, name)
                local glyph, hl = icons.get(category, name)
                return { glyph = glyph, hl = hl }
            end
            icons.setup {
                filetype = {
                    fyler = get("default", "directory"),
                },
            }
            icons.mock_nvim_web_devicons()
        end,
    },
    { "nvim-lua/plenary.nvim" },
}
