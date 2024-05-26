return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        config = function()
            local filename_with_icon = {
                { 'filetype', icon_only = true, padding = { left = 1, right = 0 }, separator = '' },
                {
                    function()
                        if vim.bo.filetype ~= '' then
                            return ''
                        else
                            return ' '
                        end
                    end,
                    separator = '',
                    padding = 0,
                },
                { 'filename', path = 1, padding = { left = 0, right = 1 } },
            }
            require('lualine').setup {
                sections = {
                    lualine_b = {},
                    lualine_c = filename_with_icon,
                    lualine_x = {
                        { 'encoding', cond = function() return vim.bo.fileencoding ~= 'utf-8' end },
                        { 'fileformat', cond = function() return vim.bo.fileformat ~= 'unix' end },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
                inactive_sections = {
                    lualine_c = filename_with_icon,
                    lualine_x = {},
                },
                tabline = {
                    lualine_a = { { 'tabs', use_mode_colors = true, symbols = { modified = '' } } },
                    lualine_x = { { 'w:abbrev_cwd', max_length = math.max(vim.o.columns * 0.4, 32) } },
                    lualine_y = { 'diagnostics', 'diff', 'branch' },
                    lualine_z = { 'progress' },
                },
                extensions = {
                    'lazy',
                    'nvim-tree',
                    'oil',
                    'quickfix',
                    'toggleterm',
                },
            }

            local set_abbrev_cwd = function()
                local scope_label = ''
                if vim.fn.haslocaldir() ~= 0 then
                    scope_label = ' [L]'
                elseif vim.fn.haslocaldir(-1, 0) ~= 0 then
                    scope_label = ' [T]'
                end
                local width = math.max(vim.o.columns * 0.4, 32)
                local abbrev_path = require('helpers').abbrev_path
                vim.w.abbrev_cwd = abbrev_path(vim.fn.getcwd(), width - #scope_label) .. scope_label
            end
            vim.api.nvim_create_autocmd({ 'WinEnter', 'DirChanged', 'VimResized' }, {
                group = vim.api.nvim_create_augroup('lualine-pwd', {}),
                callback = set_abbrev_cwd,
            })
            set_abbrev_cwd()
        end,
    },
    {
        'rcarriga/nvim-notify',
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        config = function()
            vim.notify = require('notify')
        end,
    },
}
