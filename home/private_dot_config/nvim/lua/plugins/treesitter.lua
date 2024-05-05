return {
    {
        'nvim-treesitter/nvim-treesitter',
        version = '*',
        event = NOT_VSCODE and { 'VeryLazy' } or { 'FileType' },
        build = function()
            require('nvim-treesitter.install').update { with_sync = true }
        end,
        main = 'nvim-treesitter.configs',
        opts = {
            ensure_installed = {
                'awk',
                'bash',
                'c',
                -- 'comment', -- SLOW
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
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
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
                        ['in'] = '@number.inner',
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
        -- Wait for this to be fixed: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/513
        commit = '73e44f43c70289c70195b5e7bc6a077ceffddda4',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = NOT_VSCODE and { 'VeryLazy' } or { 'FileType' },
        config = function()
            if NOT_VSCODE and vim.bo.filetype ~= '' then
                vim.defer_fn(function()
                    vim.cmd.edit()
                end, 200)
            end
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        opts = {},
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
            require('ts_context_commentstring').setup { enable_autocmd = false }
        end,
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        cond = NOT_VSCODE,
        config = function()
            vim.g.rainbow_delimiters = {
                highlight = {
                    'RainbowRed',
                    'RainbowYellow',
                    'RainbowBlue',
                    'RainbowOrange',
                    'RainbowGreen',
                    'RainbowViolet',
                    'RainbowCyan',
                },
            }
        end,
    },
    {
        'windwp/nvim-ts-autotag',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { 'VeryLazy' },
        cond = NOT_VSCODE,
        opts = { filetypes = { 'html', 'javascriptreact', 'typescriptreact', 'xml' } },
    },
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        keys = { { 'J', function() require('treesj').toggle() end, { desc = 'TSJToggle' } } },
        opts = { use_default_keymaps = false },
    },
}
