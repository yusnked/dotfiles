local M = {}

local function cond_encoding()
    return not (vim.bo.fileencoding == "utf-8" and not vim.bo.bomb)
end

local statusline_lualine_c = {
    { "%n" },
    { "filesize", separator = "", padding = { left = 1 } },
    { "filetype", icon_only = true, padding = { left = 1, right = 0 }, separator = "" },
    {
        function()
            if vim.bo.filetype ~= "" then
                return ""
            else
                return " "
            end
        end,
        separator = "",
        padding = 0,
    },
    { "filename", path = 1, padding = { left = 0, right = 1 } },
}
local statusline_lualine_x = {
    { "encoding", show_bomb = true, cond = cond_encoding },
    { "fileformat", cond = function() return vim.bo.fileformat ~= "unix" end },
    { "%-5.(%l:%v%) %P" },
}

function M.setup()
    vim.opt.showmode = false
    vim.opt.showcmd = false

    local lualine = require("lualine")
    local selcount_var = "lualine_selcount"
    local abbrev_cwd_var = "lualine_abbrev_cwd"

    lualine.setup {
        options = {
            globalstatus = true,
            disabled_filetypes = {
                statusline = {},
                winbar = { "man", "qf" },
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "w:" .. selcount_var, "searchcount" },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { "branch" },
            lualine_z = { "w:" .. abbrev_cwd_var },

        },
        winbar = {
            lualine_c = statusline_lualine_c,
            lualine_x = statusline_lualine_x,
        },
        inactive_winbar = {
            lualine_c = statusline_lualine_c,
            lualine_x = statusline_lualine_x,
        },
        tabline = {
            lualine_a = {
                {
                    "tabs",
                    mode = 2,
                    use_mode_colors = true,
                    symbols = { modified = "+" },
                    max_length = function() return vim.o.columns end,
                },
            },
        },
        extensions = { "man", "quickfix" },
    }

    -- Abbreviated cwd
    require("self.modules.statusline.abbrev_cwd").setup {
        wvar = abbrev_cwd_var,
        effort_width_fn = function()
            return math.max(vim.o.columns * 0.5, 40)
        end,
        project_markers = { ".git" },
    }

    -- Selection count
    require("self.modules.statusline.selcount").setup {
        wvar = selcount_var,
        poll_ms = 200,
        on_update = lualine.refresh,
    }
end

return M
