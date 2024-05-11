local keymap = require('helpers').set_keymap

-- leader key
keymap('', '<Space>', '')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('n', 'j', 'gj', { desc = 'Down' })
keymap('n', 'k', 'gk', { desc = 'Up' })
keymap('n', 'gj', 'j', { desc = 'Down' })
keymap('n', 'gk', 'k', { desc = 'Up' })
keymap('n', 'gJ', function()
    vim.cmd.JoinSpaceLess(vim.v.count)
end, { dotrepeat = true, desc = 'Join lines without leading whitespace' })
keymap('x', 'gJ', ':JoinSpaceLess<cr>', { silent = true, desc = 'Join lines without leading whitespace' })
keymap('n', 'gf', '<Cmd>GoFileOrXdgOpen<CR>', { desc = 'Go to file or xdg-open under cursor' })
keymap('x', 'gf', 'gF', { desc = 'Go to file selected' })
keymap('n', 'gF', 'gf', { desc = 'Go to file under cursor' })
keymap('x', 'gF', 'gf', { desc = 'Go to file selected' })

keymap('n', '[b', ':bprevious<CR>', { silent = true, desc = 'Previous buffer' })
keymap('n', ']b', ':bnext<CR>', { silent = true, desc = 'Next buffer' })
keymap('n', '[B', ':bfirst<CR>', { silent = true, desc = 'First buffer' })
keymap('n', ']B', ':blast<CR>', { silent = true, desc = 'Last buffer' })
keymap('n', '[l', ':lprevious<CR>', { silent = true, desc = 'Previous location list' })
keymap('n', ']l', ':lnext<CR>', { silent = true, desc = 'Next location list' })
keymap('n', '[L', ':lfirst<CR>', { silent = true, desc = 'First location list' })
keymap('n', ']L', ':llast<CR>', { silent = true, desc = 'Last location list' })
keymap('n', '[q', ':cprevious<CR>', { silent = true, desc = 'Previous quickfix list' })
keymap('n', ']q', ':cnext<CR>', { silent = true, desc = 'Next quickfix list' })
keymap('n', '[Q', ':cfirst<CR>', { silent = true, desc = 'First quickfix list' })
keymap('n', ']Q', ':clast<CR>', { silent = true, desc = 'Last quickfix list' })

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
