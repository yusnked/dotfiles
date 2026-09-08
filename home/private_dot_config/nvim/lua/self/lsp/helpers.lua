local M = {}

---@param msg string
---@param level 'INFO'|'WARN'|'ERROR'
function M.notify(msg, level)
    vim.notify(msg, vim.log.levels[level], { title = 'self.lsp' })
end

---@param specs table<string, self.lsp.Spec>
---@return table<string, string[]> ft_to_lsp_names
function M.index_by_filetype(specs)
    local ft_to_lsp_names = vim.defaulttable(function() return {} end)
    for lsp_name, spec in pairs(specs) do
        for _, filetype in ipairs(spec.filetypes) do
            table.insert(ft_to_lsp_names[filetype], lsp_name)
        end
    end

    setmetatable(ft_to_lsp_names, nil)
    return ft_to_lsp_names
end

---@type table<string, boolean>
local done_filetypes = {}

--- 対象バッファがロードされていて filetype が変わっていない状態で,
--- その filetype が初めて渡されたときに true を返す.
---@param buf integer
---@param filetype string
---@return boolean
function M.should_enable(buf, filetype)
    if done_filetypes[filetype]
        or not vim.api.nvim_buf_is_loaded(buf)
        or vim.bo[buf].filetype ~= filetype then
        return false
    end

    done_filetypes[filetype] = true
    return true
end

---@type table<integer, table<integer, integer>>
local augroups = vim.defaulttable(function() return {} end)

---@param buf integer
---@param client_id integer
---@param client_name string
---@return integer
function M.get_augroup(buf, client_id, client_name)
    local augroup_id = augroups[buf][client_id]
    if augroup_id then
        return augroup_id
    end

    local group_name = ('self.lsp.buf:%d.%s:%d'):format(buf, client_name, client_id)
    augroup_id = vim.api.nvim_create_augroup(group_name, {})
    augroups[buf][client_id] = augroup_id

    return augroup_id
end

---@param buf integer
---@param client_id integer
function M.del_augroup(buf, client_id)
    local augroup_id = augroups[buf][client_id]
    if augroup_id == nil then
        return
    end

    pcall(vim.api.nvim_del_augroup_by_id, augroup_id)
    augroups[buf][client_id] = nil
end

return M
