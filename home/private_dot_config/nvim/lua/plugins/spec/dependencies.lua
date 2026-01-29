return {
    {
        "nvim-mini/mini.icons",
        config = function(plugin)
            local icons = require(plugin.name)
            icons.setup {}
            icons.mock_nvim_web_devicons()
        end,
    },
    { "nvim-lua/plenary.nvim" },
}
