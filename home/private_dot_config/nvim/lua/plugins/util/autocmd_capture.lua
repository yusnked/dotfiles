local M = {}

-- =========================
-- CaptureResult 'class'
-- =========================
local CaptureResult = {}
CaptureResult.__index = CaptureResult

-- captured_autocmds (配列ライク) を
-- { ['EventName'] = { group_identifier, ... }, ... } に変換する
-- group_identifier は (string|integer) を許容.
local function index_groups_by_event(captured_autocmds)
    local out = {} ---@type table<string, (string|integer)[]>
    local seen = {} ---@type table<string, table<string|integer, boolean>>

    local function push(event, group)
        if out[event] == nil then
            out[event] = {}
            seen[event] = {}
        end
        if not seen[event][group] then
            out[event][#out[event] + 1] = group
            seen[event][group] = true
        end
    end

    if type(captured_autocmds) ~= 'table' then
        return out
    end

    for _, item in ipairs(captured_autocmds) do
        if type(item) == 'table' then
            local group = (type(item.opts) == 'table') and item.opts.group or nil
            if type(group) == 'number' or type(group) == 'string' then
                local ev = item.event
                if type(ev) == 'string' then
                    push(ev, group)
                elseif type(ev) == 'table' then
                    for _, e in ipairs(ev) do
                        if type(e) == 'string' then
                            push(e, group)
                        end
                    end
                end
            end
        end
    end

    return out
end

--- 指定イベントを「キャプチャした group だけ」で発火する.
--- @param event string|string[]
--- @return integer fired_count 叩いた (event, group) の回数
function CaptureResult:fire(event, exec_opts)
    local api = vim.api
    exec_opts = exec_opts or {}

    local function fire_one(ev)
        local groups = self.groups_by_event[ev]
        if type(groups) ~= 'table' then
            return 0
        end
        local fired = 0
        for _, grp in ipairs(groups) do
            local opts = vim.tbl_extend('force', exec_opts, { group = grp })
            api.nvim_exec_autocmds(ev, opts)
            fired = fired + 1
        end
        return fired
    end

    if type(event) == 'string' then
        return fire_one(event)
    elseif type(event) == 'table' then
        local total = 0
        for _, ev in ipairs(event) do
            if type(ev) == 'string' then
                total = total + fire_one(ev)
            end
        end
        return total
    end

    return 0
end

-- =========================
-- Public API
-- =========================

--- lazy.load の間だけ nvim_create_autocmd をフックしてキャプチャする
--- 戻り値は :fire() を持つオブジェクト
--- {
---   groups_by_event = { ['Event'] = { group_identifier... }, ... },
---   raw = { { event=..., opts=... }, ... },
---   lazy_result = ret,
--- }
function M.load_and_capture_events(lazy_opts)
    lazy_opts = lazy_opts or {}
    lazy_opts.wait = true

    local raw = {}
    local api = vim.api

    local prev_create_autocmd = api.nvim_create_autocmd

    ---@diagnostic disable-next-line: duplicate-set-field
    api.nvim_create_autocmd = function(event, opts)
        raw[#raw + 1] = { event = event, opts = opts }
        return prev_create_autocmd(event, opts)
    end

    local ok, ret = pcall(function()
        return require('lazy').load(lazy_opts)
    end)

    ---@diagnostic disable-next-line: duplicate-set-field
    api.nvim_create_autocmd = prev_create_autocmd

    if not ok then
        error(ret, 2)
    end

    local result = {
        raw = raw,
        groups_by_event = index_groups_by_event(raw),
    }

    return setmetatable(result, CaptureResult)
end

return M
