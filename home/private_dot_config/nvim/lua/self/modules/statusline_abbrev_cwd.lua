--- 現在の CWD を表示幅に合わせて省略し, 変更時に更新を通知する.
--- Global statusline で表示することが前提のため, 単一 CWD 値しか保持しない.
local M = {}

local augroup_name = 'self.modules.statusline_abbrev_cwd'

local abbrev_with_project = require('self.lib.path').abbrev_with_project
local get_cwd_scope = require('self.lib.path').get_cwd_scope

---@class self.modules.statusline_abbrev_cwd.Opts
---@field on_update fun(content: string)
---@field effort_width number|fun(): number CWD を省略する目安の表示幅.
---@field project_markers string[]

---@type self.modules.statusline_abbrev_cwd.Opts?
local current_opts

---@type string?
local last_path
---@type self.lib.path.CwdScope?
local last_cwd_scope
---@type number?
local last_effort_width
---@type string?
local last_content

local in_on_update = false

-- TODO: bcd (v0.13)
---@param cwd_scope self.lib.path.CwdScope
---@return string scope_label
local function get_scope_label(cwd_scope)
    if cwd_scope == 'win' then
        return ' [W]'
    elseif cwd_scope == 'tab' then
        return ' [T]'
    end

    return ''
end

---@param opts self.modules.statusline_abbrev_cwd.Opts
---@param content string
local function call_on_update(opts, content)
    in_on_update = true
    local ok, err = pcall(opts.on_update, content)
    in_on_update = false

    if not ok then
        error(err, 0)
    end
end

---@param opts self.modules.statusline_abbrev_cwd.Opts
local function update_abbrev_cwd(opts)
    local path = vim.fn.getcwd()
    local cwd_scope = get_cwd_scope()

    local effort_width = opts.effort_width
    if type(effort_width) == 'function' then
        effort_width = effort_width()
    end

    if path == last_path and cwd_scope == last_cwd_scope and effort_width == last_effort_width then
        return
    end

    local scope_label = get_scope_label(cwd_scope)
    -- scope_label は ASCII 前提.
    local abbrev_path = abbrev_with_project(path, effort_width - #scope_label, { markers = opts.project_markers })

    last_path = path
    last_effort_width = effort_width
    last_cwd_scope = cwd_scope

    local content = abbrev_path .. scope_label
    if content == last_content then
        return
    end

    call_on_update(opts, content)

    last_content = content
end

---@param opts self.modules.statusline_abbrev_cwd.Opts
function M.setup(opts)
    if in_on_update then
        return
    end

    vim.validate('opts', opts, 'table')
    vim.validate('opts.on_update', opts.on_update, 'function')
    vim.validate('opts.effort_width', opts.effort_width, { 'function', 'number' })
    vim.validate('opts.project_markers', opts.project_markers, 'table')

    M.cleanup()
    current_opts = opts

    -- TODO: WinEnter -> BufEnter (bcd)
    vim.api.nvim_create_autocmd({ 'WinEnter', 'DirChanged', 'VimResized' }, {
        group = vim.api.nvim_create_augroup(augroup_name, {}),
        callback = function()
            update_abbrev_cwd(opts)
        end,
        desc = 'Update abbreviated CWD',
    })
    update_abbrev_cwd(opts)
end

function M.cleanup()
    if in_on_update then
        return
    end

    pcall(vim.api.nvim_del_augroup_by_name, augroup_name)

    last_path = nil
    last_cwd_scope = nil
    last_effort_width = nil
    last_content = nil

    if current_opts then
        call_on_update(current_opts, '')
        current_opts = nil
    end
end

return M
