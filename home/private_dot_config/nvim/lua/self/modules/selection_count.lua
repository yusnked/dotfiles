--- Visual mode 中のみポーリングして Selection count を更新.
local M = {}

local augroup_name = 'self.modules.selection_count'

--- getregion() による巨大選択の走査を避けるため, この行数を超えた場合は lines のみ計算する.
local max_detailed_lines = 10000

---@class self.modules.selection_count.Opts
--- Selection count が変化したときに呼ばれる関数.
---
--- Visual 選択中なら count が入り, Visual 以外では nil が入る.
--- count には通常 lines, chars, bytes が入り, Visual-block では lines のみが入る.
---
--- chars と bytes には改行が含まれる.
---@field on_update fun(count: self.modules.selection_count.Count?)

---@type self.modules.selection_count.Opts?
local current_opts

local nvim_get_current_buf = vim.api.nvim_get_current_buf
local nvim_win_get_cursor = vim.api.nvim_win_get_cursor

local fn_col = vim.fn.col
local fn_getregion = vim.fn.getregion
local fn_line = vim.fn.line
local fn_mode = vim.fn.mode
local fn_strchars = vim.fn.strchars

local poll = require('self.lib.timer').poll

---@type self.lib.timer.Poller?
local poller

---@type string?
local last_key

local in_on_update = false

---@class self.modules.selection_count.Count
---@field lines integer
---@field chars integer?
---@field bytes integer?

--- 現在選択中の Visual 範囲の lines, chars, bytes を返す.
---@param mode string
---@param selection 'exclusive'|'inclusive'|'old'
---@param pos1 [integer, integer, integer, integer]
---@param pos2 [integer, integer, integer, integer]
---@return self.modules.selection_count.Count
local function calc_selection_count(mode, selection, pos1, pos2)
    local lines = math.abs(pos2[2] - pos1[2]) + 1

    -- Visual-block または巨大な選択範囲では, chars / bytes の計算を省略する.
    if mode == '\22' or lines > max_detailed_lines then
        return { lines = lines }
    end

    local region = fn_getregion(pos1, pos2, {
        type = mode,
        exclusive = selection == 'exclusive',
    })

    local chars, bytes = 0, 0
    for i = 1, #region do
        local line = region[i]
        -- PERF: strchars は vim.str_utfindex の約3倍速い. (v0.12.4)
        chars = chars + fn_strchars(line)
        bytes = bytes + #line
    end

    -- 改行を文字数カウントに含める.
    local newlines = mode == 'V' and lines or lines - 1
    chars = chars + newlines
    bytes = bytes + newlines

    ---@type self.modules.selection_count.Count
    return { lines = lines, chars = chars, bytes = bytes }
end

---@param mode string
---@return boolean
local function is_visual_mode(mode)
    return mode == 'v' or mode == 'V' or mode == '\22'
end

---@param mode string
---@param selection 'exclusive'|'inclusive'|'old'
---@param bufnr integer
---@param pos1 [integer, integer, integer, integer]
---@param pos2 [integer, integer, integer, integer]
---@return string
local function make_cache_key(mode, selection, bufnr, pos1, pos2)
    return table.concat({
        mode,
        selection,
        bufnr,
        pos1[2],
        pos1[3],
        pos2[2],
        pos2[3],
    }, ':')
end

---@return [integer, integer, integer, integer]
---@return [integer, integer, integer, integer]
local function get_region_positions()
    -- PERF: getpos より line + col の方が速く, それより nvim_win_get_cursor の方が速い. (v0.12.4)
    local v_line, v_col = fn_line('v'), fn_col('v')
    local cursor = nvim_win_get_cursor(0)

    -- nvim_win_get_cursor の col は 0-based byte index なので,
    -- getregion 用に 1-based へ変換する.
    return { 0, v_line, v_col, 0 }, { 0, cursor[1], cursor[2] + 1, 0 }
end

---@param opts self.modules.selection_count.Opts
---@param count self.modules.selection_count.Count?
local function call_on_update(opts, count)
    in_on_update = true
    local ok, err = pcall(opts.on_update, count)
    in_on_update = false

    if not ok then
        error(err, 0)
    end
end

---@param opts self.modules.selection_count.Opts
local function update_count(opts)
    local mode = fn_mode()
    local selection = vim.o.selection
    local bufnr = nvim_get_current_buf()
    local pos1, pos2 = get_region_positions()

    local key = make_cache_key(mode, selection, bufnr, pos1, pos2)
    if last_key == key then
        return
    end

    local count = calc_selection_count(mode, selection, pos1, pos2)

    call_on_update(opts, count)

    last_key = key
end

---@param opts self.modules.selection_count.Opts
function M.setup(opts)
    if in_on_update then
        return
    end

    vim.validate('opts', opts, 'table')
    vim.validate('opts.on_update', opts.on_update, 'function')

    M.cleanup()
    current_opts = opts

    poller = poll(function() update_count(opts) end, 200)

    local group = vim.api.nvim_create_augroup(augroup_name, {})

    vim.api.nvim_create_autocmd('ModeChanged', {
        group = group,
        pattern = '*:[vV\22]*', -- VisualEnter (Visual 内のモードチェンジでも発火)
        callback = function()
            -- Visual の種別変更は次の poll を待たず即時反映する.
            update_count(opts)
            poller.start()
        end,
        desc = 'Start selection count updates in Visual mode',
    })

    vim.api.nvim_create_autocmd('ModeChanged', {
        group = group,
        pattern = '[vV\22]*:[^vV\22]*', -- VisualLeave
        callback = function()
            poller.stop()
            last_key = nil
            call_on_update(opts, nil)
        end,
        desc = 'Clear selection count outside Visual mode',
    })

    -- フォーカスを失ったらポーリングを止め, 再びフォーカスされたら再開する.
    -- NOTE: getchar() / 入力待ち状態 (folke/which-key のキーヒント表示中など) では,
    --       端末のフォーカス通知が FocusLost / FocusGained に届かず,
    --       入力キーとして吸われる / 無視される環境がある.
    vim.api.nvim_create_autocmd('FocusLost', {
        group = group,
        callback = function()
            poller.stop()
        end,
        desc = 'Pause selection count polling when focus is lost',
    })

    vim.api.nvim_create_autocmd('FocusGained', {
        group = group,
        callback = function()
            if is_visual_mode(fn_mode()) then
                poller.start()
            end
        end,
        desc = 'Resume selection count polling in Visual mode',
    })
end

function M.cleanup()
    if in_on_update then
        return
    end

    pcall(vim.api.nvim_del_augroup_by_name, augroup_name)

    if poller then
        poller.close()
        poller = nil
    end

    last_key = nil

    if current_opts then
        call_on_update(current_opts, nil)
        current_opts = nil
    end
end

return M
