local M = {}

M._vltasks = M._vltasks or {}
M._verylazy_hooked = M._verylazy_hooked or false

local function ensure_verylazy_runner()
    if M._verylazy_hooked then
        return
    end
    M._verylazy_hooked = true

    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
            for _, task in ipairs(M._vltasks) do
                if task and not task._done then
                    M._run_task(task)
                end
            end
        end,
    })
end

function M._run_task(task)
    if task._done then
        return
    end

    local function load()
        if task._done then
            return
        end
        task._done = true
        require("lazy").load { plugins = { task.plugin } }
    end

    local ok, ret = pcall(task.cb, load)
    if not ok then
        vim.schedule(function()
            vim.notify(("verylazy_load cb failed for %s: %s"):format(task.plugin, ret), vim.log.levels.ERROR)
        end)
        return
    end

    -- nil/true: 即ロード
    if ret == nil or ret == true then
        load()
        return
    end

    -- number: 秒後にロード
    if type(ret) == "number" then
        if ret > 0 then
            vim.defer_fn(load, math.floor(ret))
        else
            load()
        end
        return
    end

    -- string or {string,...}: once autocmd を張って、発火時に再評価
    local events
    if type(ret) == "string" then
        events = { ret }
    elseif type(ret) == "table" then
        events = ret
    else
        return
    end

    vim.api.nvim_create_autocmd(events, {
        once = true,
        callback = load,
    })
end

--- lazy.nvimのinit関数内で呼ぶ必要がある
--- cbの戻り値:
---   nil/true      -> すぐload()
---   number(>0)    -> ms後にload()
---   "Event" / {..}-> そのイベントでonce発火、発火時にload()
function M.verylazy_schedule_load(plugin, cb)
    ensure_verylazy_runner()
    table.insert(M._vltasks, { plugin = plugin, cb = cb, _done = false })
end

return M
