local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local get_mode = vim.api.nvim_get_mode

local toggle_relativenumber_id = augroup('toggle-relativenumber', {})
autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
    pattern = '*',
    group = toggle_relativenumber_id,
    callback = function()
        if vim.o.number and get_mode().mode ~= 'i' then
            vim.opt.relativenumber = true
        end
    end,
})
autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
    pattern = '*',
    group = toggle_relativenumber_id,
    callback = function()
        if vim.o.number then
            vim.opt.relativenumber = false
            vim.cmd.redraw()
        end
    end,
})
