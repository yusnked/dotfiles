-- sort.nvim への委譲を維持しつつ、:Sort のレンジ挙動だけ矯正する。
-- さらに :'<,'>Sort c / C で「文字単位ソート」を提供する（c/C は独自実装）。

local function notify_char_sort_requires_visual(mode)
    vim.notify(
        ("Sort %s はビジュアル選択範囲 (:'<,'>) でのみ使用できます."):format(mode),
        vim.log.levels.ERROR
    )
end

local function validate_char_sort_selection(cmd, mode)
    -- 厳格モード:
    -- - レンジ未指定 (:Sort c) は拒否
    -- - 指定レンジが '<,'> の行範囲と一致しない場合も拒否
    --   ※コマンドが「実際に '<,'> と打たれたか」は nvim 側からは取得できないため、
    --     現実的に取り得る最も厳しい条件として「行範囲一致」で判定する。

    if cmd.range == 0 then
        notify_char_sort_requires_visual(mode)
        return nil
    end

    local p1 = vim.fn.getpos("'<")
    local p2 = vim.fn.getpos("'>")
    local srow, scol = p1[2], p1[3]
    local erow, ecol = p2[2], p2[3]

    if srow == 0 or erow == 0 then
        notify_char_sort_requires_visual(mode)
        return nil
    end

    if cmd.line1 ~= srow or cmd.line2 ~= erow then
        notify_char_sort_requires_visual(mode)
        return nil
    end

    if srow ~= erow then
        vim.notify(('Sort %s は現在「1行内の選択」のみ対応です.'):format(mode), vim.log.levels.ERROR)
        return nil
    end

    if scol > ecol then
        scol, ecol = ecol, scol
    end

    return { row = srow, scol = scol, ecol = ecol }
end

local function char_sort(mode, sel)
    -- mode: "c" | "C"
    -- sel: { row, scol, ecol } は validate_char_sort_selection() 済みの前提

    local bufnr = 0
    local row0 = sel.row - 1
    local c0 = sel.scol - 1
    local c1 = sel.ecol -- end は exclusive。ecol は inclusive なのでこのままでOK

    local chunk = (vim.api.nvim_buf_get_text(bufnr, row0, c0, row0, c1, {})[1]) or ''
    local chars = vim.fn.split(chunk, '\\zs')

    local function cp(ch)
        return vim.fn.char2nr(ch)
    end

    -- C: ASCII英字だけ “大小を入れ替えた比較キー” を使う
    -- つまり a..z を A..Z の位置へ、A..Z を a..z の位置へ送る
    -- 結果：小文字が先、次に大文字（他の文字は通常のコードポイント比較）
    local function case_swapped_key(ch)
        local n = cp(ch)
        if n >= 65 and n <= 90 then      -- A..Z
            return n + 32                -- -> a..z の領域へ
        elseif n >= 97 and n <= 122 then -- a..z
            return n - 32                -- -> A..Z の領域へ
        end
        return n
    end

    local key = (mode == 'C') and case_swapped_key or cp

    table.sort(chars, function(a, b)
        local ka, kb = key(a), key(b)
        if ka == kb then
            return cp(a) < cp(b)
        end
        return ka < kb
    end)

    vim.api.nvim_buf_set_text(bufnr, row0, c0, row0, c1, { table.concat(chars, '') })
end

return {
    'sQVe/sort.nvim',
    keys = {
        { 'go', ':Sort<CR>', mode = 'x', silent = true },
        { 'gO', ':Sort!<CR>', mode = 'x', silent = true },
        { 'g<C-o>', ':Sort ', mode = 'x' },
    },
    cmd = 'Sort',
    opts = { delimiters = { ',', '|', ';', ':', 's', 't' } },
    init = function()
        vim.cmd([[
            cnoreabbrev <expr> sort  (getcmdtype()==#':' && getcmdline() =~# '^[^A-Za-z]*sort$')  ? 'Sort'  : 'sort'
            cnoreabbrev <expr> sort! (getcmdtype()==#':' && getcmdline() =~# '^[^A-Za-z]*sort!$') ? 'Sort!' : 'sort!'
        ]])
    end,
    config = function(_, opts)
        require('sort').setup(opts)

        --------------------------------------------------------------------
        -- sort.nvim の :Sort を上書き（レンジ矯正 + sort.nvim 委譲）
        --------------------------------------------------------------------
        pcall(vim.api.nvim_del_user_command, 'Sort')

        vim.api.nvim_create_user_command('Sort', function(cmd)
            local bang = cmd.bang and '!' or ''
            local args = cmd.args or ''
            local first = args:match('^%s*(%S+)') or ''

            -- 独自：文字ソート（厳格モード）
            if first == 'c' or first == 'C' then
                local sel = validate_char_sort_selection(cmd, first)
                if not sel then
                    return
                end
                char_sort(first, sel)
                return
            end

            -- それ以外：sort.nvim に丸投げ。ただし '<,'> 依存を矯正する
            local visual_mode = vim.fn.visualmode()
            if visual_mode ~= 'v' then
                local l1, l2
                if cmd.range == 0 then
                    l1, l2 = 1, vim.fn.line('$') -- レンジ無しは全体
                else
                    l1, l2 = cmd.line1, cmd.line2
                end

                vim.fn.setpos("'<", { 0, l1, 1, 0 })
                local endcol = #vim.fn.getline(l2) + 1
                vim.fn.setpos("'>", { 0, l2, endcol, 0 })
            end

            require('sort').sort(bang, args)
        end, {
            range = true,
            nargs = '*',
            bang = true,
            desc = 'Patched Sort: uses sort.nvim but respects command ranges; adds Sort c/C (char sort)',
        })
    end,
}
