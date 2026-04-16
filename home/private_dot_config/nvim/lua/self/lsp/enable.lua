local M = {}

local ft_to_config_specs = require("self.lsp.ft_to_config_specs")

---@param ft string
---@return string[]
local function get_config_specs(ft)
    local config_specs = ft_to_config_specs[ft]
    if not config_specs then return {} end
    if type(config_specs) == "string" then
        config_specs = { config_specs }
    end

    return config_specs
end

---@param config_specs string[]
local function enable_lsp(config_specs)
    local to_enable = vim.iter(config_specs)
        :map(function(config_spec) return (config_spec:gsub("@.*$", "")) end)
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

    local config_specs = get_config_specs(ft)
    if #config_specs == 0 then return end

    vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        if vim.bo[bufnr].filetype ~= ft then return end

        enable_lsp(config_specs)
    end, 50)
end

return M
