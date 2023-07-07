local wezterm = require 'wezterm'
local module = {}

local statusBar = function(window, _)
    -- Each element holds the text for a cell in a "powerline" style << fade
    local cells = {}
    local keyFlag = false

    if window:leader_is_active() then
        keyFlag = true
        table.insert(cells, ' LEADER ')
    end

    local activeKeyTable = window:active_key_table()
    if activeKeyTable then
        keyFlag = true
        activeKeyTable = string.gsub(activeKeyTable, '_', ' ')
        activeKeyTable = string.upper(activeKeyTable)
        table.insert(cells, ' ' .. activeKeyTable .. ' ')
    end

    if not keyFlag then
        local workspace = window:mux_window():get_workspace()
        if workspace then
            table.insert(cells,  workspace .. ' ')
        end

        local date = wezterm.strftime '%b %-d %H:%M '
        table.insert(cells, date)
    end

    local cellsLength = #cells

    -- Arrow
    local function getArrow(isFocused)
        local LEFT_ARROW = utf8.char(0xe0b3)
        local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

        if isFocused then
            return SOLID_LEFT_ARROW
        else
            return LEFT_ARROW
        end
    end

    -- Colors
    local TEXT_FG_COLOR = '#c0c0c0c'
    local UNFOCUSED_TEXT_FG_COLOR = '#7f7f7f'
    local function getColors(index, isFocused)
        local TABBAR_BG_COLOR = '#333333'
        local colors = {
            '#1995ad',
            '#1e656d',
            '#34888c',
        }

        if isFocused then
            if keyFlag then
                return wezterm.color.parse(colors[cellsLength - index + 1]):adjust_hue_fixed(180)
            else
                return colors[cellsLength - index + 1]
            end
        else
            return TABBAR_BG_COLOR
        end
    end

    -- The elements to be formatted
    local elements = {}
    -- How many cells have been formatted
    local num_cells = 0

    -- Translate a cell into elements
    local function push(text, isLast, isFocused)
        local cell_no = num_cells + 1
        if cell_no == 1 then
            table.insert(elements, { Foreground = { Color = isFocused and
                getColors(cell_no, isFocused) or UNFOCUSED_TEXT_FG_COLOR } })
            table.insert(elements, { Text = getArrow(isFocused) })
        end
        table.insert(elements, { Foreground = { Color = isFocused and TEXT_FG_COLOR or UNFOCUSED_TEXT_FG_COLOR} })
        table.insert(elements, { Background = { Color = getColors(cell_no, isFocused) } })
        table.insert(elements, { Text = ' ' .. text .. ' ' })
        if not isLast then
            table.insert(elements, { Foreground = { Color = isFocused and
                getColors(cell_no + 1, isFocused) or UNFOCUSED_TEXT_FG_COLOR } })
            table.insert(elements, { Text = getArrow(isFocused) })
        end
        num_cells = num_cells + 1
    end

    local isFocused = window:is_focused()
    while #cells > 0 do
        local cell = table.remove(cells, 1)
        push(cell, #cells == 0, isFocused)
    end

    window:set_right_status(wezterm.format(elements))
end

function module.apply_to_config(_)
    wezterm.on('update-status', statusBar)
    wezterm.on('window-focus-changed', statusBar)
end

return module

