local wezterm = require 'wezterm'

-- config init
local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

local get_shell_path = wezterm.home_dir .. '/.local/bin/get-shell-path'
local pcall_result, success, stdout, _ = pcall(wezterm.run_child_process, { get_shell_path })
local shell_path = '/bin/bash'
if pcall_result and success then
    shell_path = stdout
end
config.default_prog = { shell_path, '-l' }

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
