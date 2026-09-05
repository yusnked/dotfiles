local keydesc = require('plugins.util.keydesc')

---@type LazySpec
return {
    {
        'nvim-treesitter/nvim-treesitter',
        cmd = { 'TSUpdate' },
        build = ':TSUpdate',
        init = function()
            vim.api.nvim_create_autocmd('User', {
                group = vim.api.nvim_create_augroup('plugins.nvim-treesitter.enable_indent', {}),
                pattern = 'TreesitterAttach',
                callback = function(ctx)
                    ---@type self.treesitter.TreesitterAttachData
                    local data = ctx.data
                    if data.spec.indent then
                        vim.bo[data.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
                desc = 'Enable Tree-sitter indentation',
            })
        end,
        config = function()
            -- setup 呼び出し不要. install_dir のデフォルトは stdpath('data') .. '/site'.
            require('nvim-treesitter').install(vim.tbl_keys(require('self.treesitter.languages')))
        end,
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
