local M = {}

local keydesc = require('plugins.util.keydesc')

M.config = function()
    local config = require('dial.config')
    local augend = require('dial.augend')
    local default_augend = {
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.date.alias['%Y/%m/%d'],
        augend.date.alias['%Y-%m-%d'],
        augend.date.alias['%m/%d'],
        augend.date.alias['%H:%M'],
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.hexcolor.new { case = 'lower' },
    }

    local function case_factory(case)
        return {
            augend.case.new {
                types = { 'snake_case', case },
            },
            augend.case.new {
                types = { 'PascalCase', 'SCREAMING_SNAKE_CASE' },
            },
        }
    end

    config.augends:register_group {
        default = default_augend,
        case_a = case_factory('camelCase'),
        case_x = case_factory('kebab-case'),
    }

    local function extend_default(extra)
        local l = vim.list_extend({}, default_augend)
        return vim.list_extend(l, extra)
    end

    local js_augend = extend_default {
        augend.constant.new { elements = { 'let', 'const' } },
    }
    config.augends:on_filetype {
        javascript = js_augend,
        typescript = js_augend,
        javascriptreact = js_augend,
        typescriptreact = js_augend,
    }

    local dial_map = require('dial.map')
    local keymap = keydesc.set
    keymap('n', '<C-a>', dial_map.inc_normal())
    keymap('n', '<C-x>', dial_map.dec_normal())
    keymap('x', '<C-a>', dial_map.inc_visual())
    keymap('x', '<C-x>', dial_map.dec_visual())
    keymap('n', 'g<C-a>', dial_map.inc_gnormal())
    keymap('n', 'g<C-x>', dial_map.dec_gnormal())
    keymap('x', 'g<C-a>', dial_map.inc_gvisual())
    keymap('x', 'g<C-x>', dial_map.dec_gvisual())
    keymap('n', '<leader><C-a>', dial_map.inc_normal('case_a'))
    keymap('n', '<leader><C-x>', dial_map.dec_normal('case_x'))
    keymap('x', '<leader><C-a>', dial_map.inc_visual('case_a'))
    keymap('x', '<leader><C-x>', dial_map.dec_visual('case_x'))
end

return M
