local wezterm = require 'wezterm'

-- config init
local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- use zsh installed by nix
local shell = ''
local nix_zsh = os.getenv('HOME') .. '/.nix-profile/bin/zsh'
if os.execute('test -x ' .. nix_zsh) then
    shell = nix_zsh
else
    shell = os.getenv('SHELL')
end
config.default_prog = { shell, '-l' }

local modules = {
    'appearance',
    'keybinds',
    'options',
    'status',
}

for _, v in ipairs(modules) do
    require(v).apply_to_config(config)
end

return config

