--- アクティブウィンドウでは relativenumber を有効にし,
--- Insert / Cmdline / フォーカス外 / 非アクティブ時は絶対行番号にする.
--- scroll_debounce_ms を指定した場合はスクロール中も絶対行番号にする.
local M = {}

local augroup_name = 'self.modules.smart_relativenumber'

local vim_o = vim.o
local mode = vim.fn.mode

local debounce = require('self.lib.timer').debounce

---@type self.lib.timer.Debounced?
local restore_after_scroll

---@param value boolean
local function set_relativenumber(value)
    if not vim_o.number or (value and mode() == 'i') then
        return
    end

    vim_o.relativenumber = value
end

---@class self.modules.smart_relativenumber.Opts
---@field scroll_debounce_ms? number スクロール後 N ms で相対行番号に戻す.

---@param opts? self.modules.smart_relativenumber.Opts
function M.setup(opts)
    opts = opts or {}

    M.cleanup()

    local group = vim.api.nvim_create_augroup(augroup_name, {})
    local is_scrolling = false

    if opts.scroll_debounce_ms ~= nil then
        restore_after_scroll = debounce(function()
            is_scrolling = false
            set_relativenumber(true)
        end, opts.scroll_debounce_ms)

        vim.api.nvim_create_autocmd('WinScrolled', {
            group = group,
            callback = function()
                -- ホットパスなのでスクロール継続中は最初に判定して早期 return する.
                if is_scrolling then
                    restore_after_scroll()
                    return
                end

                if not vim_o.number then
                    return
                end

                is_scrolling = true
                vim_o.relativenumber = false
                restore_after_scroll()
            end,
            desc = 'Disable relativenumber while scrolling',
        })
    end

    -- Window-local option は buffer/window ごとに記憶される. buffer を別 window で
    -- 初めて表示するときは, 既存の保存状態から window-local 値が初期化されるため,
    -- WinEnter で設定した relativenumber が上書きされることがある.
    -- 初期化後の BufEnter でも true を設定する.
    -- See :help local-options.
    vim.api.nvim_create_autocmd({ 'InsertLeave', 'CmdlineLeave', 'WinEnter', 'FocusGained', 'BufEnter' }, {
        group = group,
        callback = function()
            set_relativenumber(true)
        end,
        desc = 'Enable relativenumber in active window outside insert and cmdline modes',
    })
    vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter', 'WinLeave', 'FocusLost' }, {
        group = group,
        callback = function()
            set_relativenumber(false)
            if restore_after_scroll then
                restore_after_scroll:cancel()
                is_scrolling = false
            end
        end,
        desc = 'Disable relativenumber in insert or cmdline mode or inactive window',
    })
end

function M.cleanup()
    pcall(vim.api.nvim_del_augroup_by_name, augroup_name)

    if restore_after_scroll then
        restore_after_scroll:close()
        restore_after_scroll = nil
    end
end

return M
