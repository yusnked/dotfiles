local VISUAL_BLOCK = '\22'

--- Visual 選択を検索レジスタ (@/) に設定する.
---
--- Visual mode 中は現在の選択範囲を使用する.
---
--- それ以外の mode では最後の Visual 選択範囲を使用する.
--- ただし、検索は現在の位置ではなく最後の Visual 選択範囲から開始する.
---
--- Characterwise / Linewise は選択内容を literal 検索する.
--- Blockwise は各行を trim し、各断片を行内の任意位置にマッチさせる.
--- パターンを検索履歴へ追加後 Normal mode に戻り、選択範囲の
--- 見た目上の先頭（Linewise は行頭、Blockwise は左上）へ移動する.
---@param dir? 'forward' | 'backward' (default: 'forward')
return function(dir)
    dir = dir or 'forward'

    vim.validate('dir', dir, function(value)
        return value == 'forward' or value == 'backward'
    end)

    local current_mode = vim.fn.mode()

    local mode
    local start
    local finish

    if current_mode == 'v' or current_mode == 'V' or current_mode == VISUAL_BLOCK then
        -- 現在の Visual 選択を使う.
        mode = current_mode
        start = vim.fn.getpos('v')
        finish = vim.fn.getpos('.')
    else
        -- 最後の Visual 選択を使う.
        mode = vim.fn.visualmode()
        start = vim.fn.getpos("'<")
        finish = vim.fn.getpos("'>")
    end

    -- バッファ上の順序に正規化.
    if (start[2] > finish[2]) or (start[2] == finish[2] and start[3] > finish[3]) then
        start, finish = finish, start
    end

    local lines = vim.fn.getregion(start, finish, { type = mode })
    if #lines == 0 then
        return
    end

    local pattern

    if mode == VISUAL_BLOCK then
        local parts = {}

        for _, line in ipairs(lines) do
            local selected = vim.trim(line):gsub('\\', '\\\\')

            if selected == '' then
                parts[#parts + 1] = [[\.\*]]
            else
                parts[#parts + 1] = [[\.\*]] .. selected .. [[\.\*]]
            end
        end

        pattern = '\\V' .. table.concat(parts, '\\n')
    else
        local selected = table.concat(lines, '\n')
        if selected == '' then
            return
        end

        pattern = '\\V' .. selected:gsub('\\', '\\\\'):gsub('\n', '\\n')
    end

    vim.fn.setreg('/', pattern)

    if vim.fn.histget('search', -1) ~= pattern then
        vim.fn.histadd('search', pattern)
    end

    -- Visual mode 中なら Normal mode に戻る.
    if current_mode == 'v' or current_mode == 'V' or current_mode == VISUAL_BLOCK then
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
            'nx',
            false
        )
    end

    -- 選択範囲の見た目上の先頭へカーソル移動.
    -- Linewise / Blockwise は検索パターンが行全体にマッチするため行頭へ移動.
    local col = (mode == 'V' or mode == VISUAL_BLOCK) and 0 or start[3] - 1
    vim.api.nvim_win_set_cursor(0, { start[2], col })

    vim.v.hlsearch = 1
    vim.v.searchforward = (dir == 'forward') and 1 or 0
end
