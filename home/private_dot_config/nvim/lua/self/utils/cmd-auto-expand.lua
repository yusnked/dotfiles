local M = {}

local auto_expand_cmd_enabled = true
M.set_enabled = function(enabled)
    auto_expand_cmd_enabled = enabled
end

local auto_expand_cmds = {}
local auto_expand_func = function(lhs_last)
    return function()
        if not auto_expand_cmd_enabled then
            return lhs_last
        end
        local key = vim.fn.getcmdtype() .. vim.fn.getcmdline()
        local rhs = auto_expand_cmds[lhs_last][key]
        local rhs_type = type(rhs)
        if rhs_type == 'string' then
            return '<C-u>' .. rhs
        elseif rhs_type == 'function' then
            return '<C-u>' .. rhs()
        else
            return lhs_last
        end
    end
end
M.create = function(lhs, rhs)
    if #lhs < 2 then
        vim.notify('create_immediately_cmd_abbrev:\ncreate_immediately_cmd_abbrev',
            vim.log.levels.ERROR)
        return
    end
    local lhs_except_last = lhs:sub(1, -2)
    local lhs_last = lhs:sub(-1)
    if not auto_expand_cmds[lhs_last] then
        auto_expand_cmds[lhs_last] = {}
    end
    auto_expand_cmds[lhs_last][':' .. lhs_except_last] = rhs
    vim.keymap.set('c', lhs_last, auto_expand_func(lhs_last), { expr = true })
end

return M
