---@diagnostic disable: undefined-global
return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            indent = {},
            notifier = {},
            picker = {},
        },
        keys = {
            { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
            { "<leader>N", function() Snacks.picker.notifications() end, desc = "Notification History" },
            { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
            { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
            { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>;", function() Snacks.picker() end, desc = "Snacks all pickers" },
        },
        init = function()
            do -- :bd をウィンドウレイアウトを崩さない :Bd に置き換え.
                local function resolve_buf(arg)
                    local bufnr = tonumber(arg)
                    if bufnr then return bufnr end

                    local path = vim.fs.abspath(vim.fn.expand(arg))
                    bufnr = vim.fn.bufnr(path)
                    if bufnr ~= -1 then return bufnr end

                    return nil
                end

                vim.api.nvim_create_user_command("Bd", function(opts)
                    if #opts.fargs == 0 then
                        Snacks.bufdelete()
                        return
                    end

                    for _, arg in ipairs(opts.fargs) do
                        local bufnr = resolve_buf(arg)
                        if bufnr then
                            Snacks.bufdelete(bufnr)
                        end
                    end
                end, { nargs = "*", complete = "buffer" })
                vim.cmd([[
                    cnoreabbrev <expr> bd ((getcmdtype() == ':' && getcmdline() == 'bd') ? 'Bd' : 'bd')
                ]])
            end
        end,
    },
}
