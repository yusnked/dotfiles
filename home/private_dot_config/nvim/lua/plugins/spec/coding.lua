local keydesc = require("plugins.util.keydesc")

return {
    {
        "kylechui/nvim-surround",
        version = "*",
        keys = { "ys", "yss", "yS", "ySS", "cs", "cS", "ds",
            { "<C-g>s", mode = "i" }, { "<C-g>S", mode = "i" },
            { "S", mode = "x", desc = "Add a surrounding pair around a visual selection" },
            { "gS", mode = "x", desc = "Add a surrounding pair around a visual selection, on new lines" },
        },
        opts = {},
    },
    {
        "monaqa/dial.nvim",
        keys = keydesc.lazy {
            { "<C-a>", mode = { "n", "x" }, desc = "Increment (dial)" },
            { "<C-x>", mode = { "n", "x" }, desc = "Decrement (dial)" },
            { "g<C-a>", desc = "Increment additive repeat (dial)" },
            { "g<C-x>", desc = "Decrement additive repeat (dial)" },
            { "g<C-a>", mode = "x", desc = "Increment sequence (dial)" },
            { "g<C-x>", mode = "x", desc = "Decrement sequence (dial)" },
            { "<leader><C-a>", mode = { "n", "x" }, desc = "Toggle case: snake ↔ camel (dial)" },
            { "<leader><C-x>", mode = { "n", "x" }, desc = "Toggle case: snake ↔ kebab (dial)" },
        },
        config = function() require("plugins.config.dial").config() end,
    },
}
