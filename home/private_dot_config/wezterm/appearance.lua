local wezterm = require('wezterm')
local module = {}

local color_scheme_name = 'carbonfox'
local color_scheme = wezterm.color.get_builtin_schemes()[color_scheme_name]

local choose_fg_color = function(fg_dark, fg_light, bg_color)
    local parse_color = function(color)
        local red, _ = color:gsub('^#(%x%x)%x%x%x%x$', '%1')
        local green, _ = color:gsub('^#%x%x(%x%x)%x%x$', '%1')
        local blue, _ = color:gsub('^#%x%x%x%x(%x%x)$', '%1')
        return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
    end
    local get_rbg_for_calculate_luminance = function(_color)
        local color = _color / 255
        if color <= 0.03928 then
            return color / 12.92
        else
            return ((color + 0.055) / 1.055) ^ 2.4
        end
    end
    local get_relative_luminance = function(color)
        local red, green, blue = table.unpack(color)
        local r = get_rbg_for_calculate_luminance(red)
        local g = get_rbg_for_calculate_luminance(green)
        local b = get_rbg_for_calculate_luminance(blue)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    end
    local get_contrast_ratio = function(color1, color2)
        local luminance1 = get_relative_luminance(color1)
        local luminance2 = get_relative_luminance(color2)
        local bright = math.max(luminance1, luminance2)
        local dark = math.min(luminance1, luminance2)
        return (bright + 0.05) / (dark + 0.05)
    end

    local parsed_bg_color = parse_color(bg_color)
    local darkRatio = get_contrast_ratio(parsed_bg_color, parse_color(fg_dark))
    local lightRatio = get_contrast_ratio(parsed_bg_color, parse_color(fg_light))
    return lightRatio < darkRatio and fg_dark or fg_light
end

local options = {
    -- Font
    font = wezterm.font('HackGen Console NF'),
    font_size = 16.0,

    -- Color
    color_scheme = color_scheme_name,
    colors = {
        tab_bar = {
            active_tab = {
                bg_color = color_scheme.background,
                fg_color = choose_fg_color('#333333', '#909090', color_scheme.background),
            },
            background = '#333333',
        },
        visual_bell = '#404040',
    },

    -- Window
    window_decorations = 'INTEGRATED_BUTTONS|RESIZE',
    integrated_title_button_alignment = 'Left',
    integrated_title_buttons = { 'Close' },

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
