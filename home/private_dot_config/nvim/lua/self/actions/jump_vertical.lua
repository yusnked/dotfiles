--- 探索の対象になる最大行数.
local max_search_count = 500

local fn_line = vim.fn.line
local fn_virtcol = vim.fn.virtcol

---@param line integer
---@param virtcol integer
---@return boolean
local function has_virtcol(line, virtcol)
    return fn_virtcol { line, '$' } > virtcol
end

--- 同じ virtcol が存在する連続した行の端に移動する.
--- 次の行に同じ virtcol がなければ, 次にある行へ移動する.
---
--- Operator-pending は linewise であり,
--- 開始行が空行の場合は次の非空行の直前までが対象になる.
---
--- TAB, 全角, virtualedit 等では virtcol を厳密には維持しない.
---@param direction 'down'|'up'
---@param kind 'motion'|'operator'
return function(direction, kind)
    vim.validate('direction', direction, function(value)
        return value == 'up' or value == 'down'
    end)
    vim.validate('kind', kind, function(value)
        return value == 'motion' or value == 'operator'
    end)

    local dir = (direction == 'down') and 1 or -1
    local line = fn_line('.')
    local virtcol = fn_virtcol('.')
    ---@cast virtcol integer
    local last_line = fn_line('$')

    local next_line = line + dir
    if next_line < 1 or next_line > last_line then
        return
    end

    local is_blank_line = fn_virtcol { line, '$' } == 1
    local search_count = 0

    if has_virtcol(line, virtcol) and has_virtcol(next_line, virtcol) then
        -- virtcol が存在する連続した行の端まで進む.
        while true do
            next_line = line + dir

            if next_line < 1 or next_line > last_line or not has_virtcol(next_line, virtcol) then
                break
            end

            line = next_line

            search_count = search_count + 1
            if search_count > max_search_count then
                return
            end
        end
    else
        -- 次に virtcol が存在する行まで進む.
        while true do
            line = line + dir

            if line < 1 or line > last_line then
                return
            end

            search_count = search_count + 1
            if search_count > max_search_count then
                return
            end

            if has_virtcol(line, virtcol) then
                break
            end
        end
    end

    if kind == 'operator' then
        -- オペレーターで charwise は役に立たないので linewise にする.
        vim.cmd.normal { args = { 'V' }, bang = true }
        -- 開始行が空行の場合次の非空行の直前までを対象とする.
        if is_blank_line then
            line = line - dir
        end
    end

    -- virtcol を byte col に変換し 0-based に直す.
    -- virtcol2col は空行で 0 を返すので負にならないようにする.
    local byte_col = math.max(vim.fn.virtcol2col(0, line, virtcol) - 1, 0)
    vim.api.nvim_win_set_cursor(0, { line, byte_col })
end
