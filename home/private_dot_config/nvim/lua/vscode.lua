local vscode = require('vscode-neovim')
local keymap = vim.keymap.set

local change_all_occurrences = function()
    vim.api.nvim_input('i')
    vscode.action('editor.action.changeAll')
end
keymap('n', 'g<C-r>', change_all_occurrences)
