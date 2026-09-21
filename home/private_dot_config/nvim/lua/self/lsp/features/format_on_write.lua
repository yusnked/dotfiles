local M = {}

---@param buf integer
---@param client_id integer
local function format(buf, client_id)
    if not require('self.lsp.features').status.format_on_write then
        return
    end

    vim.lsp.buf.format { bufnr = buf, id = client_id, timeout_ms = 1500 }
end

---@param client vim.lsp.Client
---@param buf integer
---@param augroup integer
function M.enable(client, buf, augroup)
    -- LSP の dynamic registration に対応するため, 判定を最初の BufWritePre まで遅延.
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = buf,
        once = true,
        callback = function()
            if not client:supports_method('textDocument/willSaveWaitUntil')
                and client:supports_method('textDocument/formatting') then
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = augroup,
                    buffer = buf,
                    callback = function() format(buf, client.id) end,
                })
                format(buf, client.id)
            end
        end,
    })
end

return M
