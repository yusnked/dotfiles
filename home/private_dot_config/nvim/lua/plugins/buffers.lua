return {
    {
        'stevearc/oil.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        keys = { { '-', function() require('oil').open() end } },
        cond = NOT_VSCODE,
        opts = {
            git = {
                mv = function(src_path)
                    local result = vim.system({ 'git', 'ls-files', src_path }, { text = true }):wait()
                    return result.stdout ~= ''
                end,
                -- If true is returned, the :wq command will hang up, so call the git command directly.
                rm = function(path)
                    local result = vim.system({ 'git', 'ls-files', path }, { text = true }):wait()
                    if result.stdout ~= '' then
                        vim.system { 'git', 'rm', '-r', '--cached', path }:wait()
                    end
                    return false
                end,
            },
        },
        init = function()
            if vim.fn.isdirectory(vim.api.nvim_buf_get_name(0)) ~= 0 then
                require('oil')
            else
                vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                    callback = function(arg)
                        local file_path = arg.file
                        if file_path ~= '' and vim.fn.isdirectory(file_path) ~= 0 then
                            require('oil')
                            return true
                        end
                    end,
                })
            end
        end,
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        keys = {
            { '<Leader>e', desc = 'Open nvim-tree' },
            { '<Leader>E', desc = 'Close nvim-tree' },
        },
        cond = NOT_VSCODE,
        config = function()
            local api = require('nvim-tree.api')
            local expand_node = function()
                local node = api.tree.get_node_under_cursor()
                if node.nodes ~= nil and #node.nodes == 0 then
                    require('nvim-tree.core').get_explorer():expand(node)
                end
                if node.open == nil or node.open then
                    return
                end
                node.open = true
                require('nvim-tree.renderer').draw()
                if node.nodes ~= nil and #node.nodes > 0 then
                    vim.schedule(function()
                        vim.cmd.normal { 'j', bang = true }
                    end)
                end
            end
            local open_directory = function()
                local node = api.tree.get_node_under_cursor()
                local path = node.absolute_path
                if node.link_to and not node.nodes then
                    path = node.link_to
                end
                if node.fs_stat.type ~= 'directory' then
                    path, _ = path:gsub('/[^/]+$', '')
                    if path == '' then
                        path = '/'
                    end
                end
                require('nvim-tree.actions').node.open_file.fn('edit', path)
            end
            local focus_last_window_node = function()
                local buf = vim.api.nvim_buf_get_name(vim.fn.winbufnr(vim.fn.winnr('#')))
                buf, _ = buf:gsub('^oil://', '')
                api.tree.find_file { buf = buf }
            end
            local on_attach = function(bufnr)
                local opts = function(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, silent = true, nowait = true }
                end
                api.config.mappings.default_on_attach(bufnr)
                local keymap = vim.keymap.set
                keymap('n', 'e', focus_last_window_node, opts('Find Alternate Buffer'))
                keymap('n', 'h', api.node.navigate.parent_close, opts('Collapse Folder'))
                keymap('n', 'l', expand_node, opts('Expand Folder'))
                keymap('n', '<C-h>', api.tree.collapse_all, opts('Collapse All'))
                keymap('n', '<C-o>', open_directory, opts('Open Directory'))

                -- Float preview
                vim.keymap.set('n', 'P', function()
                    require('nvim-tree-preview').watch()
                end, opts('Preview (Watch)'))
                vim.keymap.set('n', '<Esc>', function()
                    require('nvim-tree-preview').unwatch()
                end, opts('Close Preview/Unwatch'))
            end
            local label = function(path)
                path = path:gsub(os.getenv 'HOME', '~', 1)
                return path:gsub('([a-zA-Z])[a-z0-9]+', '%1') ..
                    (path:match('[a-zA-Z]([a-z0-9]*)$') or '')
            end
            require('nvim-tree').setup {
                hijack_netrw = false,
                hijack_cursor = true,
                filters = { git_ignored = false },
                renderer = {
                    root_folder_label = label,
                    group_empty = label,
                    highlight_git = 'name',
                    icons = {
                        glyphs = {
                            git = {
                                unstaged = 'M',
                                staged = '+',
                                unmerged = '!',
                                renamed = 'R',
                                untracked = '?',
                                deleted = 'D',
                                ignored = '',
                            },
                        },
                    },
                },
                actions = {
                    open_file = { window_picker = { chars = 'ASDFGHJKLBCEIMNOPQRTUVWXYZ1234567890' } },
                },
                on_attach = on_attach,
            }
            vim.keymap.set('n', '<Leader>e', '<Cmd>NvimTreeOpen<CR>')
            vim.keymap.set('n', '<Leader>E', '<Cmd>NvimTreeClose<CR>')
        end,
    },
    {
        'b0o/nvim-tree-preview.lua',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
    },
    {
        'akinsho/toggleterm.nvim',
        keys = {
            { '<C-`>', desc = 'Open or focus toggleterm' },
            { '<C-`>', mode = 'x', desc = 'Send selected text to toggleterm' },
        },
        cmd = 'ToggleTerm',
        cond = NOT_VSCODE,
        config = function()
            local term = require('toggleterm')
            term.setup {
                shell = require('self.helpers').get_shell_path(),
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
            end)
            keymap('x', '<C-`>', function()
                local send_lines_to_terminal = term.send_lines_to_terminal
                if vim.api.nvim_get_mode().mode == 'V' then
                    send_lines_to_terminal('visual_lines', true, { args = vim.v.count })
                else
                    send_lines_to_terminal('visual_selection', false, { args = vim.v.count })
                end
            end)
            keymap('t', '<C-`>', '<Cmd>ToggleTerm<CR>', { desc = 'Close toggleterm' })
            keymap('t', '<C-\\><C-\\>', '<Cmd>wincmd 1 w<CR>', { desc = 'Move focus to first window' })
            keymap('t', '<C-\\><C-h>', '<Cmd>wincmd h<CR>', { desc = 'Move focus to left window' })
            keymap('t', '<C-\\><C-j>', '<Cmd>wincmd j<CR>', { desc = 'Move focus to lower window' })
            keymap('t', '<C-\\><C-k>', '<Cmd>wincmd k<CR>', { desc = 'Move focus to upper window' })
            keymap('t', '<C-\\><C-l>', '<Cmd>wincmd l<CR>', { desc = 'Move focus to right window' })
        end,
    },
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        cond = NOT_VSCODE,
    },
    {
        'famiu/bufdelete.nvim',
        cmd = { 'Bdelete', 'Bwipeout' },
        cond = NOT_VSCODE,
        init = function()
            local abbrev = require('self.utils.cmd-auto-expand').create
            abbrev('bd', 'Bdelete')
            abbrev('bw', 'Bwipeout')
        end,
    },
}
