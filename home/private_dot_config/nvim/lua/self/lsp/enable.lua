local M = {}

local helpers = require('self.lsp.helpers')

---@param lsp_names string[]
local function enable(lsp_names)
    ---@type string[]
    local to_enable = vim.iter(lsp_names)
        :filter(function(name) return not vim.lsp.is_enabled(name) end)
        :totable()

    if #to_enable > 0 then
        ---@class self.lsp.LspEnablePreData
        ---@field lsp_names string[]

        vim.api.nvim_exec_autocmds('User', {
            pattern = 'LspEnablePre',
            modeline = false,
            ---@type self.lsp.LspEnablePreData
            data = {
                lsp_names = to_enable,
            },
        })

        vim.lsp.enable(to_enable)
    end
end

---@type table<string, boolean>
local checked_lsp_names = {}

--- インストールが必要か lsp_name 毎に一度だけ確認する.
---@param lsp_name string
---@param spec self.lsp.Spec
---@return boolean
local function needs_install(lsp_name, spec)
    if checked_lsp_names[lsp_name] then
        return false
    end

    local cmd = vim.lsp.config[lsp_name].cmd
    local executable

    if type(cmd) == 'table' then
        executable = cmd[1]
    elseif spec.cmd then
        executable = spec.cmd
    else
        local msg = (
            'LSP: %s\n\nCannot determine the executable from lspconfig.\nSet self.lsp.Spec.cmd'
        ):format(lsp_name)
        helpers.notify(msg, 'WARN')

        checked_lsp_names[lsp_name] = true
        return false
    end
    ---@cast executable string

    checked_lsp_names[lsp_name] = true
    return vim.fn.executable(executable) ~= 1
end

---@param lsp_names string[]
---@param lsp_specs table<string, self.lsp.Spec>
local function request_install(lsp_names, lsp_specs)
    ---@type string[]
    local to_install = vim.iter(lsp_names)
        :filter(function(name) return needs_install(name, lsp_specs[name]) end)
        :totable()

    if #to_install > 0 then
        ---@class self.lsp.LspRequestInstallData
        ---@field lsp_names string[]

        vim.api.nvim_exec_autocmds('User', {
            pattern = 'LspRequestInstall',
            modeline = false,
            ---@type self.lsp.LspRequestInstallData
            data = {
                lsp_names = to_install,
            },
        })
    end
end

---@param filetype string
---@param lsp_specs table<string, self.lsp.Spec>
---@param ft_to_lsp_names table<string, string[]>
function M.for_filetype(filetype, lsp_specs, ft_to_lsp_names)
    local lsp_names = ft_to_lsp_names[filetype]

    enable(lsp_names)

    request_install(lsp_names, lsp_specs)
end

return M
