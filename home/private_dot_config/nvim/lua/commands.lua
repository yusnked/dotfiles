local create_command = vim.api.nvim_create_user_command

create_command('GoFileOrXdgOpen', function(tbl)
    local file = vim.fn.expand('<cfile>')
    if file:match('^https?://') then
        file, _ = file:gsub('^https?://', 'https://')
        vim.fn.system { 'xdg-open', file }
    else
        local head = vim.fn.expand('%:h')
        if head == '' then
            file = vim.fn.expand('<cfile>:p')
        else
            file = head .. '/' .. file
        end
        if vim.fn.system { 'file', '--mime', file }:match('charset=binary') then
            vim.fn.system { 'xdg-open', file }
        else
            vim.cmd.normal { args = { 'gF' }, bang = true }
        end
    end
end, { range = true, desc = 'Go file or xdg-open' })

create_command('JoinSpaceLess', function(tbl)
    local line_start, line_end
    local join_count = tonumber(tbl.args:match('^%d+'))
    if type(join_count) == 'number' and join_count > 1 then
        line_start = vim.fn.line('.') - 1
        line_end = line_start + join_count
    else
        line_start = tbl.line1 - 1
        line_end = tbl.line2
        if line_end - line_start == 1 then
            line_end = line_end + 1
        end
    end

    if line_end - line_start > 100 then
        vim.notify('JoinSpaceLess: Join should be no more than 100 lines.', vim.log.levels.WARN)
        return
    end

    local joined_line = ''
    for index, line in ipairs(vim.api.nvim_buf_get_lines(0, line_start, line_end, false)) do
        local trimmed_line = line
        if index ~= 1 then
            trimmed_line, _ = line:gsub('^%s*', '')
        end
        joined_line = joined_line .. trimmed_line
    end
    vim.api.nvim_buf_set_lines(0, line_start, line_end, false, { joined_line })
end, { range = true, nargs = '?', desc = 'Join lines without spaces' })
