local M = {}

function M.keys(plugin)
    return {
        {
            "-",
            function()
                local bufname = vim.api.nvim_buf_get_name(0)
                if require("self.lib.path.util").is_absolute_path(bufname) then
                    require(plugin.main).open { dir = vim.fs.dirname(bufname) }
                else
                    require(plugin.main).open()
                end
            end,
            desc = "Open parent dir",
        },
        {
            "_",
            function()
                require(plugin.main).open()
            end,
            desc = "Open CWD",
        },
        {
            "<leader>e",
            function()
                local cur_bufnr = vim.api.nvim_get_current_buf()
                local fyler = require(plugin.main)
                local kind = { kind = "split_left_most" }
                if vim.bo[cur_bufnr].filetype == "fyler" then
                    fyler.toggle(kind)
                    return
                end
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                    local bufnr = vim.api.nvim_win_get_buf(win)
                    if vim.bo[bufnr].filetype == "fyler" then
                        fyler.focus(kind)
                        return
                    end
                end
                fyler.toggle(kind)
            end,
            desc = "Toggle/focus left-most (fyler)",
        },
    }
end

function M.init(plugin)
    local load = require("plugins.util.autocmd_capture").load_and_capture_events
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = vim.api.nvim_create_augroup("plugins_fyler_lazyload_bufenter_dir", { clear = true }),
        callback = function(ctx)
            if package.loaded[plugin.main] then
                return true
            end
            if vim.bo[ctx.buf].buftype ~= "" then
                return
            end
            if not require("self.lib.path.util").is_absolute_path(ctx.match) then
                return
            end

            local stat = vim.uv.fs_stat(ctx.match)
            if stat and stat.type == "directory" then
                load { plugins = { plugin.name } }:fire(ctx.event)
                return true
            end
        end,
    })
end

function M.config(plugin)
    local function open_system(self)
        local path = self:cursor_node_entry().path
        local sysname = vim.uv.os_uname().sysname
        local cmd
        if sysname == "Darwin" then
            cmd = { "open", path }
        elseif sysname == "Linux" then
            cmd = { "xdg-open", path }
        else
            return
        end
        vim.system(cmd, { detach = true })
    end
    local opts = {
        views = {
            finder = {
                default_explorer = true,
                close_on_select = false,
                mappings = {
                    ["gx"] = open_system,
                    ["-"] = "GotoParent",
                    ["_"] = "GotoCwd",
                    ["<CR>"] = "Select",
                    ["<BS>"] = "CollapseAll",
                    ["<localleader>c"] = function(self) vim.cmd.cd(self.files.root_path) end,
                    ["<localleader>g"] = "GotoNode",
                    ["<localleader>l"] = function(self) vim.cmd.lcd(self.files.root_path) end,
                    ["<localleader>t"] = function(self) vim.cmd.tcd(self.files.root_path) end,
                },
            },
        },
    }
    require(plugin.main).setup(opts)

    do -- HACK: MONKEYPATCH fyler :w で y/n 選択時に User FylerConfirm 発火.
        local ok, confirm = pcall(require, plugin.main .. ".inputs.confirm")
        if not ok or type(confirm) ~= "table" or type(confirm.open) ~= "function" then
            return
        end

        if confirm.__patched_fyler_confirm then
            return
        end
        confirm.__patched_fyler_confirm = true

        local orig_open = confirm.open

        confirm.open = function(message, on_submit, ...)
            local src_buf = vim.api.nvim_get_current_buf()

            local function wrapped_submit(...)
                local argv = { ... } -- { true } or { false }

                local ret
                if type(on_submit) == "function" then
                    ret = on_submit(...)
                end

                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(src_buf) then
                        vim.api.nvim_exec_autocmds("User", {
                            pattern = "FylerConfirm",
                            modeline = false,
                            data = {
                                message = message,
                                args = argv,
                            },
                        })
                    end
                end)

                return ret
            end

            return orig_open(message, wrapped_submit, ...)
        end
    end
end

return M
