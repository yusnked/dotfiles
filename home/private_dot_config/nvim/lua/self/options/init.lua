vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 2
vim.opt.tabline = '%!""'
vim.opt.showtabline = 2

vim.opt.inccommand = 'split'

vim.opt.updatetime = 200
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    callback = function()
        vim.opt.updatetime = 4000
    end,
    once = true,
})

-- Maps
local rhs = require('self.options.functions.map-rhs')
local keymap = require('self.desc').set_keymap
local repeatable = require('self.helpers').repeatable

keymap('n', 'gJ', repeatable('<Cmd>JoinSpaceLess <Count><CR>'))
keymap('x', 'gJ', ':JoinSpaceLess<CR>', { silent = true })

keymap('n', 'p', rhs.reindent_put('p'))
keymap('n', 'P', rhs.reindent_put('P'))

keymap('x', 'gC', rhs.copy_and_comment_out)

keymap('v', '<RightMouse>', '<C-\\><C-g>gv<cmd>:popup! PopUp<CR>',
    { desc = 'Popup Menu (prevent error E335)' })

-- Commands
local create_command = vim.api.nvim_create_user_command
local cmd_func = require('self.options.functions.command')

create_command('JoinSpaceless', cmd_func.join_spaceless,
    { range = true, nargs = '?', desc = 'Join lines without spaces' })

create_command('CmdAutoExpandOn', function()
    require('self.utils.cmd-auto-expand').set_enabled(true)
end, { desc = 'Enable AutoExpandAbbrevCmd' })
create_command('CmdAutoExpandOff', function()
    require('self.utils.cmd-auto-expand').set_enabled(false)
end, { desc = 'Disable AutoExpandAbbrevCmd' })

-- Abbrevs
vim.cmd([[
    cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ?
    \   [getchar(), ''][1] .. "%s///g<Left><Left>" : 's'
]])
