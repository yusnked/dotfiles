local module = {}

local quickSelectPatterns = {
    [["[0-9a-z]{52}"]], -- nix-prefetch-git hash
}

local options = {
    audible_bell = 'Disabled',
    automatically_reload_config = false,
    check_for_updates = false,
    detect_password_input = true,
    disable_default_key_bindings = true,
    key_map_preference = 'Physical',
    macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL',
    quick_select_patterns = quickSelectPatterns,
    quote_dropped_files = 'Posix',
    scrollback_lines = 5000,
    send_composed_key_when_right_alt_is_pressed = false,
    term = 'wezterm',
    treat_east_asian_ambiguous_width_as_wide = false,
}

function module.apply_to_config(config)
    for k, v in pairs(options) do
        config[k] = v
    end
end

return module
