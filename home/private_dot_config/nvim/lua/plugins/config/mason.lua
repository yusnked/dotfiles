local M = {}

local config_registry = require('self.lsp.registry')
local mason_registry = require('mason-registry')

---@param message string
---@param level 'INFO' | 'ERROR' | 'WARN'
local function notify(message, level)
    vim.notify(message, vim.log.levels[level], {
        title = 'mason.nvim',
    })
end

---@type table<string, string>
local lspconfig_to_package = {}

---@return table<string, string>
function M.get_lspconfig_to_package()
    if next(lspconfig_to_package) ~= nil then return lspconfig_to_package end

    for _, pkg_spec in ipairs(mason_registry.get_all_package_specs()) do
        local lspconfig_name = vim.tbl_get(pkg_spec, 'neovim', 'lspconfig')
        if lspconfig_name ~= nil then
            lspconfig_to_package[lspconfig_name] = pkg_spec.name or lspconfig_name
        end
    end
    return lspconfig_to_package
end

---@param lspconfig_name string
---@return PackageInstallOpts
local function build_install_opts(lspconfig_name)
    local spec = config_registry.specs_by_name[lspconfig_name]
    local opts = {}

    if spec and spec.version then
        opts.version = spec.version
    end

    return opts
end

---@param lspconfig_name string
local function install_package(lspconfig_name)
    local map = M.get_lspconfig_to_package()
    local pkg_name = map[lspconfig_name] or lspconfig_name

    local ok, pkg = pcall(mason_registry.get_package, pkg_name)
    if not ok then
        notify(('Unknown package: %s (for %s)'):format(pkg_name, lspconfig_name), 'ERROR')
        return
    end

    if pkg:is_installed() or pkg:is_installing() then return end

    notify(('Installing: %s (for %s)'):format(pkg_name, lspconfig_name), 'INFO')

    local opts = build_install_opts(lspconfig_name)
    pkg:install(opts, function(success, result)
        if not success then
            notify(('Install failed: %s (%s)')
                :format(pkg_name, tostring(result)), 'ERROR')
        end
    end)
end

---@param lspconfig_names string[]
function M.install_packages(lspconfig_names)
    mason_registry.refresh(vim.schedule_wrap(function(success)
        if not success then
            notify('Refresh failed.', 'ERROR')
            return
        end

        for _, lspconfig_name in ipairs(lspconfig_names) do
            install_package(lspconfig_name)
        end
    end))
end

---@param _ LazyPlugin
---@param opts MasonSettings
function M.config(_, opts)
    require('mason').setup(opts)

    -- self.lsp.registry にのってるやつを一括インストールするコマンド.
    vim.api.nvim_create_user_command('MasonInstallRegistered', function()
        local names = vim.tbl_keys(config_registry.specs_by_name)
        table.sort(names)
        M.install_packages(names)
    end, {
        desc = 'Install all Mason packages registered in self.lsp.registry',
    })
end

return M
