NOT_NEOVIDE = not vim.g.neovide
NOT_VSCODE = vim.g.vscode ~= 1

vim.g.neovide_input_ime = true

require('self.options')

local vimrc = vim.fn.expand('~/.vimrc')
if vim.fn.filereadable(vimrc) == 1 then
    vim.g.is_extended_nvim = 1
    vim.cmd.source(vimrc)
end

if vim.g.vscode == 1 then
    require('self.vscode')
else
    Helper = require('self.helpers')
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
