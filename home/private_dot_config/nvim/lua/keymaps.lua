local keymap = require('helpers').set_keymap

-- leader key
keymap('', '<Space>', '')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')
keymap('n', 'gj', 'j')
keymap('n', 'gk', 'k')
keymap('n', 'gJ', function() vim.cmd.JoinSpaceLess(vim.v.count) end, { dotrepeat = true })
keymap('x', 'gJ', ':JoinSpaceLess<CR>', { silent = true })
keymap('n', 'gf', '<Cmd>GoFileOrXdgOpen<CR>')
keymap('x', 'gf', 'gF')
keymap({ 'n', 'x' }, 'gF', 'gf')

-- Prevent error "E335: Menu not defined for Insert mode".
keymap('v', '<RightMouse>', '<C-\\><C-g>gv<cmd>:popup! PopUp<CR>')

keymap('c', '<C-b>', '<Left>')
keymap('c', '<C-f>', '<Right>')
keymap('c', '<C-n>', '<Down>')
keymap('c', '<C-p>', '<Up>')
keymap('c', '<Down>', '<C-n>')
keymap('c', '<Up>', '<C-p>')

-- Abbreviation:
vim.cmd([[
    cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's'
]])
