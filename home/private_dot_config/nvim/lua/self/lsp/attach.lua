local M = {}

local autocmd_register = require("self.lsp.autocmd").register

---@param client vim.lsp.Client
---@param ctx vim.api.keyset.create_autocmd.callback_args
local function enable_format_on_write(client, ctx)
    if not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting") then
        local group_name = "self_lsp_format_" .. client.name .. "_b" .. tostring(ctx.buf)
        autocmd_register(ctx.buf, client.id, "BufWritePre", {
            group = vim.api.nvim_create_augroup(group_name, {}),
            buffer = ctx.buf,
            callback = function()
                vim.lsp.buf.format { bufnr = ctx.buf, id = client.id, timeout_ms = 1000 }
            end,
        })
    end
end

---@param ctx vim.api.keyset.create_autocmd.callback_args
function M.run(ctx)
    local client = assert(vim.lsp.get_client_by_id(ctx.data.client_id))

    enable_format_on_write(client, ctx)
end

return M
