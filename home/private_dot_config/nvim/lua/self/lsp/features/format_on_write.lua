local M = {}

---@param client vim.lsp.Client
---@param buf integer
---@param augroup integer
function M.enable(client, buf, augroup)
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = buf,
            callback = function()
                if not require('self.lsp.features').status.format_on_write then
                    return
                end

                vim.lsp.buf.format { bufnr = buf, id = client.id, timeout_ms = 1500 }
            end,
        })
    end
end

return M
