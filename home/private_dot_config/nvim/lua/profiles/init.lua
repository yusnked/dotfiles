local term_program = vim.env.TERM_PROGRAM

if vim.g.neovide then
    require('profiles.neovide')
elseif term_program == 'ghostty' then
    require('profiles.ghostty')
end
