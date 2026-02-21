local M = {}

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

---@param servers string[]
local function install_servers(servers)
    local map = require("mason-lspconfig").get_mappings().lspconfig_to_package
    local registry = require("mason-registry")

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
            local registry = require("mason-registry")
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
