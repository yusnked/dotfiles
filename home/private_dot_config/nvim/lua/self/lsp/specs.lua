---@class self.lsp.Spec
---@field filetypes string[]
---@field cmd? string
---@field version? string
---@field features? self.lsp.Features

---@type table<string, self.lsp.Spec>
return {
    lua_ls = {
        filetypes = { 'lua' },
        features = {
            format_on_write = true,
        },
    },
    pyright = {
        filetypes = { 'python' },
    },
}
