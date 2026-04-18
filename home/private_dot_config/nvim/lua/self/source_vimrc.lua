local vimrc = vim.fn.expand('~/.vimrc')
if vim.fn.filereadable(vimrc) == 1 then
    vim.g.is_extended_nvim = 1
    vim.cmd.source(vimrc)
end
