local M = {}

local registry = require('self.lsp.registry')

---@param ft string
---@return string[]
local function get_config_names(ft)
    local config_names = registry.ft_to_config_names[ft]
    if not config_names then return {} end
    return config_names
end

---@param config_names string[]
local function enable_lsp(config_names)
    local to_enable = vim.iter(config_names)
        :filter(function(config_name) return not vim.lsp.is_enabled(config_name) end)
        :totable()

    if #to_enable > 0 then
        vim.lsp.enable(to_enable)
    end
end

---@param ctx vim.api.keyset.create_autocmd.callback_args
function M.run(ctx)
    local bufnr = ctx.buf
    local ft = ctx.match

    local config_names = get_config_names(ft)
    if #config_names == 0 then return end

    vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        if vim.bo[bufnr].filetype ~= ft then return end

        enable_lsp(config_names)
    end, 50)
end

return M
