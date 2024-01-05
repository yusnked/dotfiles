return {
    {
        'nvim-treesitter/nvim-treesitter',
        version = '*',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'JoosepAlviste/nvim-ts-context-commentstring',
            { 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim', version = '*' }
        },
        -- event = 'FileType',
        build = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
        main = 'nvim-treesitter.configs',
        opts = {
            ensure_installed = 'all',
            sync_install = false,
            auto_install = false,
            highlight = {
                enable = true,
                -- 指定したサイズ以上のファイルのハイライトを無効
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            -- treesitterを用いた=でのインデント整形を有効にする
            indent = { enable = true },

            --[[ incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = 'grn', -- set to `false` to disable one of the mappings
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            }, ]]

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['in'] = '@number.inner',
                        ['agc'] = '@comment.outer',
                        ['igc'] = '@comment.inner',
                        ['agr'] = '@return.outer',
                        ['igr'] = '@return.inner',
                        ['a<C-b>'] = '@block.outer',
                        ['i<C-b>'] = '@block.inner',
                    },
                },
                -- move = {
                --     enable = true,
                --     set_jumps = true, -- whether to set jumps in the jumplist
                --     goto_next_start = {
                --         [']m'] = '@function.outer',
                --         [']c'] = '@codechunk.inner',
                --         [']]'] = '@class.outer',
                --     },
                --     goto_next_end = {
                --         [']M'] = '@function.outer',
                --         [']['] = '@class.outer',
                --     },
                --     goto_previous_start = {
                --         ['[m'] = '@function.outer',
                --         ['[c'] = '@codechunk.inner',
                --         -- ['[['] = '@class.outer',
                --     },
                --     goto_previous_end = {
                --         ['[M'] = '@function.outer',
                --         ['[]'] = '@class.outer',
                --     },
                -- },
            },
        }
    },
}
