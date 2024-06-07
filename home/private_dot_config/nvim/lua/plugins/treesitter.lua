return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = function()
            require('nvim-treesitter.install').update { with_sync = true }
        end,
        init = function()
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                callback = function()
                    require('self.helpers').exec_autocmds_by_group_pattern('^NvimTreesitter', { 'FileType' })
                end,
                once = true,
            })
        end,
        main = 'nvim-treesitter.configs',
        opts = {
            ensure_installed = {
                'awk',
                'bash',
                'c',
                -- 'comment', -- https://github.com/neovim/neovim/issues/22426
                'cpp',
                'css',
                'csv',
                'diff',
                'dockerfile',
                'embedded_template',
                'git_config',
                'git_rebase',
                'gitattributes',
                'gitcommit',
                'gitignore',
                'go',
                'gpg',
                'html',
                'http',
                'ini',
                'javascript',
                'jq',
                'json',
                'json5',
                'jsonc',
                'lua',
                'make',
                'markdown',
                'markdown_inline',
                'nix',
                'passwd',
                'python',
                'regex',
                'ruby',
                'rust',
                'scss',
                'sql',
                'styled',
                'terraform',
                'toml',
                'tsv',
                'typescript',
                'vim',
                'vimdoc',
                'xml',
                'yaml',
            },
            sync_install = false,
            auto_install = false,

            highlight = {
                enable = NOT_VSCODE,
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = NOT_VSCODE },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['agb'] = '@block.outer',
                        ['igb'] = '@block.inner',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        [']m'] = '@function.outer',
                    },
                    goto_next_end = {
                        [']M'] = '@function.outer',
                    },
                    goto_previous_start = {
                        ['[m'] = '@function.outer',
                    },
                    goto_previous_end = {
                        ['[M'] = '@function.outer',
                    },
                },
            },
            matchup = { enable = true },
        },
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        event = { 'VeryLazy' },
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        opts = { max_lines = 2 },
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
            require('ts_context_commentstring').setup { enable_autocmd = false }
        end,
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        cond = NOT_VSCODE,
    },
    {
        'windwp/nvim-ts-autotag',
        event = { 'InsertEnter *.html,*.jsx,*.tsx,*.xml' },
        cond = NOT_VSCODE,
        config = function()
            require('nvim-ts-autotag').setup {
                filetypes = { 'html', 'javascriptreact', 'typescriptreact', 'xml' },
            }
            require('self.helpers').exec_autocmds_filetype { group = 'nvim_ts_xmltag' }
        end,
    },
    {
        'Wansmer/treesj',
        keys = { { 'J', desc = 'TSJToggle or normal! J' } },
        opts = { use_default_keymaps = false },
        config = function()
            local treesj = require('treesj')
            treesj.setup { use_default_keymaps = false }

            local set_buf_keymap = function()
                local langs = require('treesj.langs').configured_langs
                for _, lang in ipairs(langs) do
                    if vim.bo.filetype == lang then
                        vim.keymap.set('n', 'J', treesj.toggle, {
                            buffer = true,
                            desc = 'Toggle between joining and splitting by Tree-sitter',
                        })
                        return
                    end
                end
                vim.keymap.set('n', 'J', 'J', { buffer = true, desc = 'Join lines' })
            end
            vim.api.nvim_create_autocmd({ 'FileType' }, {
                group = vim.api.nvim_create_augroup('treesj-keymap', {}),
                callback = set_buf_keymap,
            })
            set_buf_keymap()
        end,
    },
}
