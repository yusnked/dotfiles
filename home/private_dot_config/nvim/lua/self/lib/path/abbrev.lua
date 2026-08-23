local M = {}

local fn_strcharpart = vim.fn.strcharpart
local fn_strwidth = vim.fn.strwidth

local is_windows = require('self.env').is_windows

local is_absolute_path = require('self.lib.path').is_absolute_path

---@param path string
---@return string
local function abbrev_home(path)
    return is_absolute_path(path) and vim.fn.fnamemodify(path, ':~') or path
end

---@param str string
---@return string
local function first_char(str)
    return fn_strcharpart(str, 0, 1)
end

---@param component string
---@return string
local function abbrev_component(component)
    if component:sub(1, 1) == '.' then
        return '.' .. first_char(component:sub(2))
    end
    return first_char(component)
end

---@alias self.lib.path.Abbrev fun(path: string, effort_width: integer): string

---@type self.lib.path.Abbrev
function M.abbrev(path, effort_width)
    if is_windows then
        return path
    end

    path = abbrev_home(path)
    if path == '~' or path == '/' or path:find('/', 1, true) == nil then
        return path
    end

    local width = fn_strwidth(path)
    if width <= effort_width then
        return path
    end

    local parts = vim.split(path, '/', { plain = true })

    for i = 1, #parts - 1 do
        local part = parts[i]

        if part ~= '' and part ~= '~' then
            local abbreviated = abbrev_component(part)

            width = width - fn_strwidth(part) + fn_strwidth(abbreviated)
            parts[i] = abbreviated

            if width <= effort_width then
                break
            end
        end
    end

    return table.concat(parts, '/')
end

---@param abs_path string
---@param markers string[]
---@return string? project_name
---@return string? relpath
local function get_project_path(abs_path, markers)
    local root = vim.fs.root(abs_path, markers)
    if not root then
        return
    end

    return vim.fs.basename(root), abs_path:sub(#root + 1)
end

--- '_', '-', 数字で区切られた文字を先頭の 1 文字だけ残して省略する.
---@param name string
---@return string
local function abbrev_project_name(name)
    return (name:gsub('[^_%d-]+', first_char))
end

---@class self.lib.path.AbbrevWithProject.Opts
---@field markers string[]

---@alias self.lib.path.AbbrevWithProject fun(abs_path: string, effort_width: integer, opts: self.lib.path.AbbrevWithProject.Opts): string

---@type self.lib.path.AbbrevWithProject
function M.abbrev_with_project(abs_path, effort_width, opts)
    if is_windows or not is_absolute_path(abs_path) then
        return abs_path
    end

    local project_name, relpath = get_project_path(abs_path, opts.markers)
    if not project_name or not relpath then
        return M.abbrev(abs_path, effort_width)
    end

    local relpath_width = effort_width - fn_strwidth(project_name) - 1
    -- project からの相対パス (ただし / から始まる) を絶対パスに見立てて M.abbrev に渡す.
    local abbreviated_relpath = M.abbrev(relpath, relpath_width)

    local path = '~' .. project_name .. abbreviated_relpath
    if fn_strwidth(path) <= effort_width then
        return path
    end

    return '~' .. abbrev_project_name(project_name) .. abbreviated_relpath
end

return M
