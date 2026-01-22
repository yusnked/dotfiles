return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        init = function()
            vim.opt.laststatus = 0
        end,
        config = function()
            require("plugins.config.lualine").setup()
        end,
    },
    {
        "folke/which-key.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        keys = {
            { "<leader>?", function() require("which-key").show() end, mode = { "n", "x" }, desc = "Show Keymaps (which-key)" },
        },
        opts = {
            delay = function(ctx)
                return ctx.plugin and 0 or 500
            end,
        },
    },
}
