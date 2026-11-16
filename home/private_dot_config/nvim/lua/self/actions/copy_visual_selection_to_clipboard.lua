return function()
    local mode = vim.fn.visualmode()
    if mode == '' then return end

    local text = vim.fn.getregion(
        vim.fn.getpos("'<"),
        vim.fn.getpos("'>"),
        { type = mode }
    )
    if #text == 0 then return end

    vim.fn.setreg('+', text, mode)
end
