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
-- *で選択範囲で検索
-- keymap('v', '*', '"vy/\\V<C-r>=substitute(escape(@v,"\\/"),"\\n","\\\\n","g")<CR><CR>',
--     { silent = true, desc = '' })

-- Command line
-- 履歴の<C-n><C-p>がnvim-cmpと競合する為
keymap('c', '<C-j>', '<Down>')
keymap('c', '<C-k>', '<Up>')

