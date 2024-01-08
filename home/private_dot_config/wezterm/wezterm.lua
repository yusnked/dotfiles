local wezterm = require 'wezterm'

-- config init
local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- use zsh installed by nix if it exists
local script = wezterm.home_dir .. '/.config/wezterm/run_shell.sh'
config.default_prog = { script }

config.set_environment_variables = {
    DOTS_TERMINAL = 'wezterm',
}

local modules = {
    'appearance',
    'events',
    'keybinds',
    'options',
    'status',
}

for _, v in ipairs(modules) do
    require(v).apply_to_config(config)
end

return config
