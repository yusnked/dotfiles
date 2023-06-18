local wezterm = require 'wezterm'
local module = {}

local options = {
    -- Font
    font = wezterm.font('HackGen Console NF'),
    font_size = 16.0,

    -- Color
    color_scheme = 'Japanesque',
    colors = {
        tab_bar = {
            active_tab = {
                bg_color = '#1E1E1E',
                fg_color = '#808080',
            },
        },
        visual_bell = '#404040',
    },

    -- Window
    window_decorations = "INTEGRATED_BUTTONS|RESIZE",

    -- Tab

    -- Visual Bell
    visual_bell = {
        fade_in_function = 'EaseIn',
        fade_in_duration_ms = 50,
        fade_out_function = 'EaseOut',
        fade_out_duration_ms = 50,
    },

}

function module.apply_to_config(config)
    for k, v in pairs(options) do
        config[k] = v
    end
end

return module

