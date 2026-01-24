local lazyrepo = "https://github.com/folke/lazy.nvim.git"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local plugins_spec = "plugins/spec"

local fs_stat = vim.uv.fs_stat

local function has_plugins()
    local path = vim.fn.stdpath("config") .. "/lua/" .. plugins_spec
    return fs_stat(path) ~= nil or fs_stat(path .. ".lua") ~= nil
end

local function has_lazy()
    return fs_stat(lazypath) ~= nil
end

local function clone_lazy()
    local job = vim.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        lazyrepo, lazypath,
    }, { text = true })

    local res = job:wait()
    if res.code == 0 then
        return true
    end

    vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { (res.stderr ~= "" and res.stderr or res.stdout), "WarningMsg" },
    }, true, {})
    return false
end

local function ensure_lazy()
    return has_plugins() and (has_lazy() or clone_lazy())
end

if ensure_lazy() then
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup(plugins_spec:gsub("/", "."), {
        defaults = {
            lazy = true,
            cond = nil,
        },
        ui = {
            border = "single",
            custom_keys = {
                ["<localleader>r"] = {
                    function(plugin)
                        require("lazy").load { plugins = { plugin.name } }
                    end,
                    desc = "Load Plugin",
                },
            },
        },
        performance = {
            rtp = {
                disabled_plugins = {
                    "gzip",
                    "netrwPlugin",
                    "shada",
                    "spellfile",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
        profiling = { -- 遅い理由を調べたいときだけ有効にする.
            loader = false,
            require = false,
        },
    })
end
