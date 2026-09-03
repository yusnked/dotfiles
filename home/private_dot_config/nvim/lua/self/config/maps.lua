local map = vim.keymap.set

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
map('n', ' ', '<Nop>')

map({ 'n', 'x' }, 'gf', 'gF', { desc = 'Go to file and line' })
map({ 'n', 'x' }, 'gF', 'gf', { desc = 'Go to file' })

map('x', 'p', 'P', { desc = 'Put' })
map('x', 'P', 'p', { desc = 'Put and replace register' })

map('c', '<C-a>', '<Home>', { desc = 'Move cursor to start' })
map('c', '<C-b>', '<Left>', { desc = 'Move cursor left' })
map('c', '<C-f>', '<Right>', { desc = 'Move cursor right' })

map('c', '<C-x><C-a>', '<C-a>', { desc = 'Insert all completion matches' })
map('c', '<C-x><C-f>', '<C-f>', { desc = 'Open command-line window' })

map('c', '<C-n>', '<Down>', { desc = 'Next matching history' })
map('c', '<C-p>', '<Up>', { desc = 'Previous matching history' })
map('c', '<Down>', '<C-n>', { desc = 'Next completion or history' })
map('c', '<Up>', '<C-p>', { desc = 'Previous completion or history' })

map('n', 'x', '"_x', { desc = 'Delete character without yanking' })
map('x', 'x', '"_x', { desc = 'Delete without yanking' })

map({ 'n', 'x' }, '+', '"+', { desc = 'Use system clipboard register' })
map('n', '++', function()
    vim.fn.setreg('+', vim.fn.getreg('"'), vim.fn.getregtype('"'))
    vim.notify('Copied @" to clipboard.', vim.log.levels.INFO)
end, { desc = 'Copy unnamed register to system clipboard' })

map('n', 'g=', "'[=']", { desc = 'Indent the last changed or yanked text' })

-- Linewise Visual でも Blockwise Visual の複数行編集をできるようにする.
map('x', 'I', function() require('self.actions.visual_line_insert')('I') end,
    { desc = 'Insert before selected text' })
map('x', 'A', function() require('self.actions.visual_line_insert')('A') end,
    { desc = 'Append after selected text' })
map('x', 'gI', function() require('self.actions.visual_line_insert')('gI') end,
    { desc = 'Insert at column 1 (V)' })

-- マッチ箇所を画面中央にしてfoldがあれば開く.
map('n', 'n', 'nzzzv', { desc = 'Next search result and center', silent = true })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result and center', silent = true })

-- * # で次のマッチにで移動しない.
map('n', '*', '<Cmd>keepjumps silent! normal! *N<CR>', { desc = 'Set search to word under cursor' })
map('n', '#', '<Cmd>keepjumps silent! normal! #N<CR>', { desc = 'Set backward search to word under cursor' })

map('x', '*', function() require('self.actions.visual_set_search')('forward') end,
    { desc = 'Search forward for visual selection' })
map('x', '#', function() require('self.actions.visual_set_search')('backward') end,
    { desc = 'Search backward for visual selection' })

map('n', '<Esc><Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- <C-x><C-f>ファイル補完時に/で更にファイル補完.
map('i', '/', function()
    local info = vim.fn.complete_info { 'mode', 'selected' }
    return (info.mode == 'files' and info.selected >= 0) and '<C-x><C-f>' or '/'
end, { desc = 'Continue file completion in subdirectory', expr = true })

-- タブ移動. Count は [t 系 はその数ぶん移動. [T 系はその番号のタブへ移動.
map('n', '[t', function() require('self.actions.tab_jump')('prev', vim.v.count) end,
    { desc = 'Previous tab' })
map('n', ']t', function() require('self.actions.tab_jump')('next', vim.v.count) end,
    { desc = 'Next tab' })
map('n', '[T', function() require('self.actions.tab_jump')('first', vim.v.count) end,
    { desc = 'First tab' })
map('n', ']T', function() require('self.actions.tab_jump')('last', vim.v.count) end,
    { desc = 'Last tab' })

map('n', '<leader>td', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { desc = 'Toggle buffer diagnostics' })

map({ 'n', 'x' }, '<leader>j', function()
    require('self.actions.jump_vertical')('down', 'motion')
end, { desc = 'Jump down by virtual column' })
map({ 'n', 'x' }, '<leader>k', function()
    require('self.actions.jump_vertical')('up', 'motion')
end, { desc = 'Jump up by virtual column' })
map('o', '<leader>j', function()
    require('self.actions.jump_vertical')('down', 'operator')
end, { desc = 'Jump down by virtual column' })
map('o', '<leader>k', function()
    require('self.actions.jump_vertical')('up', 'operator')
end, { desc = 'Jump up by virtual column' })
