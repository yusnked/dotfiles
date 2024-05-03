local keymap = vim.keymap.set
local create_command = vim.api.nvim_create_user_command

-- leader key
keymap('', '<Space>', '')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')
keymap('n', 'gj', 'j')
keymap('n', 'gk', 'k')
keymap({ 'n', 'x' }, 'gJ', ':JoinSpaceLess<CR>', { silent = true })
keymap('n', 'gf', function()
    local cfile = vim.fn.expand('<cfile>')
    if cfile:match('^https?://') then
        cfile, _ = cfile:gsub('^https?://', 'https://')
        vim.fn.system { 'xdg-open', cfile }
    else
        local head = vim.fn.expand('%:h')
        if head == '' then
            cfile = vim.fn.expand('<cfile>:p')
        else
            cfile = head .. '/' .. cfile
        end
        if vim.fn.system { 'file', '--mime', cfile }:match('charset=binary') then
            vim.fn.system { 'xdg-open', cfile }
        else
            vim.cmd('normal! gF')
        end
    end
end)
keymap('x', 'gf', 'gF')
keymap({ 'n', 'x' }, 'gF', 'gf')

-- Prevent error "E335: Menu not defined for Insert mode".
keymap('v', '<RightMouse>', '<C-\\><C-g>gv<cmd>:popup! PopUp<CR>')

keymap('c', '<C-b>', '<Left>')
keymap('c', '<C-f>', '<Right>')

-- User command
create_command('JoinSpaceLess', function(arg)
    local line_start = arg.line1 - 1
    local line_end = arg.line2
    if line_end - line_start == 1 then
        line_end = line_end + 1
    end
    local joined_line = ''
    for index, line in ipairs(vim.api.nvim_buf_get_lines(0, line_start, line_end, false)) do
        local trimmed_line = line
        if index ~= 1 then
            trimmed_line, _ = line:gsub('^%s*', '')
        end
        joined_line = joined_line .. trimmed_line
    end
    vim.api.nvim_buf_set_lines(0, line_start, line_end, false, { joined_line })
end, { range = true, desc = 'Join lines without spaces' })

-- Abbreviation:
vim.cmd([[
    cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's'
]])
