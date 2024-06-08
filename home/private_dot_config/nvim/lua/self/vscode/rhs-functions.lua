local vscode = require('vscode')
local M = {}

M.add_next_occurrence = function()
    vscode.with_insert(function()
        vscode.action('editor.action.addSelectionToNextFindMatch')
    end)
end

M.change_all_occurrences = function()
    vscode.with_insert(function()
        vscode.action('editor.action.changeAll')
    end)
end

M.command_palette = function()
    vscode.action('workbench.action.showCommands')
end

M.go_to_file = function()
    vscode.action('workbench.action.quickOpen')
end

M.open_recent = function()
    vscode.action('workbench.action.openRecent')
end

return M
