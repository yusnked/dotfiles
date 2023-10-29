-- disable bundled plugins
local bundledPlugins = {
    'did_indent_on',
    'did_install_default_menus',
    'did_install_syntax_menu',
    -- 'did_load_filetypes',
    'did_load_ftplugin',
    'loaded_2html_plugin',
    'loaded_gzip',
    'loaded_man',
    'loaded_matchit',
    'loaded_matchparen',
    -- 'loaded_netrw',
    -- 'loaded_netrwPlugin',
    'loaded_remote_plugins',
    'loaded_shada_plugin',
    'loaded_spellfile_plugin',
    'loaded_tarPlugin',
    'loaded_tutor_mode_plugin',
    'loaded_zipPlugin',
    'skip_loading_mswin',
}
for _, v in ipairs(bundledPlugins) do
    vim.g[v] = 1
end

if vim.g.vscode then
    NOT_VSCODE = false
else
    NOT_VSCODE = true
end

require('options')
require('keymaps')
require('commands')

-- lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins')

