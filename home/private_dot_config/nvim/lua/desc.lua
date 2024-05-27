local M = {}

local normal_mode = {
    c = {
        s = 'Change Surround',
        S = 'Change Surround, New-line',
    },
    d = {
        s = 'Delete a surrounding pair',
    },
    g = {
        a = 'hello',
        b = {
            desc = 'Comment Block',
            name = 'Comment toggle blockwise',
            c = 'Comment toggle current block',
        },
        c = {
            desc = 'Comment Line',
            name = 'Comment toggle linewise',
            c = 'Comment toggle current line',
            O = 'Comment insert below',
            o = 'Comment insert above',
            A = 'Comment insert end of line',
        },
    },
    y = {
        s = {
            desc = 'Surround Add',
            name = 'Add Surround',
            s = 'Add Surround, Current-line',
        },
        S = {
            desc = 'Surround Add NL',
            name = 'Add Surround, New-line',
            S = 'Add Surround, Current-line, New-line',
        },
    },
    ['-'] = 'Open parent dir by oil.nvim',
    ['<C-b>'] = 'Scroll upwards a screen',
    ['<C-d>'] = 'Scroll downwords half a screen',
    ['<C-f>'] = 'Scroll downwords a screen',
    ['<C-u>'] = 'Scroll upwards half a screen',
    ['<Leader>'] = {
        f = {
            name = 'Telescope',
            a = 'Telescope all pickers',
            b = 'Telescope buffers',
            c = 'Telescope commands',
            f = 'Telescope live_grep',
            g = {
                name = 'Telescope Git',
                b = 'Telescope git_branches',
                c = 'Telescope git_bcommits',
                f = 'Telescope git_file',
                h = 'Telescope ghq list',
                q = 'Telescope git_stash',
                s = 'Telescope git_status',
                C = 'Telescope git_commits',
            },
            j = 'Telescope jumplist',
            l = 'Telescope loclist',
            m = 'Telescope marks',
            n = 'Telescope notify',
            o = 'Telescope vim_options',
            p = 'Telescope project',
            q = 'Telescope quickfixhistory',
            t = 'Telescope treesitter',
            R = 'Telescope registers',
        },
        p = 'Telescope fd',
        s = {
            desc = 'Substitute',
            name = 'Substitute Operator',
            s = 'Substitute Line',
            x = {
                desc = 'Substitute Exchange',
                name = 'Substitute Exchange Operator',
                x = 'Substitute Exchange Line',
            },
        },
        S = 'Substitute EOL',
        ['*'] = 'Telescope grep_string',
    },
}

local visual_mode = {
    g = {
        a = 'world',
        b = 'Comment toggle blockwise',
        c = 'Comment toggle linewise',
        S = 'Add Surround, New-line',
    },
    S = 'Add Surround',
    ['<Leader>'] = {
        s = 'Substitute Visual',
        S = 'Substitute Exchange Visual',
    },
}

local insert_mode = {
    ['<C-g>'] = {
        s = 'Add Surround around Cursor',
        S = 'Add Surround around Cursor, New-line',
    },
}

local command_mode = {
    ['<C-t>'] = 'Telescope command_history',
}

M.n = normal_mode
M.v = visual_mode
M.x = visual_mode
M.i = insert_mode
M.c = command_mode

M.get = function(mode, lhs, enable_wrap)
    local desc = M[mode]
    if desc == nil then
        return nil
    end
    local keys = require('helpers').split_keys(lhs)
    for _, key in ipairs(keys) do
        desc = desc[key]
        if desc == nil then
            return nil
        end
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
