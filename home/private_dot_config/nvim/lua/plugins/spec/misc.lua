return {
    {
        "vim-jp/vimdoc-ja",
        keys = { { "h", mode = "c" } },
    },
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },
}
