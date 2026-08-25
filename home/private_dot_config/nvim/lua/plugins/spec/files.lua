local keydesc = require('plugins.util.keydesc')

---@type LazySpec
return {
    {
        'stevearc/oil.nvim',
        dependencies = { 'nvim-mini/mini.icons' },
        keys = { { '-', function() require('oil').open() end, desc = 'Open parent dir (oil)' } },
        cmd = 'Oil',
        main = 'oil',
        opts = { win_options = { signcolumn = 'yes:2' } },
        init = function(plugin)
            vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                group = vim.api.nvim_create_augroup('plugins.oil.lazy_load', {}),
                pattern = '/*',
                callback = function(ctx)
                    if package.loaded[plugin.main] then return true end
                    if vim.bo[ctx.buf].buftype ~= '' then return end

                    local path = ctx.match

                    -- PERF: vim.uv.fs_stat(path).type == 'directory' より 約 2.5 倍速い. (v0.12.5)
                    if vim.fn.isdirectory(path) == 1 then
                        vim.schedule(function()
                            require('oil').open(path)
                            -- oil.nvim がロードされた後にロードする必要がある.
                            require('lazy').load { plugins = { 'oil-git-status.nvim' } }
                        end)
                        return true
                    end
                end,
                desc = 'Lazy-load Oil when opening a directory',
            })
        end,
    },
    {
        'refractalize/oil-git-status.nvim',
        opts = {},
    },
    {
        'FylerOrg/fyler.nvim',
        dependencies = { 'nvim-mini/mini.icons' },
        keys = keydesc.lazy {
            { '<leader>e', desc = 'Open or focus the leftmost finder (fyler)' },
            { '<leader>E', desc = 'Close the leftmost finder (fyler)' },
        },
        cmd = 'Fyler',
        config = function() require('plugins.config.fyler').config() end,
    },
}
