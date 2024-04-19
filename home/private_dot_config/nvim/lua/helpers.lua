local M = {}

M.get_listed_buffers = function()
    local buffers = {}
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.fn.buflisted(buffer) == 1 then
            table.insert(buffers, buffer)
        end
    end

    return buffers
end

M.tbl_tostring = function(tbl, indent, is_nest)
    local newline = '\n'
    if vim.fn.has('unix') ~= 1 then
        newline = '\r\n'
    end
    if not indent then indent = 0 end
    local toprint = (is_nest and '' or string.rep(' ', indent)) .. '{' .. newline
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(' ', indent)
        if (type(k) == 'number') then
            toprint = toprint .. '[' .. k .. '] = '
        elseif (type(k) == 'string') then
            toprint = toprint .. k .. '= '
        end
        if (type(v) == 'number') then
            toprint = toprint .. v .. ',' .. newline
        elseif (type(v) == 'string') then
            toprint = toprint .. '\"' .. v .. '\",' .. newline
        elseif (type(v) == 'table') then
            toprint = toprint .. M.tbl_tostring(v, indent + 2, true) .. ',' .. newline
        else
            toprint = toprint .. '\"' .. tostring(v) .. '\",' .. newline
        end
    end
    toprint = toprint .. string.rep(' ', indent - 2) .. '}'
    return toprint
end
M.tbl_print = function(tbl)
    print(M.tbl_tostring(tbl))
end

return M
