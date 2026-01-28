local schedule = require("plugins.util.verylazy_load").schedule

local function is_real_file()
    if vim.bo.buftype ~= "" then return false end
    return vim.api.nvim_buf_get_name(0) ~= ""
end

return {
    {
        "lewis6991/gitsigns.nvim",
        cmd = "Gitsigns",
        main = "gitsigns",
        init = function(plugin)
            schedule(plugin.name, function()
                if is_real_file() then
                    return 100
                else
                    return { "BufReadPre", "BufNewFile" }
                end
            end)
        end,
        config = function(plugin)
            require(plugin.main).setup {
                on_attach = require("plugins.config.gitsigns").on_attach,
            }
        end,
    },
}
