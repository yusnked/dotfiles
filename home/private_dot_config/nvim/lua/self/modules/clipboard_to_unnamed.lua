--- Neovim がフォーカスを得たときにクリップボードが変更されていたら,
--- unnamed register にクリップボードの内容をコピーする.
local M = {}

local getreg = vim.fn.getreg

local augroup_name = 'self.modules.clipboard_to_unnamed'

---@type string?
local snapshot

local function update_snapshot()
    snapshot = getreg('+')
end

local function import_if_changed()
    local clipboard = getreg('+')
    if clipboard == snapshot then
        return
    end

    local regtype = clipboard:find('\n', 1, true) and 'V' or 'v'
    vim.fn.setreg('"', clipboard, regtype)
    snapshot = clipboard
end

function M.setup()
    M.cleanup()

    if vim.fn.has('clipboard') == 0 then
        return
    end
    if vim.o.clipboard:find('unnamed', 1, true) then
        return
    end

    snapshot = getreg('+')

    local group = vim.api.nvim_create_augroup(augroup_name, {})
    vim.api.nvim_create_autocmd('FocusLost', {
        group = group,
        callback = update_snapshot,
        desc = 'Track clipboard for unnamed register import',
    })
    vim.api.nvim_create_autocmd('FocusGained', {
        group = group,
        callback = import_if_changed,
        desc = 'Import changed clipboard into unnamed register',
    })
end

function M.cleanup()
    pcall(vim.api.nvim_del_augroup_by_name, augroup_name)
    snapshot = nil
end

return M
