local M = {}

M.execute_cmd = function(cmd)
    local handle = io.popen(cmd)
    local result = ''
    if handle then
        result = handle:read('*a')
        handle:close()
    end
    result = string.gsub(result, '%s+$', '')
    return result
end

M.flatten = function(tbl, result)
    result = result or {}
    for _, v in ipairs(tbl) do
        if type(v) == "table" then
            M.flatten(v, result)
        else
            table.insert(result, v)
        end
    end
    return result
end

M.get_listed_buffers = function()
    local buffers = {}
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.fn.buflisted(buffer) == 1 then
            table.insert(buffers, buffer)
        end
    end

    return buffers
end

M.get_mode_name = function()
    local mode = vim.fn.mode():match('^.')
    local mode_name = 'normal'
    if mode == 'n' then
        mode_name = 'normal'
    elseif mode == 'i' then
        mode_name = 'insert'
    elseif mode == 'v' or mode == 'V' or mode == '\19' or mode == '\22' or mode == 's' or mode == 'S' then
        mode_name = 'visual'
    elseif mode == 'c' then
        mode_name = 'command'
    elseif mode == 't' then
        mode_name = 'terminal'
    elseif mode == 'r' or mode == 'R' then
        mode_name = 'replace'
    end
    return mode_name
end

M.get_shell_path = function(fallback_shell)
    if type(fallback_shell) ~= 'string' or fallback_shell == '' then
        fallback_shell = '/bin/bash'
    end
    local bin_path = os.getenv('HOME') .. '/.local/bin/get-shell-path'
    local shell = M.execute_cmd(bin_path .. ' 2>/dev/null')
    if shell == '' then
        shell = fallback_shell
    end
    return shell
end

M.p = function(arg)
    vim.print(vim.inspect(arg))
end

return M
