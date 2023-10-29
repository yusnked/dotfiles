return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        event = 'VeryLazy',
        cond = NOT_VSCODE,
        config = function()
            require('lualine').setup({
                options = {
                    globalstatus = true,
                },
                sections = {
                    lualine_c = {
                        {
                            'filename',
                            path = 1,
                        }
                    }
                },

                tabline = {
                    lualine_a = {
                        {
                            'buffers',
                            show_filename_only = true,
                            hide_filename_extension = true,
                            show_modified_status = true,

                            mode = 2,

                            max_length = vim.o.columns,
                            -- it can also be a function that returns
                            -- the value of `max_length` dynamically.
                            filetype_names = {
                                TelescopePrompt = 'Telescope',
                                lazy = 'Lazy',
                            }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

                            -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
                            use_mode_colors = false,
                        }
                    },
                },
            })

            vim.api.nvim_create_user_command(
                'B',
                function(opts)
                    local buffers_len = #require('helpers').get_listed_buffers()
                    local buffer_idx = tonumber(opts.fargs[1])
                    if buffer_idx > buffers_len then
                        buffer_idx = buffers_len
                    else
                        if buffer_idx < 1 then
                            buffer_idx = 1
                        end
                    end
                    vim.api.nvim_command('LualineBuffersJump' .. ' ' .. buffer_idx)
                end,
                { nargs = 1, desc = 'LualineBuffersJump abbreviated command' }
            )
        end,
    },
}

