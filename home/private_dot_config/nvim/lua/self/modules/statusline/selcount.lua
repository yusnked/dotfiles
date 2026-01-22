-- selcount.lua
-- Visual/Select中の選択量を "L C B" で表示する (マルチバイト対応)
-- 例: "3L 31C 62B"
-- 特徴:
-- - setup() 1発で autocmd + タイマー + キャッシュ (vim.w) まで全部設定
-- - Visual/Select 中のみポーリングしてカウントを更新
-- - フォーカスが外れたらポーリングだけ止める (表示は残す)
-- 既知の問題:
-- - getchar()/入力待ち状態 (例: folke/which-keyのキーヒント表示中)では
--   端末のフォーカス通知が autocmd の FocusLost/FocusGained に届かず
--   入力キーとして吸われる/無視される環境がある
--   その場合フォーカス離脱時にポーリング停止が実行されず継続することがある

local M = {}

local api = vim.api
local fn = vim.fn
local uv = vim.uv

local defaults = {
    wvar = "statusline_selcount", -- 保存先: vim.w.{wvar}
    augroup = "statusline_selection_count",
    poll_ms = 200,                -- Visual/Select 中のポーリング間隔 (ms)
    on_update = nil,              -- 再計算が発生したときのみ呼ばれる関数
}

-- Visual/Select の判定
local function is_selecting(mode)
    -- \22: CTRL-V (block), \19: CTRL-S (select block)
    return mode:find("[vVsS\22\19]") ~= nil
end

local function is_linewise(mode)
    local m = mode:sub(1, 1)
    return m == "V" or m == "S"
end

local function is_blockwise(mode)
    return mode:find("\22") or mode:find("\19")
end

local function clamp_col(col, line_len_bytes)
    if col < 1 then return 1 end
    if col > line_len_bytes + 1 then return line_len_bytes + 1 end
    return col
end

-- inclusiveな end_col (=終端文字を含む) を exclusive境界へ (マルチバイト対応)
-- end_col は 1-based の「終端文字の先頭バイト」を想定
local function to_exclusive_endcol(line, end_col)
    local strlen = fn.strlen
    local charidx = fn.charidx
    local byteidx = fn.byteidx

    local len = strlen(line) -- bytes
    if end_col >= len + 1 then
        return len + 1
    end

    local ch = charidx(line, end_col - 1) -- byte (0-based) -> char index
    if ch < 0 then
        return end_col
    end

    local nb = byteidx(line, ch + 1) -- next char -> byte index (0-based)
    if nb < 0 then
        return len + 1
    end

    return nb + 1 -- 1-based
end

local function make_key(mode, selection, winid, bufnr, l1, c1, l2, c2)
    return table.concat({ mode, selection, winid, bufnr, l1, c1, l2, c2 }, ":")
end

-- Visual/Select の現在の範囲取得
-- NOTE:
-- - '< と '> は Visual を抜けるまで更新されないことがあるため、
--   Visual 中の「生きた範囲」は 'v (開始) と . (カーソル) を使う。
local function get_region_live()
    local l1, c1 = fn.line("v"), fn.col("v")
    local l2, c2 = fn.line("."), fn.col(".")
    return l1, c1, l2, c2
end

local function normalize_region(l1, c1, l2, c2)
    if l1 > l2 then
        l1, l2 = l2, l1
        c1, c2 = c2, c1
    end
    return l1, c1, l2, c2
end

local function sum_linewise(lines_tbl)
    local bytes, chars = 0, 0
    local strlen = fn.strlen
    local strchars = fn.strchars
    for i = 1, #lines_tbl do
        local s = lines_tbl[i]
        bytes = bytes + strlen(s)
        chars = chars + strchars(s)
    end
    return chars, bytes
end

local function sum_blockwise(lines_tbl, raw_sc, raw_ec, inclusive)
    local bytes, chars = 0, 0
    local strlen = fn.strlen
    local strchars = fn.strchars

    for i = 1, #lines_tbl do
        local s = lines_tbl[i]
        local len = strlen(s)
        local sc = clamp_col(raw_sc, len)
        local ec = clamp_col(raw_ec, len)

        if inclusive then
            ec = to_exclusive_endcol(s, ec)
        end
        if ec < sc then sc, ec = ec, sc end

        local piece = s:sub(sc, ec - 1)
        bytes = bytes + strlen(piece)
        chars = chars + strchars(piece)
    end

    return chars, bytes
end

