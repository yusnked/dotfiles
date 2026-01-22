local M = {}

local defaults_opts = {
    wvar = "statusline_abbrev_cwd",
    augroup = "statusline_abbrev_cwd",
    scope_label = {
        win_local = " [L]",
        tab_local = " [T]",
    },
    project_markers = {
        ".git",
    },
    effort_width_fn = function()
        return 0
    end,
}

local function get_scope_label()
    local scope_label = ""
    if vim.fn.haslocaldir() ~= 0 then
        scope_label = M._opts.scope_label.win_local
    elseif vim.fn.haslocaldir(-1, 0) ~= 0 then
        scope_label = M._opts.scope_label.tab_local
    end
    return scope_label
end

local abbrev_cwd_prev = {}
local function set_abbrev_cwd()
    local scope_label = get_scope_label()

    local win_id = vim.api.nvim_get_current_win()
    local path = vim.fn.getcwd()
    local width = M._opts.effort_width_fn() - #scope_label

    if abbrev_cwd_prev[win_id] and
        path == abbrev_cwd_prev[win_id].path and
        width == abbrev_cwd_prev[win_id].width then
        return
    end

    local abbrev_with_projects = require("self.lib.path").abbrev_with_projects
    local abbrev_path = abbrev_with_projects(path, width, { markers = M._opts.project_markers })
    vim.w[M._opts.wvar] = abbrev_path .. scope_label

    abbrev_cwd_prev[win_id] = {
        path = path,
        width = width,
    }
end

function M.setup(user_opts)
    local opts = vim.tbl_deep_extend("force", defaults_opts, user_opts or {})
    M._opts = opts
    local group = vim.api.nvim_create_augroup(opts.augroup, { clear = true })
    vim.api.nvim_create_autocmd({ "WinEnter", "DirChanged", "VimResized" }, {
        group = group,
        callback = set_abbrev_cwd,
    })
    set_abbrev_cwd()

    return M
end

return M
