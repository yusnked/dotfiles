local vscode = require('vscode-neovim')
local keymap = vim.keymap.set
local nvim_input = vim.api.nvim_input

vim.opt.isprint = '1-255'

local change_all_occurrences = function()
    nvim_input('i')
    vscode.action('editor.action.changeAll')
end
keymap('n', 'g<C-r>', change_all_occurrences)

local go_to_file = function()
    vscode.action('workbench.action.quickOpen')
end
keymap('n', '<Leader>p', go_to_file)

local command_palette = function()
    vscode.action('workbench.action.showCommands')
end
keymap('n', '<Leader>P', command_palette)

local open_recent = function()
    vscode.action('workbench.action.openRecent')
end
keymap('n', '<Leader>r', open_recent)

local add_next_occurrence = function()
    nvim_input('i')
    vscode.action('editor.action.addSelectionToNextFindMatch')
end
keymap('n', '<D-d>', add_next_occurrence)
