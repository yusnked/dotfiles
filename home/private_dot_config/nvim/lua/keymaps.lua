local keymap = vim.keymap.set

-- leader key
keymap('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Normal mode
keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')
keymap('n', 'gj', 'j')
keymap('n', 'gk', 'k')
keymap('n', '<Esc><Esc>', ':<C-u>nohlsearch<CR>', { silent = true, desc = 'nohlsearch' })

-- Visual mode
-- 右クリックメニューでの "E335: Menu not defined for Insert mode" を防止.
keymap('v', '<RightMouse>', '<C-\\><C-g>gv<cmd>:popup! PopUp<CR>')

-- Command line
-- 履歴の<C-n><C-p>がnvim-cmpと競合する為
keymap('c', '<C-j>', '<Down>')
keymap('c', '<C-k>', '<Up>')
