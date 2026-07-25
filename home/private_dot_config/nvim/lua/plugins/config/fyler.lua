local M = {}

local fyler = require('fyler')

local map = require('plugins.util.keydesc').set

local function fyler_width()
    return math.min(35, math.max(20, math.floor(vim.o.columns * 0.25)))
end

---@param self fyler.Finder
local function get_cursor_path(self)
    local entry = require('fyler.finder').parse_cursor_line(self)
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
                ['='] = map_disabled,
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

    map('n', '<leader>e', function() fyler.open { width = fyler_width() } end)
    map('n', '<leader>E', fyler.close)
end

return M
