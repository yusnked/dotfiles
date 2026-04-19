---@class self.lsp.ConfigSpec
---@field version? string
---@field format_on_write? boolean

---@class self.lsp.ConfigRegistry
---@field specs_by_name table<string, self.lsp.ConfigSpec>
---@field ft_to_config_names table<string, string[]>

---@type self.lsp.ConfigRegistry
return {
    specs_by_name = {
        lua_ls = { format_on_write = true },
        pyright = {},
    },
    ft_to_config_names = {
        lua = { 'lua_ls' },
        python = { 'pyright' },
    },
}
