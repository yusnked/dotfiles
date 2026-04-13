local M = {}

local fyler = require("fyler")

local is_absolute_path = require("self.lib.path.util").is_absolute_path
local map = require("plugins.util.keydesc").set

function M.config()
    local opts = {
        views = {
            finder = {
                default_explorer = false,
                close_on_select = false,
                follow_current_file = false,
                mappings = {
                    ["gx"] = function(self) vim.ui.open(self:cursor_node_entry().path) end,
                    ["-"] = "GotoParent",
                    ["_"] = "GotoCwd",
                    ["<C-g>"] = "GotoNode",
                    ["<CR>"] = "Select",
                    ["<BS>"] = "CollapseAll",
                    ["<localleader>c"] = function(self) vim.cmd.cd(self.files.root_path) end,
                    ["<localleader>l"] = function(self) vim.cmd.lcd(self.files.root_path) end,
                    ["<localleader>t"] = function(self) vim.cmd.tcd(self.files.root_path) end,
                },
            },
        },
    }
    fyler.setup(opts)

    ---@return integer
    local function get_fyler_win_id()
        local win_get_buf = vim.api.nvim_win_get_buf
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local bufnr = win_get_buf(win)
            if vim.bo[bufnr].filetype == "fyler" then
                return win
            end
        end
        return -1
    end

    -- root_dir をトップレベルとして開き, ツリーでそのバッファにカーソルを合わせる.
    map("n", "<leader>e", function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local fyler_win_id = get_fyler_win_id()

        if fyler_win_id ~= -1 then
            fyler.focus()
        else
            local root_dir = vim.fs.root(0, { ".git" })
            fyler.open { dir = root_dir, kind = "split_left_most" }
        end

        if is_absolute_path(bufname) then
            vim.defer_fn(function()
                fyler.navigate(bufname)
            end, 100)
        end
    end)
    map("n", "<leader>E", function() fyler.close() end)
end

return M
