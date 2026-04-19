local M = {}

local enable_format_on_write = require('self.lsp.features.format_on_write').enable

---@param ctx vim.api.keyset.create_autocmd.callback_args
function M.run(ctx)
    local client = assert(vim.lsp.get_client_by_id(ctx.data.client_id))

    enable_format_on_write(client, ctx)
end

return M
