-- 現在は macOS のみ対応.
if not require('self.env').is_macos then
    return
end

---@param name string
---@param wait boolean?
---@return vim.SystemCompleted?
local function ghostty_action(name, wait)
    local proc = vim.system {
        'osascript',
        '-e',
        ([[
            tell application "Ghostty"
                set term to focused terminal of selected tab of front window
                perform action %q on term
            end tell
        ]]):format(name),
    }

    if wait then
        return proc:wait()
    end
end

--- Window 移動時, その方向が端なら Ghostty split への移動を試みる.
---@param key 'h'|'j'|'k'|'l'
---@param direction 'left'|'down'|'up'|'right'
local function goto_split(key, direction)
    if vim.fn.winnr(key) == vim.fn.winnr() then
        ghostty_action('goto_split:' .. direction)
        return
    end
    vim.cmd.wincmd(key)
end

local map = vim.keymap.set

for key, direction in pairs { h = 'left', j = 'down', k = 'up', l = 'right' } do
    local opts = { desc = 'Go to ' .. direction .. ' split (Neovim/Ghostty)' }
    map('n', '<C-w>' .. key, function() goto_split(key, direction) end, opts)
    map('n', '<C-w><C-' .. key .. '>', function() goto_split(key, direction) end, opts)
end

-- Ghostty 付属の Neovim runtime を読み込む.
local resources_dir = vim.env.GHOSTTY_RESOURCES_DIR
if resources_dir then
    require('plugins.lazy').add_specs {
        {
            'ghostty',
            dir = vim.fs.normalize(resources_dir .. '/../nvim/site'),
            event = 'BufReadPre *.ghostty',
        },
    }
end
