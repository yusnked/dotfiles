local rhs = require('self.vscode.rhs-functions')
local keymap = vim.keymap.set

-- Options
vim.opt.isprint = '1-255'

-- Keymaps
keymap('n', 'g<C-r>', rhs.change_all_occurrences)
keymap({ 'n', 'x' }, '<D-d>', rhs.add_next_occurrence)

keymap('n', '<Leader>p', rhs.go_to_file)
keymap('n', '<Leader>P', rhs.command_palette)
keymap('n', '<Leader>r', rhs.open_recent)
