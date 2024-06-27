local M = {}

M.join_spaceless = function(tbl)
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
end

return M
