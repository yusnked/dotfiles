local M = {}

local keydesc = require('plugins.util.keydesc')

M.config = function()
    local sub = require('substitute')
    sub.setup()

    local function add_reindent_mods(func)
        return function()
            func {
                modifiers = function(state)
                    if state.vmode == 'line' then
                        return { 'reindent' }
                    end
                end,
            }
        end
    end

    local keymap = keydesc.set
    keymap('n', '<leader>s', add_reindent_mods(sub.operator))
    keymap('n', '<leader>ss', add_reindent_mods(sub.line))
    keymap('n', '<leader>S', add_reindent_mods(sub.eol))
    keymap('x', '<leader>s', add_reindent_mods(sub.visual))

    local sub_ex = require('substitute.exchange')
    keymap('n', '<leader>sx', sub_ex.operator)
    keymap('n', '<leader>sxx', sub_ex.line)
    keymap('x', 'X', sub_ex.visual)
    keymap('n', '<leader>sxc', sub_ex.cancel, { desc = 'Cancel exchange' })
end

return M
