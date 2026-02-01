-- lua/self/util/keydesc.lua
-- lazy.nvim の keys で宣言した desc を記録し、
-- 後で実際に vim.keymap.set するとき opts.desc が無ければ注入する薄い仕組み。

local M = {}

-- reg[mode][lhs] = desc
local reg = {}

local function ensure(tbl, k)
    local v = tbl[k]
    if v == nil then
        v = {}
        tbl[k] = v
    end
    return v
end

local function norm_modes(modes)
    if modes == nil then
        return { "n" }
    end
    if type(modes) == "string" then
        return { modes }
    end
    return modes
end

local function shallow_copy(t)
    local c = {}
    for k, v in pairs(t) do
        c[k] = v
    end
    return c
end

-- lazy.nvim の keys テーブルを一度通して desc を登録しそのまま返す.
function M.lazy(keys)
    for i = 1, #keys do
        local k = keys[i]
        local lhs = k and k[1]
        local desc = k and k.desc
        if lhs and desc then
            local modes = norm_modes(k.mode)
            for _, m in ipairs(modes) do
                ensure(reg, m)[lhs] = desc
            end
        end
    end
    return keys
end

-- vim.keymap.set の薄いラッパ
-- opts.desc が無い場合 登録済み desc を注入する.
function M.set(modes, lhs, rhs, opts)
    opts = opts or {}

    if opts.desc == nil then
        for _, m in ipairs(norm_modes(modes)) do
            local d = reg[m] and reg[m][lhs]
            if d then
                local new_opts = shallow_copy(opts)
                new_opts.desc = d
                opts = new_opts
                break
            end
        end
    end

    return vim.keymap.set(modes, lhs, rhs, opts)
end

return M
