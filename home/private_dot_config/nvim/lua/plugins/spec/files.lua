local fyler_config = require("plugins.config.fyler")

return {
    {
        "A7Lavinraj/fyler.nvim",
        branch = "stable",
        dependencies = { "nvim-mini/mini.icons" },
        keys = fyler_config.keys,
        cmd = "Fyler",
        main = "fyler",
        init = fyler_config.init,
        config = fyler_config.config,
    },
}
