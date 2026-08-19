local M = {}

local tabpagenr = vim.fn.tabpagenr

local function cond_encoding()
    return not (vim.bo.fileencoding == 'utf-8' and not vim.bo.bomb)
end

local function separator_factory(fn)
    return {
        fn,
        separator = '',
        padding = 0,
    }
end

function M.setup()
    vim.opt.showmode = false
    vim.opt.showcmd = false

    local lualine = require('lualine')
    local selection_count_var = 'lualine_selection_count'
    local abbrev_cwd_var = 'lualine_abbrev_cwd'

    local left_hard_sep = ''
    local right_hard_sep = ''
    local left_soft_sep = ''
    local right_soft_sep = ''

    local leftmost_sep_component = separator_factory(function()
        return left_hard_sep
    end)
    local rightmost_sep_component = separator_factory(function()
        return right_hard_sep
    end)
    local tab_leftmost_sep_component = separator_factory(function()
        return tabpagenr() == 1 and left_hard_sep or '█'
    end)

    local winbar = {
        lualine_b = {
            {
                'diff',
                source = function()
                    local gitsigns = vim.b.gitsigns_status_dict
                    if gitsigns then
                        return {
                            added = gitsigns.added,
                            modified = gitsigns.changed,
                            removed = gitsigns.removed,
                        }
                    end
                    return nil
                end,
            },
        },
        lualine_c = {
            { '%n' },
            { 'filesize', separator = '', padding = { left = 1 } },
            { 'filetype', icon_only = true, padding = { left = 1, right = 0 }, separator = '' },
            {
                function() return vim.bo.filetype ~= '' and '' or ' ' end,
                separator = '',
                padding = 0,
            },
            { 'filename', path = 1, padding = { left = 0, right = 1 } },
        },
        lualine_x = {
            { 'encoding', show_bomb = true, cond = cond_encoding },
            { 'fileformat', cond = function() return vim.bo.fileformat ~= 'unix' end },
            { '%-5.(%l:%v%) %P' },
        },
    }

    lualine.setup {
        options = {
            globalstatus = true,
            disabled_filetypes = {
                statusline = {},
                winbar = { 'fyler_finder', 'man', 'qf' },
            },
            component_separators = { left = left_soft_sep, right = right_soft_sep },
            section_separators = { left = left_hard_sep, right = right_hard_sep },
        },
        sections = {
            lualine_a = { leftmost_sep_component, { 'mode' } },
            lualine_b = { 'g:' .. selection_count_var, 'searchcount' },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { 'branch' },
            lualine_z = {
                { 'w:' .. abbrev_cwd_var, separator = '' },
                rightmost_sep_component,
            },
        },
        winbar = winbar,
        inactive_winbar = winbar,
        tabline = {
            lualine_a = {
                tab_leftmost_sep_component,
                {
                    'tabs',
                    mode = 2,
                    use_mode_colors = true,
                    symbols = { modified = '+' },
                    max_length = function() return vim.o.columns end,
                },
            },
        },
        extensions = { 'man', 'quickfix' },
    }

    -- Abbreviated cwd
    require('self.modules.statusline.abbrev_cwd').setup {
        wvar = abbrev_cwd_var,
        effort_width_fn = function()
            return math.max(vim.o.columns * 0.5, 40)
        end,
        project_markers = { '.git' },
    }

    ---@param count self.modules.selection_count.Count
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
            if count then
                vim.g[selection_count_var] = format_selection_count(count)
            else
                vim.g[selection_count_var] = nil
            end

            lualine.refresh { place = { 'statusline' } }
        end,
    }
end

return M
