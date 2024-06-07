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

local escaped_keys = {}
M.get_escaped_key = function(key)
    if escaped_keys[key] == nil then
        escaped_keys[key] = vim.api.nvim_replace_termcodes(key, true, false, true)
    end
    return escaped_keys[key]
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

M.repeatable = function(rhs, set_ga)
    local type = type(rhs)
    local fn
    if type == 'function' then
        fn = rhs
    elseif type == 'string' then
        fn = function(count, _)
            local replaced, _ = rhs:gsub('<[Cc][Oo][Uu][Nn][Tt]>', count)
            vim.api.nvim_input(replaced)
        end
    else
        return rhs
    end
    local set_ga_flag = false
    return function()
        local count = vim.v.count
        if count < 1 then
            count = 1
        end
        local reg = vim.v.register
        local normal_ga = { ('"%s%dg@l'):format(reg, count), bang = true }
        _G.Operatorfunc = function()
            if set_ga and set_ga_flag then
                set_ga_flag = false
                return
            end
            fn(count, reg)
            if set_ga and not set_ga_flag then
                set_ga_flag = true
                vim.cmd.normal(normal_ga)
            end
        end
        vim.opt.operatorfunc = 'v:lua.Operatorfunc'
        vim.cmd.normal(normal_ga)
    end
end

M.split_keys = function(keys)
    local ret = {}
    local bracketed_key = ''
    local is_inside_bracket = false
    for key in keys:gmatch('.') do
        if key == '<' then
            is_inside_bracket = true
        elseif key == '>' then
            is_inside_bracket = false
            table.insert(ret, '<' .. bracketed_key .. '>')
            bracketed_key = ''
        else
            if is_inside_bracket then
                bracketed_key = bracketed_key .. key
            else
                table.insert(ret, key)
            end
        end
    end
    return ret
end

return M
