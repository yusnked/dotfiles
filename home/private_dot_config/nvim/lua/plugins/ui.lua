return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        lazy = false,
        cond = NOT_VSCODE,
        opts = {
            options = { globalstatus = true },
            sections = {
                lualine_b = { 'branch' },
                lualine_c = { { 'filename', path = 1 } },
                lualine_x = {
                    { 'encoding', cond = function() return vim.bo.fileencoding ~= 'utf-8' end },
                    { 'fileformat', cond = function() return vim.bo.fileformat ~= 'unix' end },
                    'bo:filetype',
                },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {
                lualine_a = { { 'tabs', use_mode_colors = true, symbols = { modified = '' } } },
            },
            extensions = {
                'fugitive',
                'lazy',
                'quickfix',
                'toggleterm',
            },
        },
    },
    {
        'b0o/incline.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lualine/lualine.nvim' },
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        config = function()
            -- Get mode color of lualine.
            local set_incline_colors = function()
                local mode_suffix = require('lualine.highlight').get_mode_suffix()
                local hl = vim.api.nvim_get_hl(0, { name = 'lualine_a' .. mode_suffix })
                vim.g.incline_fg = vim.fn.printf('#%06x', hl.fg)
                vim.g.incline_bg = vim.fn.printf('#%06x', hl.bg)
            end
            vim.api.nvim_create_autocmd({ 'ModeChanged', 'FocusGained' }, {
                pattern = '*',
                group = vim.api.nvim_create_augroup('incline-setcolors', {}),
                callback = set_incline_colors,
            })
            vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
                pattern = '*',
                callback = function()
                    set_incline_colors()
                    vim.cmd('redraws')
                end,
            })

            local helpers = require('incline.helpers')
            local devicons = require('nvim-web-devicons')
            require('incline').setup {
                window = {
                    padding = 0,
                    margin = { horizontal = 0, vertical = 0 },
                    overlap = { tabline = true },
                },
                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                    local ft_icon, ft_color = devicons.get_icon_color(filename)
                    filename = vim.fn.fnamemodify(filename, ':r')
                    if filename == '' then
                        filename = '[No Name]'
                    end
                    local modified = vim.bo[props.buf].modified
                    return {
                        ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or
                        '',
                        ' ',
                        { props.buf .. '.' .. filename, gui = modified and 'bold,italic' or 'bold', guifg = vim.g.incline_fg },
                        ' ',
                        guibg = props.focused and vim.g.incline_bg or '#808080',
                    }
                end,
            }
            set_incline_colors()
        end,
    },
    {
        'akinsho/toggleterm.nvim',
        keys = { { '<C-`>', mode = { 'n', 'x', 't' } } },
        cmd = 'ToggleTerm',
        cond = NOT_VSCODE,
        config = function()
            local term = require('toggleterm')
            term.setup {
                shell = require('helpers').get_shell_path(),
                on_open = function(t)
                    if t.__state.mode == 'n' then
                        vim.api.nvim_input('i')
                    end
                end,
            }

            local keymap = vim.keymap.set
            keymap('n', '<C-`>', function()
                local terminal = require('toggleterm.terminal')
                local toggled_id = terminal.get_toggled_id()
                local focused_id = terminal.get_focused_id()
                if not toggled_id then
                    term.toggle(vim.v.count)
                    return
                end
                local toggled_winnr = vim.fn.bufwinnr(terminal.get(toggled_id).bufnr)
                if not focused_id and toggled_winnr ~= -1 then
                    vim.cmd.wincmd(toggled_winnr .. ' w')
                else
                    term.toggle(vim.v.count)
                end
            end, { desc = 'ToggleTerm open or focus' })
            keymap('x', '<C-`>', function()
                local send_lines_to_terminal = term.send_lines_to_terminal
                if vim.api.nvim_get_mode().mode == 'V' then
                    send_lines_to_terminal('visual_lines', true, { args = vim.v.count })
                else
                    send_lines_to_terminal('visual_selection', false, { args = vim.v.count })
                end
            end, { desc = 'ToggleTermSendVisual' })
            keymap('t', '<C-`>', '<Cmd>ToggleTerm<CR>', { desc = 'ToggleTerm close' })
            keymap('t', '<C-\\><C-\\>', '<Cmd>wincmd 1 w<CR>')
            keymap('t', '<C-\\><C-h>', '<Cmd>wincmd h<CR>')
            keymap('t', '<C-\\><C-j>', '<Cmd>wincmd j<CR>')
            keymap('t', '<C-\\><C-k>', '<Cmd>wincmd k<CR>')
            keymap('t', '<C-\\><C-l>', '<Cmd>wincmd l<CR>')
        end,
    },
    {
        'petertriho/nvim-scrollbar',
        event = { 'BufRead', 'InsertEnter' },
        cond = NOT_VSCODE,
        opts = {},
    },
}
