local M = {}

function M.is_absolute_path(path)
    if type(path) ~= 'string' then
        return false
    end
    return path:sub(1, 1) == '/' or path:match('^%a:[/\\]') ~= nil
end

return M
