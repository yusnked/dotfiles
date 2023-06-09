local wezterm = require 'wezterm'
local module = {}

local act = wezterm.action

local activateResizePaneOpt = {
    name = 'resize_pane',
    timeout_milliseconds = 1000,
    one_shot = false,
    replace_current = true,
    prevent_fallback = true,
}
local activateSelectTabOpt = {
    name = 'select_tab',
    timeout_milliseconds = 1000,
    one_shot = false,
    replace_current = true,
    until_unknown = true,
}

local options = {
    leader = { key = ';', mods = 'SUPER' },
    keys = {
        -- Disable default keybinds
        { key = 'Tab', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'Tab', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '!', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '!', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '\"', mods = 'ALT|CTRL', action = act.DisableDefaultAssignment },
        { key = '\"', mods = 'SHIFT|ALT|CTRL', action = act.DisableDefaultAssignment },
        { key = '#', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '#', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '$', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '$', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '%', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '%', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '%', mods = 'ALT|CTRL', action = act.DisableDefaultAssignment },
        { key = '%', mods = 'SHIFT|ALT|CTRL', action = act.DisableDefaultAssignment },
        { key = '&', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '&', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '\'', mods = 'SHIFT|ALT|CTRL', action = act.DisableDefaultAssignment },
        { key = '(', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '(', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = ')', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = ')', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '*', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '*', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '+', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '+', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '-', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '-', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '0', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '0', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '1', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '1', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '2', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '2', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '3', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '3', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '4', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '4', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '5', mods = 'SHIFT|ALT|CTRL', action = act.DisableDefaultAssignment },
        { key = '5', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '5', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '6', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '6', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '7', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '7', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '8', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '8', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '9', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '9', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '=', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '=', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '@', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '@', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'C', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'F', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'F', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'H', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'H', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'K', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'K', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'L', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'L', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'M', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'M', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'N', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'N', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'P', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'P', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'Q', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'Q', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'R', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'R', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'T', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'T', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'U', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'U', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'V', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'W', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'W', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'X', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'X', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'Z', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'Z', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '^', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '^', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '_', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = '_', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'c', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'f', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'h', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'k', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'k', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = 'l', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'm', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'n', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'p', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'q', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'r', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'r', mods = 'SUPER', action = act.ReloadConfiguration },
        { key = 't', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'u', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'v', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'w', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'w', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = 'x', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'z', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = '[', mods = 'SHIFT|SUPER', action = act.DisableDefaultAssignment },
        { key = ']', mods = 'SHIFT|SUPER', action = act.DisableDefaultAssignment },
        { key = '{', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '{', mods = 'SHIFT|SUPER', action = act.DisableDefaultAssignment },
        { key = '}', mods = 'SUPER', action = act.DisableDefaultAssignment },
        { key = '}', mods = 'SHIFT|SUPER', action = act.DisableDefaultAssignment },
        { key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'PageDown', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'PageDown', mods = 'SHIFT', action = act.DisableDefaultAssignment },
        { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'PageUp', mods = 'CTRL', action = act.DisableDefaultAssignment },
        { key = 'PageUp', mods = 'SHIFT', action = act.DisableDefaultAssignment },
        { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'LeftArrow', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'LeftArrow', mods = 'SHIFT|ALT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'RightArrow', mods = 'SHIFT|ALT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'UpArrow', mods = 'SHIFT|ALT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
        { key = 'DownArrow', mods = 'SHIFT|ALT|CTRL', action = act.DisableDefaultAssignment },

        -- Setting keybinds
        { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },
        { key = '0', mods = 'LEADER', action = act.ShowTabNavigator },
        { key = '0', mods = 'SUPER', action = act.ResetFontSize },
        { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
        { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
        { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
        { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
        { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
        { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
        { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
        { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
        { key = '9', mods = 'LEADER', action = act.ActivateTab(-1) },
        { key = ',', mods = 'LEADER', action = act.Multiple { act.ActivateTabRelative(-1), act.ActivateKeyTable(activateSelectTabOpt) }},
        { key = '.', mods = 'LEADER', action = act.Multiple { act.ActivateTabRelative(1), act.ActivateKeyTable(activateSelectTabOpt) }},
        { key = ';', mods = 'LEADER', action = act.PaneSelect },
        { key = ';', mods = 'LEADER|CTRL', action = act.PaneSelect { mode = 'SwapWithActive' } },
        { key = ';', mods = 'LEADER|SUPER', action = act.PaneSelect },
        { key = '=', mods = 'SUPER', action = act.IncreaseFontSize },
        { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
        { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
        { key = 'f', mods = 'LEADER', action = act.Search 'CurrentSelectionOrEmptyString' },
        { key = 'f', mods = 'SUPER', action = act.Search 'CurrentSelectionOrEmptyString' },
        { key = 'h', mods = 'LEADER', action = act.SplitPane { direction = 'Left' } },
        { key = 'h', mods = 'LEADER|CTRL', action = act.Multiple { act.AdjustPaneSize { 'Left', 1 }, act.ActivateKeyTable(activateResizePaneOpt) }},
        { key = 'h', mods = 'SUPER', action = act.HideApplication },
        { key = 'j', mods = 'LEADER', action = act.SplitPane { direction = 'Down' } },
        { key = 'j', mods = 'LEADER|CTRL', action = act.Multiple { act.AdjustPaneSize { 'Down', 1 }, act.ActivateKeyTable(activateResizePaneOpt) }},
        { key = 'k', mods = 'LEADER', action = act.SplitPane { direction = 'Up' } },
        { key = 'k', mods = 'LEADER|CTRL', action = act.Multiple { act.AdjustPaneSize { 'Up', 1 }, act.ActivateKeyTable(activateResizePaneOpt) }},
        { key = 'l', mods = 'LEADER', action = act.SplitPane { direction = 'Right' } },
        { key = 'l', mods = 'LEADER|CTRL', action = act.Multiple { act.AdjustPaneSize { 'Right', 1 }, act.ActivateKeyTable(activateResizePaneOpt) }},
        { key = 'm', mods = 'SUPER', action = act.Hide },
        { key = 'n', mods = 'LEADER', action = act.SpawnWindow },
        { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
        { key = 'p', mods = 'SHIFT|SUPER', action = act.ActivateCommandPalette },
        { key = 'q', mods = 'LEADER', action = act.QuitApplication },
        { key = 'q', mods = 'SUPER', action = act.QuitApplication },
        { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },
        { key = 's', mods = 'LEADER', action = act.QuickSelect },
        { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 't', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
        { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
        { key = 'w', mods = 'LEADER', action = act.CloseCurrentTab{ confirm = true } },
        { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
        { key = 'y', mods = 'LEADER', action = act.ActivateCopyMode },
        { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
        { key = 'Copy', mods = 'NONE', action = act.CopyTo 'Clipboard' },
        { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
        { key = 'Paste', mods = 'NONE', action = act.PasteFrom 'Clipboard' },
    },

    key_tables = {
        copy_mode = {
            { key = 'j', mods = 'CTRL', action = act.CopyMode { MoveForwardZoneOfType = 'Input' }},
            { key = 'k', mods = 'CTRL', action = act.CopyMode { MoveBackwardZoneOfType = 'Input' }},
            -- The following are default key bindings
            { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
            { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
            { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
            { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
            { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
            { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
            { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
            { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
            { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
            { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
            { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
            { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
            { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
            { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
            { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
            { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
            { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
            { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
            { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
            { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
            { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
            { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
            { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
            { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
            { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
            { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
            { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
            { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
            { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
            { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
            { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
            { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
            { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
            { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
            { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
            { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
            { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
            { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
            { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
            { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
            { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
            { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
            { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
            { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
            { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
            { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
            { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
            { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
            { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
            { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
            { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
            { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
            { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
            { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
            { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
            { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
            { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
            { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
            { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
            { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
            { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
            { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        },

        resize_pane = {
            { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
            { key = 'h', mods = 'CTRL', action = act.AdjustPaneSize { 'Left', 1 } },
            { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
            { key = 'j', mods = 'CTRL', action = act.AdjustPaneSize { 'Down', 1 } },
            { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
            { key = 'k', mods = 'CTRL', action = act.AdjustPaneSize { 'Up', 1 } },
            { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
            { key = 'l', mods = 'CTRL', action = act.AdjustPaneSize { 'Right', 1 } },

            { key = 'h', mods = 'SHIFT', action = act.AdjustPaneSize { 'Left', 3 } },
            { key = 'j', mods = 'SHIFT', action = act.AdjustPaneSize { 'Down', 3 } },
            { key = 'k', mods = 'SHIFT', action = act.AdjustPaneSize { 'Up', 3 } },
            { key = 'l', mods = 'SHIFT', action = act.AdjustPaneSize { 'Right', 3 } },

            { key = 'Escape', action = 'PopKeyTable' },
        },

        select_tab = {
            { key = ',', action = act.ActivateTabRelative(-1) },
            { key = ',', mods = 'CTRL', action = act.MoveTabRelative(-1) },
            { key = ',', mods = 'SHIFT', action = act.MoveTabRelative(-1) },
            { key = '.', action = act.ActivateTabRelative(1) },
            { key = '.', mods = 'CTRL', action = act.MoveTabRelative(1) },
            { key = '.', mods = 'SHIFT', action = act.MoveTabRelative(1) },
        },
    }
}

function module.apply_to_config(config)
    for k, v in pairs(options) do
        config[k] = v
    end
end

return module

