local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(_)
    -- Change font size according to dpi
    wezterm.on('window-focus-changed', function(window, _)
        local dpi = window:get_dimensions().dpi

        if dpi == wezterm.GLOBAL.prevDpi then
            return
        end

        local overrides = window:get_config_overrides() or {}
        overrides.font_size = math.floor(dpi / 10.0 + 0.5) + 2

        window:set_config_overrides(overrides)

        wezterm.GLOBAL.prevDpi = dpi
    end)

end

return module

