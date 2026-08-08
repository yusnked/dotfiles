-- タブを移動する.
-- Count は prev, next では移動回数,
-- first, last では移動先のタブ番号として扱う.
---@param kind 'prev' | 'next' | 'first' | 'last'
---@param count? integer Default: 0
return function(kind, count)
    local cnt = count or 0
    local cnt1 = (cnt == 0) and 1 or cnt

    -- タブ番号順にタブ ID が並んでいる配列.
    local tab_ids = vim.api.nvim_list_tabpages()
    local last = #tab_ids

    if last <= 1 then return end

    local target_nr
    if kind == 'prev' or kind == 'next' then
        local dir = (kind == 'next') and 1 or -1
        local current_nr = vim.fn.tabpagenr()

        target_nr = ((current_nr - 1 + dir * cnt1) % last) + 1
    elseif kind == 'first' or kind == 'last' then
        target_nr = (cnt ~= 0) and cnt or (kind == 'first' and 1 or last)
        target_nr = math.max(1, math.min(target_nr, last))
    else
        return
    end

    vim.api.nvim_set_current_tabpage(tab_ids[target_nr])
end
