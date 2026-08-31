local term_program = vim.env.TERM_PROGRAM

if term_program == 'ghostty' then
    require('profiles.ghostty')
end
