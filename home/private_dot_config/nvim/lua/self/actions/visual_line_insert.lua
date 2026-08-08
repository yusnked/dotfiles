-- Linewise Visual でも Blockwise Visual の I/A 相当を行う.
--
-- 一時的に Blockwise Visual へ変換して一括挿入を行い、
-- Insert 終了後に元の Linewise Visual の範囲・選択方向・
-- カーソル位置を復元する.
--
-- 挿入による位置変化は extmark で追跡するため、I/gI で
-- カーソルより前に文字列が追加されても元の位置を保持できる.

local visual_line = {
    A = '<C-v>0o$A',
    I = '<C-v>^o^I',
    gI = '<C-v>0o$I',
}

local ns = vim.api.nvim_create_namespace('visual_line_insert')

---@param keys string
local function feedkeys(keys)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(keys, true, false, true),
        'n',
        false
    )
end

--- Linewise Visual で Blockwise Visual 相当の挿入を行う.
---
--- Linewise Visual 以外では、指定されたキーをそのまま実行する.
--- Linewise Visual では一時的に Blockwise Visual を使用して
--- 複数行へ一括挿入し、Insert 終了後に元の Linewise Visual の
--- 範囲・選択方向・カーソル位置を復元する.
---
---@param key 'I' | 'A' | 'gI'
return function(key)
    vim.validate('key', key, function(value)
        return visual_line[value] ~= nil
    end, 'I, A, or gI')

    if vim.fn.mode() ~= 'V' then
        feedkeys(key)
        return
    end

    local buf = vim.api.nvim_get_current_buf()

    -- 現在の Linewise Visual の開始位置と実カーソル位置.
    local v = vim.fn.getpos('v')
    local cursor = vim.api.nvim_win_get_cursor(0)

    -- 挿入による位置の変化を追跡する.
    local anchor_mark = vim.api.nvim_buf_set_extmark(
        buf,
        ns,
        v[2] - 1,
        v[3] - 1,
        { right_gravity = true }
    )

    local cursor_mark = vim.api.nvim_buf_set_extmark(
        buf,
        ns,
        cursor[1] - 1,
        cursor[2],
        { right_gravity = true }
    )

    -- 元の選択方向.
    local cursor_at_top = cursor[1] < v[2]

    vim.api.nvim_create_autocmd('InsertLeave', {
        buffer = buf,
        once = true,
        callback = function()
            vim.schedule(function()
                if not vim.api.nvim_buf_is_valid(buf) then
                    return
                end

                local anchor = vim.api.nvim_buf_get_extmark_by_id(
                    buf,
                    ns,
                    anchor_mark,
                    {}
                )

                local cur = vim.api.nvim_buf_get_extmark_by_id(
                    buf,
                    ns,
                    cursor_mark,
                    {}
                )

                -- 以降の処理で失敗しても extmark を残さない.
                vim.api.nvim_buf_del_extmark(buf, ns, anchor_mark)
                vim.api.nvim_buf_del_extmark(buf, ns, cursor_mark)

                if #anchor == 0 or #cur == 0 then
                    return
                end

                -- extmark は 0-based、setpos() は row/col ともに 1-based.
                local anchor_pos = {
                    0,
                    anchor[1] + 1,
                    anchor[2] + 1,
                    0,
                }

                local cursor_pos = {
                    0,
                    cur[1] + 1,
                    cur[2] + 1,
                    0,
                }

                -- '< / '> はバッファ上の前後順で設定する.
                local first, last
                if anchor_pos[2] <= cursor_pos[2] then
                    first, last = anchor_pos, cursor_pos
                else
                    first, last = cursor_pos, anchor_pos
                end

                vim.fn.setpos("'<", first)
                vim.fn.setpos("'>", last)

                -- 一時的な Blockwise Visual 履歴を消して、
                -- 元の範囲を Linewise Visual として作り直す.
                vim.cmd.normal { 'gvV', bang = true }

                -- 元が上向きの選択なら active end を上側へ戻す.
                if cursor_at_top then
                    vim.cmd.normal { 'o', bang = true }
                end

                -- 元カーソルを挿入後の対応位置へ戻す.
                vim.api.nvim_win_set_cursor(0, {
                    cursor_pos[2],
                    cursor_pos[3] - 1,
                })

                -- この状態を最後の Visual 選択として保存して抜ける.
                vim.cmd.normal { '\27', bang = true }
            end)
        end,
    })

    feedkeys(visual_line[key])
end
