local treesitter = require("plugins.config.treesitter")

return {
    {
        "nvim-treesitter/nvim-treesitter",
        cmd = { "TSUpdate" },
        build = ":TSUpdate",
        init = treesitter.init,
        config = treesitter.config,
    },
}
