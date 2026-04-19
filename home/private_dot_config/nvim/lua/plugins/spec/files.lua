local keydesc = require('plugins.util.keydesc')

---@type LazySpec
return {
    {
        'stevearc/oil.nvim',
        dependencies = { 'nvim-mini/mini.icons' },
        keys = { { '-', function() require('oil').open() end, desc = 'Open parent dir' } },
        cmd = 'Oil',
        opts = { win_options = { signcolumn = 'yes:2' } },
        init = function(plugin)
            vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                group = vim.api.nvim_create_augroup('plugins_oil_lazyload_bufenter_dir', {}),
                callback = function(ctx)
                    if package.loaded[plugin.main] then return true end
                    if vim.bo[ctx.buf].buftype ~= '' then return end
                    if not require('self.lib.path.util').is_absolute_path(ctx.match) then return end

                    local stat = vim.uv.fs_stat(ctx.match)
                    if stat and stat.type == 'directory' then
                        local load = require('plugins.util.autocmd_capture').load_and_capture_events
                        load { plugins = { plugin.name } }:fire { 'BufReadCmd', 'BufEnter' }
                        return true
                    end
                end,
            })
        end,
        config = function(_, opts)
            require('oil').setup(opts)
            require('lazy').load { plugins = { 'oil-git-status.nvim' } }
        end,
    },
    {
        'refractalize/oil-git-status.nvim',
        opts = {},
    },
    {
        'A7Lavinraj/fyler.nvim',
        branch = 'stable',
        dependencies = { 'nvim-mini/mini.icons' },
        keys = keydesc.lazy {
            { '<leader>e', desc = 'Open/Focus left-most (fyler)' },
            { '<leader>E', desc = 'Close left-most (fyler)' },
        },
        cmd = 'Fyler',
        config = function() require('plugins.config.fyler').config() end,
    },
}
