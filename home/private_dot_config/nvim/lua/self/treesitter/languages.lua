---@class self.treesitter.LanguageSpec
---@field filetypes? string[]
---@field indent? boolean

---@type table<string, self.treesitter.LanguageSpec>
return {
    awk = {},
    bash = { filetypes = { 'bash', 'sh' }, indent = true },
    css = { indent = true },
    diff = {},
    dockerfile = {},
    gitcommit = {},
    gitignore = {},
    html = { indent = true },
    http = {},
    javascript = { indent = true },
    json = { indent = true },
    json5 = { filetypes = { 'json5', 'jsonc' } },
    lua = { indent = true },
    markdown = {},
    markdown_inline = {},
    python = { indent = true },
    query = {},
    regex = {},
    ruby = { indent = true },
    rust = { indent = true },
    scss = { indent = true },
    sql = { indent = true },
    toml = { indent = true },
    tsx = { filetypes = { 'typescriptreact' }, indent = true },
    typescript = { indent = true },
    vim = {},
    vimdoc = {},
    xml = { indent = true },
    yaml = { indent = true },
    zsh = {},
}
