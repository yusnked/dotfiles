local M = {}

local keydesc = require('plugins.util.keydesc')

M.config = function()
    local vt = require('various-textobjs')
    local map = keydesc.set

    map({ 'o', 'x' }, 'iS', function() vt.subword('inner') end)
    map({ 'o', 'x' }, 'aS', function() vt.subword('outer') end)
end

return M
