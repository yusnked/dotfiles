local M = {}
local data = require('self.desc.data')
M.n = data.normal_mode
M.v = data.visual_mode
M.x = data.visual_mode
M.i = data.insert_mode
M.c = data.command_mode

M.get = function(mode, lhs, enable_wrap)
    local desc = M[mode]
    if desc == nil then
        return nil
    end
    local keys = require('self.helpers').split_keys(lhs)
    for _, key in ipairs(keys) do
        desc = desc[key]
        if desc == nil then
            return nil
        end
    end
    if desc == 'which_key_ignore' then
        return nil
    end
    if desc.name then
        desc = desc.name
    end
    if enable_wrap then
        return { desc = desc }
    else
        return desc
    end
end

M.set_keymap = function(mode, lhs, rhs, opts)
    opts = opts or {}
    if type(mode) == 'table' then
        for _, v in ipairs(mode) do
            if opts.desc == nil then
                local desc = M.get(v, lhs)
                if desc then
                    local copied_opts = vim.deepcopy(opts)
                    copied_opts.desc = desc
                    vim.keymap.set(v, lhs, rhs, copied_opts)
                    goto continue
                end
            end
            vim.keymap.set(v, lhs, rhs, opts)
            ::continue::
        end
    else
        if opts.desc == nil then
            opts.desc = M.get(mode, lhs)
        end
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

-- Function for keys in lazy.nvim
M.lazy_key = function(table)
    local lhs = table[1]
    local mode = table.mode
    if mode == nil then
        mode = 'n'
    elseif type(mode) == 'table' then
        mode = table.mode[1]
    end
    if table.desc == nil then
        table.desc = M.get(mode, lhs)
    end
    return table
end
M.lazy_keys = function(key_table)
    local ret = {}
    for _, key in ipairs(key_table) do
        if type(key) == 'string' then
            key = { key }
        end
        table.insert(ret, M.lazy_key(key))
    end
    return ret
end

return M
