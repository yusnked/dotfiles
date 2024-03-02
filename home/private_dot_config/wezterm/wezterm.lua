local wezterm = require 'wezterm'

-- Config init.
local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Set default program.
local function get_shell_path()
    local bin_path = wezterm.home_dir .. '/.local/bin/get-shell-path'
    local pcall_result, success, stdout, _ = pcall(wezterm.run_child_process, { bin_path })
    local shell_path = '/bin/bash'
    if pcall_result and success then
        shell_path = stdout
    end
    return shell_path
end
config.default_prog = { get_shell_path(), '-l' }

-- Set environment variables.
local _, dots_os, _ = wezterm.run_child_process { 'uname', '-s' }
config.set_environment_variables = {
    DOTS_OS = dots_os:gsub('\n$', ''),
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
