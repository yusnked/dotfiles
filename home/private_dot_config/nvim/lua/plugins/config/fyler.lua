local M = {}

local fyler = require('fyler')

-- fyler.finder は setup 後じゃないと呼べないのでプロキシ経由で呼ぶ.
---@module 'fyler.finder'
local fyler_finder = fyler.import('fyler.finder')

local map = require('plugins.util.keydesc').set

local function fyler_width()
    return math.min(35, math.max(20, math.floor(vim.o.columns * 0.25)))
end

---@param self fyler.Finder
local function get_cursor_path(self)
    local entry = fyler_finder.parse_cursor_line(self)
    if not entry then return end

    return entry.path
end

function M.config()
    ---@type fyler.Mapping
    local map_disabled = { disabled = true }
    ---@type fyler.Mapping
    local map_open = {
        action = 'select',
        args = { pick = true },
        opts = { desc = 'Open with window picker (fyler)' },
    }
    ---@type fyler.UserConfig
    local opts = {
        use_as_default_explorer = false,
        kind = 'split_left_most',
        mappings = {
            n = {
                ['.'] = map_disabled,
                ['g.'] = map_disabled,
                ['gi'] = map_disabled,
                ['q'] = map_disabled,
                ['<C-r>'] = map_disabled,
                ['<C-s>'] = map_disabled,
                ['<C-t>'] = map_disabled,
                ['<C-v>'] = map_disabled,
                ['gx'] = {
                    action = function(self)
                        local path = get_cursor_path(self)
                        if path then
                            vim.ui.open(path)
                        end
                    end,
                    opts = { desc = 'Open externally (fyler)' },
                },
                ['-'] = {
                    action = 'visit',
                    args = { parent = true },
                    opts = { desc = 'Go to parent directory (fyler)' },
                },
                ['='] = {
                    action = 'visit',
                    opts = { desc = 'Go to root directory (fyler)' },
                },
                ['<2-LeftMouse>'] = map_open,
                ['<CR>'] = map_open,
                ['<BS>'] = {
                    action = 'shrink',
                    args = { parent = true },
                    opts = { desc = 'Collapse parent directory (fyler)' },
                },
                ['<localleader>.'] = {
                    action = 'visit',
                    args = { cursor = true },
                    opts = { desc = 'Enter directory under cursor (fyler)' },
                },
                ['<localleader>h'] = {
                    action = 'toggle_ui',
                    args = { 'hidden_items' },
                    opts = { desc = 'Toggle hidden files (fyler)' },
                },
                ['<localleader>r'] = {
                    action = 'refresh',
                    args = { recursive = true, force = true },
                    opts = { desc = 'Force refresh tree (fyler)' },
                },
                ['<localleader><C-s>'] = {
                    action = 'select',
                    args = { split = true },
                    opts = { desc = 'Open in horizontal split (fyler)' },
                },
                ['<localleader><C-t>'] = {
                    action = 'select',
                    args = { tabedit = true },
                    opts = { desc = 'Open in new tab (fyler)' },
                },
                ['<localleader><C-v>'] = {
                    action = 'select',
                    args = { vsplit = true },
                    opts = { desc = 'Open in vertical split (fyler)' },
                },
            },
        },
        ui = {
            hidden_items = {
                switches = { 'dotfiles' },
                patterns = {},
                always_visible = {},
                always_hidden = {},
            },
            indent_guides = true,
        },
        extensions = {
            git = { enabled = true },
        },
        integrations = {
            icon = 'mini_icons',
        },
    }
    fyler.setup(opts)

    map('n', '<leader>e', function()
        fyler.open { width = fyler_width() }

        -- fyler 以外のウィンドウが1つで, そのウィンドウで quit が実行された時,
        -- fyler ウィンドウでも quit を実行する.
        vim.defer_fn(function()
            -- Finderインスタンスはタブごとに最大1つ.
            -- Finderを閉じて再度開くたびにバッファが再作成され, buf_idも変わる.
            local tab = vim.api.nvim_get_current_tabpage()
            local finder = fyler_finder.instance_get_or_nil(tab)
            if finder == nil then
                vim.notify('Failed to get the Fyler finder instance for the current tab.',
                    vim.log.levels.WARN,
                    { title = 'fyler (<leader>e)' })
                return
            end

            vim.api.nvim_create_autocmd('BufEnter', {
                group = vim.api.nvim_create_augroup('plugins_fyler_quit', {}),
                buf = finder.buf_id,
                callback = function()
                    -- NOTE: EXTRACT get_normal_wins()
                    local normal_wins = vim.iter(vim.api.nvim_tabpage_list_wins(0))
                        :filter(function(win)
                            return vim.api.nvim_win_get_config(win).relative == ''
                        end)
                        :totable()
                    if #normal_wins ~= 1 then return end

                    local prev_cmd = vim.fn.histget('cmd', -1)
                    if vim.regex([[\v^(q%[uit]!?|wq)$]]):match_str(prev_cmd) then
                        vim.cmd.quit()
                    end
                end,
                desc = 'Quit when Fyler is the last window',
            })
        end, 0)
    end)
    map('n', '<leader>E', fyler.close)
end

return M
