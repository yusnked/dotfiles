DISABLE_ALL_PLUGINS = false
NOT_VSCODE = (not DISABLE_ALL_PLUGINS) and vim.g.vscode ~= 1

require('options')
require('keymaps')
require('commands')
require('autocmd')

if vim.g.vscode == 1 then
    require('vscode')
else
    Helper = require('helpers')
end

-- lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins', {
    defaults = { lazy = true, cond = not DISABLE_ALL_PLUGINS },
    install = { colorscheme = { 'carbonfox', 'default' } },
    performance = {
        rtp = {
            disabled_plugins = {
                -- 'editorconfig',
                'gzip',
                'health',
                'man',
                'matchit',
                'matchparen',
                'netrwPlugin',
                -- 'nvim',
                'rplugin',
                -- 'shada',
                'spellfile',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
})
