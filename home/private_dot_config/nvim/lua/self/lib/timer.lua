local M = {}

--- @class self.lib.timer.Debounced
--- @field cancel fun()
--- @field close fun()
--- @overload fun(...)

--- @param fn function
--- @param wait integer ms
--- @return self.lib.timer.Debounced
function M.debounce(fn, wait)
    vim.validate('fn', fn, 'function')
    vim.validate('wait', wait, 'number')

    local timer = assert(vim.uv.new_timer())
    local args --- @type table?
    local nargs = 0
    local generation = 0
    local closed = false

    local function cancel()
        if closed then
            return
        end

        generation = generation + 1
        timer:stop()
        args = nil
        nargs = 0
    end

    local function close()
        if closed then
            return
        end

        cancel()
        closed = true
        timer:close()
    end

    local function call(...)
        assert(not closed, 'debounced function is closed')

        generation = generation + 1
        local current = generation

        args = { ... }
        nargs = select('#', ...)

        timer:stop()
        timer:start(wait, 0, function()
            vim.schedule(function()
                if closed or current ~= generation then
                    return
                end

                local call_args = args
                local call_nargs = nargs
                args = nil
                nargs = 0

                fn(unpack(call_args, 1, call_nargs))
            end)
        end)
    end

    return setmetatable({
        cancel = cancel,
        close = close,
    }, {
        __call = function(_, ...)
            return call(...)
        end,
    })
end

return M
