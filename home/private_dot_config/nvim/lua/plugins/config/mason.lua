local M = {}

local registry = require("mason-registry")

local pending = {} ---@type table<string, true>
local scheduled = false
local refreshed = false

---@param message string
---@param level "TRACE" | "DEBUG" | "INFO" | "ERROR" | "WARN" | "ERROR" | "OFF"
local function notify(message, level)
    vim.notify(message, vim.log.levels[level], {
        title = "mason.nvim",
    })
end

---@type table<string, string>
local lspconfig_to_package = {}
---@return table<string, string>
function M.get_lspconfig_to_package()
    if #lspconfig_to_package > 0 then return lspconfig_to_package end

    for _, pkg_spec in ipairs(registry.get_all_package_specs()) do
        if vim.tbl_get(pkg_spec, "neovim", "lspconfig") ~= nil then
            local key = pkg_spec.neovim.lspconfig
            local value = pkg_spec.name or key
            lspconfig_to_package[key] = value
        end
    end
    return lspconfig_to_package
end

---@param servers string[]
local function install_servers(servers)
    local map = M.get_lspconfig_to_package()

    for _, server in ipairs(servers) do
        local lspconfig_name = server:gsub("@.*$", "")
        local pkg_name = map[lspconfig_name] or lspconfig_name

        local pkg = registry.get_package(pkg_name)

        if pkg:is_installed() or pkg:is_installing() then
            goto continue
        end

        notify(("Installing: %s (for %s)"):format(pkg_name, lspconfig_name), "INFO")

        pkg:install({}, function(ok, result)
            if ok then
                notify(("Installed: %s (for %s)"):format(pkg_name, lspconfig_name), "INFO")
                vim.schedule(function()
                    if not vim.lsp.is_enabled(lspconfig_name) then
                        vim.lsp.enable { lspconfig_name }
                    end
                end)
            else
                notify(("Install failed: %s (%s)")
                    :format(pkg_name, tostring(result)), "ERROR")
            end
        end)

        ::continue::
    end
end

---@param servers string[]
function M.request_install(servers)
    for _, s in ipairs(servers) do
        pending[s] = true
    end

    if scheduled then return end
    scheduled = true

    vim.schedule(function()
        scheduled = false
        local requested = vim.tbl_keys(pending)
        if #requested == 0 then return end
        pending = {}

        if not refreshed then
            registry.refresh(vim.schedule_wrap(function(success)
                if not success then
                    notify("Refresh failed.", "ERROR")
                    return
                end
                refreshed = true
                install_servers(requested)
            end))
            return
        end
        install_servers(requested)
    end)
end

return M
