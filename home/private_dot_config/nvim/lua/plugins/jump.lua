return {
    {
        'ggandor/leap.nvim',
        dependencies = { 'tpope/vim-repeat' },
        keys = {
            { 's', mode = { 'n', 'x', 'o' }, desc = 'Jump in the current window' },
            { 'S', desc = 'Jump to other windows' },
            { 'gs', mode = { 'n', 'x', 'o' }, desc = 'Select Tree-sitter nodes' },
        },
        config = function()
            require('leap').setup {}
            local keymap = vim.keymap.set
            keymap({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
            keymap('n', 'S', '<Plug>(leap-from-window)')

            -- Select Tree-sitter nodes.
            local api = vim.api
            local ts = vim.treesitter
            local function get_ts_nodes()
                if not pcall(ts.get_parser) then return end
                local wininfo = vim.fn.getwininfo(api.nvim_get_current_win())[1]
                local cur_node = ts.get_node()
                if not cur_node then return end
                local nodes = { cur_node }
                local parent = cur_node:parent()
                while parent do
                    table.insert(nodes, parent)
                    parent = parent:parent()
                end
                local targets = {}
                local startline, startcol, endline, endcol
                for _, node in ipairs(nodes) do
                    startline, startcol, endline, endcol = node:range()
                    local startpos = { startline + 1, startcol + 1 }
                    local endpos = { endline + 1, endcol + 1 }
                    if startline + 1 >= wininfo.topline then
                        table.insert(targets, { pos = startpos, altpos = endpos })
                    end
                    if endline + 1 <= wininfo.botline then
                        table.insert(targets, { pos = endpos, altpos = startpos })
                    end
                end
                if #targets >= 1 then return targets end
            end
            local function select_node_range(target)
                local mode = api.nvim_get_mode().mode
                if not mode:match('no?') then vim.cmd('normal! ' .. mode) end
                vim.fn.cursor(target.pos[1], target.pos[2])
                local v = mode:match('V') and 'V' or mode:match('�') and '�' or 'v'
                vim.cmd('normal! ' .. v)
                vim.fn.cursor(target.altpos[1], target.altpos[2])
            end
            local function leap_ts()
                require('leap').leap {
                    target_windows = { api.nvim_get_current_win() },
                    targets = get_ts_nodes,
                    action = select_node_range,
                }
            end
            keymap({ 'n', 'x', 'o' }, 'gs', leap_ts)
        end,
    },
    {
        'ggandor/flit.nvim',
        dependencies = { 'ggandor/leap.nvim', 'tpope/vim-repeat' },
        keys = {
            { 'f', mode = { 'n', 'x', 'o' } },
            { 'F', mode = { 'n', 'x', 'o' } },
            { 't', mode = { 'n', 'x', 'o' } },
            { 'T', mode = { 'n', 'x', 'o' } },
        },
        opts = {
            labeled_modes = 'nvo',
            multiline = false,
        },
    },
    {
        'andymass/vim-matchup',
        version = '*',
        event = { 'CursorHold', 'CursorHoldI' },
        config = function()
            vim.api.nvim_exec_autocmds({ 'FileType' }, { group = 'matchup_filetype' })
        end,
    },
}
