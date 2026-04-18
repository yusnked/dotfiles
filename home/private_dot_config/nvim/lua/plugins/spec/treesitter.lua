local keydesc = require('plugins.util.keydesc')
local treesitter = require('plugins.config.treesitter')

return {
    {
        'nvim-treesitter/nvim-treesitter',
        cmd = { 'TSUpdate' },
        build = ':TSUpdate',
        init = treesitter.init,
        config = treesitter.config,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        event = 'User TreesitterAttach',
        init = function()
            -- Disable entire built-in ftplugin mappings.
            vim.g.no_plugin_maps = true
        end,
        config = function()
            local select = require('nvim-treesitter-textobjects.select')
            vim.keymap.set({ 'x', 'o' }, 'im', function()
                select.select_textobject('@function.inner', 'textobjects')
            end, { desc = 'inner function' })
            vim.keymap.set({ 'x', 'o' }, 'am', function()
                select.select_textobject('@function.outer', 'textobjects')
            end, { desc = 'function' })
        end,
    },
    {
        'folke/ts-comments.nvim',
        event = 'User TreesitterAttach',
        opts = {},
    },
    {
        'Wansmer/treesj',
        keys = keydesc.lazy { { 'J', desc = 'TreeSJ toggle; fallback to native J' } },
        config = function()
            local function treesj_or_native_J()
                local bufnr = vim.api.nvim_get_current_buf()
                local parser = vim.treesitter.get_parser(bufnr)
                if not parser then
                    vim.cmd(('normal! %dJ'):format(vim.v.count1))
                    return
                end
                require('treesj').toggle()
            end
            keydesc.set('n', 'J', treesj_or_native_J, { silent = true })
        end,
    },
}
