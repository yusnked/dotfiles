local M = {}

M.abbrev_path = function(path, effort_width)
    effort_width = effort_width or 0
    if type(effort_width) ~= 'number' then
        error('Type error: the second argument must be of type number.')
        return
    end
    if path == '/' then
        return '/'
    end
    path, _ = path:gsub(os.getenv('HOME'), '~')

    local strwidth = vim.fn.strwidth
    local substitute = vim.fn.substitute
    local width = strwidth(path)
    local prev_path = path
    while width > effort_width do
        path = substitute(path, [[\v/([^.]|\..)[^/]+/]], '/\\1/', '')
        if path == prev_path then
            break
        end
        width = strwidth(path)
        prev_path = path
    end
    return path
end

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

M.exec_autocmds_filetype = function(opts)
    if vim.bo.filetype ~= '' then
        vim.schedule(function()
            vim.api.nvim_exec_autocmds({ 'FileType' }, opts)
        end)
    end
end

M.exec_autocmds_by_group_pattern = function(group_pattern, event, opts)
    opts = opts or {}
    for _, autocmd in ipairs(vim.api.nvim_get_autocmds { event = event }) do
        local group_name = autocmd.group_name
        if group_name and string.match(group_name, group_pattern) then
            opts.group = group_name
            vim.api.nvim_exec_autocmds(event, opts)
        end
    end
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

local set_operatorfunc = function(fn)
    _G.Operatorfunc = fn
    vim.opt.operatorfunc = 'v:lua.Operatorfunc'
end
M.set_keymap = function(mode, lhs, rhs, opts)
    opts = opts or {}
    local dotrepeat = not not opts.dotrepeat
    opts.dotrepeat = nil
    local operatorfunc = not not opts.operatorfunc
    opts.operatorfunc = nil
    if type(rhs) == 'function' then
        if dotrepeat then
            local wrapper = function()
                set_operatorfunc(rhs)
                vim.cmd('normal! ' .. vim.v.count .. 'g@l')
            end
            vim.keymap.set(mode, lhs, wrapper, opts)
            return
        elseif operatorfunc then
            local wrapper = function()
                set_operatorfunc(rhs)
                return 'g@'
            end
            opts.expr = true
            vim.keymap.set(mode, lhs, wrapper, opts)
            return
        end
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

return M