local function sum_charwise(lines_tbl, l1, c1, l2, c2, inclusive)
    local bytes, chars = 0, 0
    local strlen = fn.strlen
    local strchars = fn.strchars

    -- 同一行の逆方向選択対応
    if l1 == l2 and c1 > c2 then
        c1, c2 = c2, c1
    end

    for i = 1, #lines_tbl do
        local s = lines_tbl[i]
        local len = strlen(s)

        local sc = (i == 1) and c1 or 1
        local ec = (i == #lines_tbl) and c2 or (len + 1)

        sc = clamp_col(sc, len)
        ec = clamp_col(ec, len)
        if ec < sc then sc, ec = ec, sc end

        -- inclusiveなら終端文字を含めるため、終端を「次の境界」へ
        if inclusive and i == #lines_tbl then
            ec = to_exclusive_endcol(s, ec)
        end

        local piece = s:sub(sc, ec - 1)
        bytes = bytes + strlen(piece)
        chars = chars + strchars(piece)
    end

    return chars, bytes
end

local function format_lcb(lines, chars, bytes)
    if chars == bytes then
        return string.format("%dL %dC", lines, chars)
    else
        return string.format("%dL %dC %dB", lines, chars, bytes)
    end
end

local function calc_lcb(mode, selection, l1, c1, l2, c2)
    if not is_selecting(mode) then
        return ""
    end

    local inclusive = (selection ~= "exclusive")

    -- 計算用に正規化 (上 -> 下)
    l1, c1, l2, c2 = normalize_region(l1, c1, l2, c2)

    local lines = (l2 - l1) + 1
    local buf_lines = api.nvim_buf_get_lines(0, l1 - 1, l2, false)

    local chars, bytes
    if is_linewise(mode) then
        chars, bytes = sum_linewise(buf_lines)
        return format_lcb(lines, chars, bytes)
    end

    if is_blockwise(mode) then
        local raw_sc = math.min(c1, c2)
        local raw_ec = math.max(c1, c2)
        chars, bytes = sum_blockwise(buf_lines, raw_sc, raw_ec, inclusive)
        return format_lcb(lines, chars, bytes)
    end

    -- charwise/selectwise
    chars, bytes = sum_charwise(buf_lines, l1, c1, l2, c2, inclusive)
    return format_lcb(lines, chars, bytes)
end

local function clear_all_wins(wvar, keyvar)
    local list_wins = api.nvim_list_wins
    local win_set_var = api.nvim_win_set_var
    local win_del_var = api.nvim_win_del_var

    local wins = list_wins()
    for i = 1, #wins do
        local win = wins[i]
        pcall(win_set_var, win, wvar, "")
        pcall(win_del_var, win, keyvar)
    end
end

local function sanitize_poll_ms(ms)
    ms = tonumber(ms) or defaults.poll_ms
    -- 極端に小さいと自爆するので下限を設ける
    if ms < 20 then
        ms = 20
    end
    return math.floor(ms)
end

function M.setup(user_opts)
    local opts = vim.tbl_deep_extend("force", {}, defaults, user_opts or {})
    M._opts = opts

    local state = M._state or {}
    M._state = state

    -- 既存タイマーは再利用 (多重ポーリング絶対禁止)
    state.timer = (state.timer and not state.timer:is_closing()) and state.timer or uv.new_timer()
    state.running = state.running or false
    state.poll_ms = sanitize_poll_ms(opts.poll_ms)

    local keyvar = "_" .. opts.wvar .. "_key"

    local function stop_poll()
        if state.running and state.timer and not state.timer:is_closing() then
            state.timer:stop()
        end
        state.running = false
    end

    local function clear_cache()
        stop_poll()
        clear_all_wins(opts.wvar, keyvar)
    end

    local function poll_tick()
        -- 基本は ModeChanged で開始/停止するが、取りこぼし保険でモードも確認
        local mode = fn.mode(1)
        if not is_selecting(mode) then
            clear_cache()
            return
        end

        local selection = vim.o.selection
        local winid = api.nvim_get_current_win()
        local bufnr = api.nvim_get_current_buf()
        local l1, c1, l2, c2 = get_region_live()

        local key = make_key(mode, selection, winid, bufnr, l1, c1, l2, c2)
        if vim.w[keyvar] == key then
            return
        end

        local val = calc_lcb(mode, selection, l1, c1, l2, c2)
        vim.w[opts.wvar] = val
        vim.w[keyvar] = key

        if opts.on_update then
            opts.on_update()
        end
    end

    local function start_poll()
        local poll_ms = sanitize_poll_ms(opts.poll_ms)

        -- 既に動いていて間隔も同じなら何もしない
        if state.running and state.poll_ms == poll_ms then
            return
        end

        -- 動いているが間隔が変わったなら安全に再起動
        stop_poll()

        state.poll_ms = poll_ms
        state.running = true

        -- 入った瞬間にズレた値を出さないため、次のループで評価する
        vim.schedule(poll_tick)

        state.timer:start(poll_ms, poll_ms, function()
            vim.schedule(poll_tick)
        end)
    end

    local function on_mode_changed()
        ---@type any
        local ev = vim.v.event
        local new_mode = (ev and ev.new_mode) or fn.mode(1)
        if is_selecting(new_mode) then
            start_poll()
        else
            -- Visual/Select を抜けたら全ウィンドウの表示を消す
            clear_cache()
        end
    end

    local function on_focus_lost()
        -- フォーカスが外れたらポーリングだけ止める (表示は残してOK)
        stop_poll()
    end

    local function on_focus_gained()
        -- 戻ってきた時点でVisual/Selectなら再開
        if is_selecting(fn.mode(1)) then
            start_poll()
        end
    end

    -- setup を呼び直した場合でも確実に単一動作にする
    stop_poll()
    clear_all_wins(opts.wvar, keyvar)

    -- autocmds
    local group = api.nvim_create_augroup(opts.augroup, { clear = true })
    api.nvim_create_autocmd("ModeChanged", {
        group = group,
        pattern = "*",
        callback = on_mode_changed,
    })
    api.nvim_create_autocmd("FocusLost", {
        group = group,
        callback = on_focus_lost,
    })
    api.nvim_create_autocmd("FocusGained", {
        group = group,
        callback = on_focus_gained,
    })

    -- もし setup 呼び出し時点で既に Visual/Select なら開始
    if is_selecting(fn.mode(1)) then
        start_poll()
    end

    return M
end

function M.component()
    local opts = M._opts or defaults
    return vim.w[opts.wvar] or ""
end

return M
