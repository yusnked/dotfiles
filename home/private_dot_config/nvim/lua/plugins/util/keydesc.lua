local M = {}

-- reg<mode><lhs> -> desc
---@type table<string, table<string, string>>
local reg = vim.defaulttable()

-- UTIL-CANDIDATE
---@generic T: table
---@param tbl T
---@return T
local function tbl_shallow_copy(tbl)
    local c = {}
    for k, v in pairs(tbl) do
        c[k] = v
    end
    return c
end

---@param modes string|string[]
---@return string[]
local function norm_modes(modes)
    if type(modes) == 'string' then return { modes } end
    return modes
end

---@param modes string|string[]|nil
---@return string[]
local function norm_lazy_modes(modes)
    if modes == nil then return { 'n' } end
    return norm_modes(modes)
end

-- lazy.nvim の keys テーブルから desc を記録する.
---@param keys LazyKeysSpec[]
---@return LazyKeysSpec[]
function M.lazy(keys)
    for i = 1, #keys do
        local key = keys[i]
        local lhs = key and key[1]
        local desc = key and key.desc
        if lhs and desc then
            local modes = norm_lazy_modes(key.mode)
            for k = 1, #modes do
                reg[modes[k]][lhs] = desc
            end
        end
    end
    return keys
end

-- desc が無い場合 登録済み desc を注入する vim.keymap.set のラッパー.
---@param modes string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
function M.set(modes, lhs, rhs, opts)
    opts = opts or {}

    if opts.desc == nil then
        for _, m in ipairs(norm_modes(modes)) do
            local d = reg[m] and reg[m][lhs]
            if d then
                local new_opts = tbl_shallow_copy(opts)
                new_opts.desc = d
                opts = new_opts
                break
            end
        end
    end

    return vim.keymap.set(modes, lhs, rhs, opts)
end

return M
