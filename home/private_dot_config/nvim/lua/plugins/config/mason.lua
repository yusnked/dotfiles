local M = {}

local lsp_specs = require('self.lsp.specs')
local registry = require('mason-registry')

---@param msg string
---@param level 'INFO' | 'WARN' | 'ERROR'
local function notify(msg, level)
    vim.notify(msg, vim.log.levels[level], { title = 'plugins.mason' })
end

---@type table<string, string>?
local lsp_name_to_mason_name

local function build_lsp_name_to_mason_name()
    lsp_name_to_mason_name = {}

    for _, package_spec in ipairs(registry.get_all_package_specs()) do
        local lsp_name = vim.tbl_get(package_spec, 'neovim', 'lspconfig')

        if lsp_name then
            lsp_name_to_mason_name[lsp_name] = package_spec.name or lsp_name
        end
    end
end

---@param lsp_name string
---@param mason_name string
local function install_package(lsp_name, mason_name)
    local ok, pkg = pcall(registry.get_package, mason_name)
    if not ok then
        notify(('Unknown package: %s (lspconfig: %s)'):format(mason_name, lsp_name), 'ERROR')
        return
    end

    if pkg:is_installed() or pkg:is_installing() then
        return
    end

    local version = vim.tbl_get(lsp_specs[lsp_name] or {}, 'version')

    -- 非同期でインストールする.
    notify(('Installing: %s (lspconfig: %s)'):format(mason_name, lsp_name), 'INFO')
    pkg:install({ version = version }, vim.schedule_wrap(function(success, result)
        if not success then
            notify(('Failed to install: %s (lspconfig: %s)\n\n%s'):format(mason_name, lsp_name, tostring(result)),
                'ERROR')
            return
        end

        notify(('Installed: %s (lspconfig: %s)'):format(mason_name, lsp_name), 'INFO')
        vim.lsp.enable(lsp_name)
    end))
end

---@param lsp_names string[]
function M.install_packages(lsp_names)
    -- 非同期でレジストリを更新する. 成功したらインストールに進む.
    registry.refresh(vim.schedule_wrap(function(success)
        if not success then
            notify('Failed to refresh Mason registry.', 'ERROR')
            return
        end

        if lsp_name_to_mason_name == nil then
            build_lsp_name_to_mason_name()
        end
        ---@cast lsp_name_to_mason_name table<string, string>

        for _, lsp_name in ipairs(lsp_names) do
            local mason_name = lsp_name_to_mason_name[lsp_name] or lsp_name
            install_package(lsp_name, mason_name)
        end
    end))
end

return M
