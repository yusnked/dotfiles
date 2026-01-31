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
}
