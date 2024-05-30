vim.cmd([[
    cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's'
]])

vim.api.nvim_create_user_command('AbbrevCmdAutoExpandOn', function()
    require('abbrev.cmd-auto-expand').set_enabled(true)
end, { desc = 'Enable AutoExpandAbbrevCmd' })
vim.api.nvim_create_user_command('AbbrevCmdAutoExpandOff', function()
    require('abbrev.cmd-auto-expand').set_enabled(false)
end, { desc = 'Disable AutoExpandAbbrevCmd' })
