local repeatable = require('self.helpers').repeatable
local M = {}

M.copy_and_comment_out = function()
    local esc = require('self.helpers').get_escaped_key('<Esc>')
    vim.api.nvim_feedkeys(esc, 'n', false)
    if vim.filetype.get_option(vim.bo.filetype, 'commentstring') ~= '' then
        vim.schedule(function()
            local getpos = vim.fn.getpos
            local getregion = vim.fn.getregion
            local selected_text = getregion(getpos("'<"), getpos("'>"), { type = 'V' })
            vim.api.nvim_feedkeys("gvgc'>", 'm', true)
            vim.defer_fn(function()
                vim.cmd.undojoin()
                local pos_line = vim.api.nvim_win_get_cursor(0)[1]
                vim.api.nvim_buf_set_lines(0, pos_line, pos_line, false, selected_text)
                vim.api.nvim_feedkeys('j', 'n', true)
            end, 50)
        end)
    end
end

M.reindent_put = function(type)
    return repeatable(function(count, reg)
        local pos = vim.api.nvim_win_get_cursor(0)
        if type:match('p$') then
            pos[1] = pos[1] + 1
        end
        vim.cmd.normal { ('"%s%d%s'):format(reg, count, type), bang = true }
        if vim.fn.getregtype(reg) == 'V' then
            vim.cmd.normal { "'[V']=", bang = true }
            vim.api.nvim_win_set_cursor(0, pos)
            vim.cmd.normal { '^', bang = true }
        end
    end, true)
end

return M
