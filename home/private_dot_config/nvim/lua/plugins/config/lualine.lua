local M = {}

local lualine = require('lualine')
local is_focused = require('lualine.utils.utils').is_focused

local vim_o = vim.o
local vim_bo = vim.bo

local fn_tabpagenr = vim.fn.tabpagenr

local sep_left_hard = ''
local sep_left_soft = ''
local sep_right_hard = ''
local sep_right_soft = ''

local color_black = '#16161e'
local color_red = '#f7768e'
local color_white = '#c5d0ff'
local color_yellow = '#ffda65'

local padding_none = 0
local padding_left = { left = 1 }
local padding_right = { right = 1 }

---@type string
local abbrev_cwd_var = 'lualine_abbrev_cwd'
---@type string
local selection_count = ''

local function inactive_bg()
    if not is_focused() then
        return color_black
    end
end

---@param sep string|fun(): string
---@return table
local function sep_component(sep)
    local fn = (type(sep) == 'string') and function() return sep end or sep
    return { fn, separator = '', padding = padding_none }
end

local comp_bufnr = {
    '%n',
    color = function()
        local bufhidden = vim_bo.bufhidden

        if bufhidden == 'delete' or bufhidden == 'wipe' then
            return { fg = color_red, bg = inactive_bg() }
        elseif bufhidden == 'hide' or bufhidden == 'unload' or not vim_bo.buflisted then
            return { fg = color_yellow, bg = inactive_bg() }
        else
            return { fg = color_white, bg = inactive_bg() }
        end
    end,
}

local comp_diff = {
    'diff',
    -- 既に gitsigns.nvim で計算したデータを再利用する.
    source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if not gitsigns then
            return
        end

        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end,
    padding = padding_right,
}

local comp_encoding = {
    'encoding',
    show_bomb = true,
    cond = function()
        return not (vim_bo.fileencoding == 'utf-8' and not vim_bo.bomb)
    end,
}

local comp_fileformat = { 'fileformat', cond = function() return vim_bo.fileformat ~= 'unix' end }

local comp_filesize = {
    'filesize',
    color = function()
        return { fg = vim_bo.modified and color_yellow or color_white, bg = inactive_bg() }
    end,
    separator = '',
}

local comp_ruler = { '%-5.(%l:%v%) %P' }

local comp_tabs = {
    'tabs',
    mode = 2,
    use_mode_colors = true,
    symbols = { modified = '+' },
    max_length = function() return vim_o.columns end,
}

local comps_filename_with_icon = {
    { 'filetype', icon_only = true, separator = '', padding = padding_left },
    {
        function() return vim_bo.filetype ~= '' and '' or ' ' end,
        separator = '',
        padding = padding_none,
    },
    { 'filename', path = 1, padding = padding_none },
}

local winbar = {
    lualine_b = { comp_bufnr, comp_filesize, comp_diff },
    lualine_c = { unpack(comps_filename_with_icon) },
    lualine_x = { comp_encoding, comp_fileformat, comp_ruler },
}

local function setup_abbrev_cwd()
    require('self.modules.statusline.abbrev_cwd').setup {
        wvar = abbrev_cwd_var,
        effort_width_fn = function()
            return math.max(vim_o.columns * 0.5, 40)
        end,
        project_markers = { '.git' },
    }
end

local function setup_selection_count()
    ---@param count self.modules.selection_count.Count
    ---@return string
    local function format_selection_count(count)
        if count.chars == nil then
            return string.format('%dL', count.lines)
        elseif count.chars == count.bytes then
            return string.format('%dL %dC', count.lines, count.chars)
        else
            return string.format('%dL %dC %dB', count.lines, count.chars, count.bytes)
        end
    end

    require('self.modules.selection_count').setup {
        on_update = function(count)
            selection_count = count and format_selection_count(count) or ''

            lualine.refresh { place = { 'statusline' } }
        end,
    }
end

function M.config()
    vim_o.showmode = false
    vim_o.showcmd = false

    lualine.setup {
        options = {
            globalstatus = true,
            disabled_filetypes = {
                statusline = {},
                winbar = { 'fyler_finder', 'man', 'qf' },
            },
            component_separators = { left = sep_left_soft, right = sep_right_soft },
            section_separators = { left = sep_left_hard, right = sep_right_hard },
        },
        sections = {
            lualine_a = { sep_component(sep_left_hard), 'mode' },
            lualine_b = { function() return selection_count end, 'searchcount' },
            lualine_c = {},
            lualine_x = { 'lsp_status' },
            lualine_y = { 'branch' },
            lualine_z = { { 'w:' .. abbrev_cwd_var, separator = '' }, sep_component(sep_right_hard) },
        },
        winbar = winbar,
        inactive_winbar = winbar,
        tabline = {
            lualine_a = {
                sep_component(function() return fn_tabpagenr() == 1 and sep_left_hard or '█' end),
                comp_tabs,
            },
        },
        -- lazy, mason, oil は使用しない.
        extensions = { 'man', 'quickfix' },
    }

    setup_abbrev_cwd()
    setup_selection_count()
end

return M
