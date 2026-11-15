---@module 'lazy'
---@type LazySpec[]
return {
    {
        'nvim-mini/mini.icons',
        config = function()
            local icons = require('mini.icons')

            local function get(category, name)
                local glyph, hl = icons.get(category, name)
                return { glyph = glyph, hl = hl }
            end

            icons.setup {
                filetype = {
                    fyler = get('default', 'directory'),
                },
            }

            -- nvim-web-devicons が登録されていないときだけモックする.
            if not require('lazy.core.config').plugins['nvim-web-devicons'] then
                icons.mock_nvim_web_devicons()
            end
        end,
    },
    { 'nvim-lua/plenary.nvim' },
}
