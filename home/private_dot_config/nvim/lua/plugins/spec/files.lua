local keydesc = require("plugins.util.keydesc")

return {
    {
        "A7Lavinraj/fyler.nvim",
        branch = "stable",
        dependencies = { "nvim-mini/mini.icons" },
        keys = keydesc.lazy {
            { "<leader>e", desc = "Open/Focus left-most (fyler)" },
            { "<leader>E", desc = "Close left-most (fyler)" },
        },
        cmd = "Fyler",
        config = function() require("plugins.config.fyler").config() end,
    },
}
