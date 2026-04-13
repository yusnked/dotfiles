return {
    {
        "neovim/nvim-lspconfig",
        -- TODO: v0.12で LspStart -> lsp enable のように変更されるので設定を更新する.
        cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
        init = function(plugin)
            vim.opt.runtimepath:append(plugin.dir)
        end,
    },
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        main = "mason",
        opts = { PATH = "skip" },
        init = function()
            vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

            vim.api.nvim_create_autocmd("User", {
                group = vim.api.nvim_create_augroup("plugins_lsp_server_install", {}),
                pattern = "LspNotInstalled",
                callback = function(ctx)
                    require("plugins.config.mason").request_install(ctx.data.servers)
                end,
            })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                "lazy.nvim",
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },
}
