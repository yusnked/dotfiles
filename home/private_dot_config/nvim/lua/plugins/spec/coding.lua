local keydesc = require("plugins.util.keydesc")

return {
    {
        "kylechui/nvim-surround",
        version = "*",
        keys = {
            { "ys", desc = "Add a surrounding pair around a motion (normal mode)" },
            { "yss", desc = "Add a surrounding pair around the current line (normal mode)" },
            { "cs", desc = "Change a surrounding pair" },
            { "ds", desc = "Delete a surrounding pair" },
            { "<leader>S", mode = "x", desc = "Add a surrounding pair around a visual selection" },
        },
        opts = {
            keymaps = {
                insert = false,
                insert_line = false,
                normal_line = false,
                normal_cur_line = false,
                visual = "<leader>S",
                visual_line = false,
                change_line = false,
            },
            move_cursor = "sticky",
        },
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
    {
        "gbprod/substitute.nvim",
        keys = keydesc.lazy {
            { "<leader>s", desc = "Substitute (operator)" },
            { "<leader>ss", desc = "Substitute line" },
            { "<leader>S", desc = "Substitute to EOL" },
            { "<leader>s", mode = "x", desc = "Substitute selection" },
            { "<leader>sx", desc = "Exchange (operator)" },
            { "<leader>sxx", desc = "Exchange line" },
            { "X", mode = "x", desc = "Exchange selection" },
        },
        config = function() require("plugins.config.substitute").config() end,
    },
    {
        "folke/flash.nvim",
        keys = function(plugin)
            local m = plugin.main
            local a = { actions = { S = "next", s = "prev" } }
            return {
                { "s", mode = { "n", "x", "o" }, function() require(m).jump() end, desc = "Flash" },
                { "S", mode = { "n", "x", "o" }, function() require(m).treesitter(a) end, desc = "Flash Treesitter" },
                { "r", mode = "o", function() require(m).remote() end, desc = "Remote Flash" },
            }
        end,
        main = "flash",
        opts = {
            modes = { char = { enabled = false } },
            prompt = { prefix = { { "󱐋", "FlashPromptIcon" } } },
        },
    },
}
