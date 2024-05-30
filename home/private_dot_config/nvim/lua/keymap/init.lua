local func = require('keymap.functions')
local keymap = require('desc').set_keymap
local repeatable = require('helpers').repeatable

-- leader key
keymap('', '<Space>', '')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap({ 'n', 'v' }, 'j', 'gj')
keymap({ 'n', 'v' }, 'k', 'gk')
keymap({ 'n', 'v' }, 'gj', 'j')
keymap({ 'n', 'v' }, 'gk', 'k')
keymap('n', 'gJ', repeatable('<Cmd>JoinSpaceLess <Count><CR>'))
keymap('x', 'gJ', ':JoinSpaceLess<CR>', { silent = true })
keymap({ 'n', 'x' }, 'gf', 'gF')
keymap({ 'n', 'x' }, 'gF', 'gf')

keymap('n', '[b', ':bprevious<CR>', { silent = true })
keymap('n', ']b', ':bnext<CR>', { silent = true })
keymap('n', '[B', ':bfirst<CR>', { silent = true })
keymap('n', ']B', ':blast<CR>', { silent = true })
keymap('n', '[l', ':lprevious<CR>', { silent = true })
keymap('n', ']l', ':lnext<CR>', { silent = true })
keymap('n', '[L', ':lfirst<CR>', { silent = true })
keymap('n', ']L', ':llast<CR>', { silent = true })
keymap('n', '[q', ':cprevious<CR>', { silent = true })
keymap('n', ']q', ':cnext<CR>', { silent = true })
keymap('n', '[Q', ':cfirst<CR>', { silent = true })
keymap('n', ']Q', ':clast<CR>', { silent = true })

keymap('x', 'gC', func.copy_and_comment_out)

keymap('v', '<RightMouse>', '<C-\\><C-g>gv<cmd>:popup! PopUp<CR>',
    { desc = 'Popup Menu (prevent error E335)' })

keymap('c', '<C-b>', '<Left>')
keymap('c', '<C-f>', '<Right>')
keymap('c', '<C-n>', '<Down>')
keymap('c', '<C-p>', '<Up>')
keymap('c', '<Down>', '<C-n>')
keymap('c', '<Up>', '<C-p>')
