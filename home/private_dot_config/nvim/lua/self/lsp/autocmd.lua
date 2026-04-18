local M = {}

---@type table<integer, table<integer, integer[]>>
local registry = {}

-- NOTE: 重複排除を augroup に任せてるので空の augroup が残る問題がある.
---@param bufnr integer
---@param client_id integer
---@param event string|string[]
---@param opts vim.api.keyset.create_autocmd
---@return integer
function M.register(bufnr, client_id, event, opts)
    local id = vim.api.nvim_create_autocmd(event, opts)

    registry[bufnr] = registry[bufnr] or {}
    registry[bufnr][client_id] = registry[bufnr][client_id] or {}
    table.insert(registry[bufnr][client_id], id)

    return id
end

---@param bufnr integer
---@param client_id integer
function M.clear(bufnr, client_id)
    local ids = registry[bufnr] and registry[bufnr][client_id]
    if not ids then return end

    for _, id in ipairs(ids) do
        pcall(vim.api.nvim_del_autocmd, id)
    end

    registry[bufnr][client_id] = nil
    if vim.tbl_isempty(registry[bufnr]) then
        registry[bufnr] = nil
    end
end

return M
