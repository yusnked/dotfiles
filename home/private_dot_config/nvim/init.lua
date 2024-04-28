NOT_VSCODE = vim.g.vscode ~= 1

require('options')
require('keymaps')
require('autocmd')

if not NOT_VSCODE then
    require('vscode')
else
    Helper = require('helpers')
end

-- lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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
    defaults = {
        lazy = true,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                -- 'editorconfig',
                'gzip',
                'health',
                'man',
                -- 'matchit',
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
