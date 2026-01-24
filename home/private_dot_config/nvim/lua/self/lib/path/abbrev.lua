local strwidth = vim.fn.strwidth

local is_absolute_path = require("self.lib.path.util").is_absolute_path

local M = {}

local function abbrev_home(path)
    if is_absolute_path(path) then
        path = vim.fn.fnamemodify(path, ":~")
    end
    return path
end

function M.abbrev(path, effort_width)
    if type(path) ~= "string" then
        return ""
    end
    effort_width = type(effort_width) == "number" and effort_width or 0

    path = abbrev_home(path)
    if path == "~" or path == "/" then
        return path
    end

    local width = strwidth(path)
    local prev_path = path
    while width > effort_width do
        -- /dir/ -> /d/ に変換
        path = vim.fn.substitute(path, [[\v/([^.]|\..)[^/]+/]], "/\\1/", "")
        if path == prev_path then
            break
        end
        width = strwidth(path)
        prev_path = path
    end
    return path
end

local function escape_lua_pattern(s)
    s = tostring(s)
    -- Luaパターンの特殊文字: ( ) . % + - * ? [ ] ^ $
    return (s:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"))
end

local function first_char(s)
    return vim.fn.strcharpart(s, 0, 1)
end

local function abbrev_project_name(name)
    -- 先頭文字は必ず残す.
    local abbr = first_char(name)

    -- "_" or "-" 区切りごとにトークンを見る.
    for sep, token in name:gmatch("([_-])([^_-]+)") do
        -- token が数字で始まるなら、区別のため “全部” 残す (例: -2, -12)
        if token:match("^%d") then
            abbr = abbr .. sep .. token
        else
            -- それ以外は頭文字だけ (例: _root -> _r, -feature -> -f)
            abbr = abbr .. sep .. first_char(token)
        end
    end

    return abbr
end

-- opts: { markers = {".git", ...} }
function M.abbrev_with_projects(abs_path, effort_width, opts)
    opts = opts or {}

    if not is_absolute_path(abs_path) then
        return ""
    end

    -- markers のどれかがあればOK (同優先度) にしたいのでネストする.
    local project_root_dir = vim.fs.root(abs_path, { opts.markers })
    if project_root_dir then
        -- project_name/relative/path
        local project_name = project_root_dir:gsub("^.*/([^/]+)$", "%1")

        local project_root_pattern = "^" .. escape_lua_pattern(project_root_dir)
        local project_relative_path = abs_path:gsub(project_root_pattern, "")

        -- まずは /relative/path 部分を省略. width の-1は先頭の ~ の分.
        local abbrev_relative_path = M.abbrev(project_relative_path, effort_width - strwidth(project_name) - 1)

        local path = "~" .. project_name .. abbrev_relative_path
        if strwidth(path) <= effort_width then
            return path
        end

        -- まだ長ければ ~project_name/ 部分も省略.
        local abbrev_project_name_str = abbrev_project_name(project_name)
        return "~" .. abbrev_project_name_str .. abbrev_relative_path
    else
        return M.abbrev(abs_path, effort_width)
    end
end

return M
