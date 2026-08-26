local M = {}

local fn_isabsolutepath = vim.fn.isabsolutepath

local env = require('self.env')

--- path を effort_width 以下になるよう可能な範囲で省略する.
--- (Windows は対象外でそのまま返す.)
---
--- ディレクトリ名を左から順に先頭文字へ省略する.
--- ドットで始まる名前は "." とその次の1文字を残す.
---
--- 例) 最大限省略された場合:
--- /home/user/path/to/dir -> ~/p/t/dir
--- /etc/.hidden/file.conf -> /e/.h/file.conf
---@type self.lib.fs.Abbrev
function M.abbrev(...)
    return require('self.lib.fs.abbrev').abbrev(...)
end

--- project root を考慮して abs_path を effort_width 以下になるよう可能な範囲で省略する.
--- (Windows または絶対パスでない場合はそのまま返す.)
---
--- opts.markers から project root を検索し, 見つかった場合は
--- project root を "~project_name" として表現する.
--- まず project からの相対パスを左から順に省略し,
--- それでも effort_width を超える場合は project 名も省略する.
---
--- project 名は "_" と "-" と数字を残し, それ以外の連続部分を先頭1文字へ省略する.
---
--- project root が見つからない場合は M.abbrev() と同じ方法で省略する.
---
--- 例:
--- /home/user/project/src/lua/init.lua
---   -> ~project/s/l/init.lua
---   -> ~p/s/l/init.lua       (さらに省略が必要な場合)
---
--- /home/user/project_hoge-fuga/src/init.lua
---   -> ~project_hoge-fuga/s/init.lua
---   -> ~p_h-f/s/init.lua     (さらに省略が必要な場合)
---@type self.lib.fs.AbbrevWithProject
function M.abbrev_with_project(...)
    return require('self.lib.fs.abbrev').abbrev_with_project(...)
end

---@alias self.lib.fs.CwdScope 'global'|'tab'|'win'

-- TODO: bcd (v0.13)
---@return self.lib.fs.CwdScope cwd_scope
function M.get_cwd_scope()
    if vim.fn.haslocaldir() ~= 0 then
        return 'win'
    elseif vim.fn.haslocaldir(-1, 0) ~= 0 then
        return 'tab'
    end
    return 'global'
end

---@param path string
---@return boolean
function M.is_absolute_path(path)
    if env.is_windows then
        return fn_isabsolutepath(path) == 1
    end

    return path:sub(1, 1) == '/'
end

return M
