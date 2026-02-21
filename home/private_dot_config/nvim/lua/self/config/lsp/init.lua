local ft_to_servers = require("self.config.lsp.ft_to_servers")

local did_configure_lsp = false
local function configure_lsp_once()
    if did_configure_lsp then return end
    did_configure_lsp = true

    vim.diagnostic.config { virtual_lines = { current_line = true } }
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("self_config_lsp_enable", {}),
    callback = function(ctx)
        local bufnr = ctx.buf
        local ft = ctx.match

        local servers = ft_to_servers[ft]
        if not servers then return end
        if type(servers) == "string" then
            servers = { servers }
        end

        vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(bufnr) then
                return
            end
            if vim.bo[bufnr].filetype ~= ft then
                return
            end

            local to_install = {}
            local to_enable = {}
            for _, server in ipairs(servers) do
                local lspconfig_name = server:gsub("@.*$", "")
                local cmd = vim.lsp.config[lspconfig_name].cmd[1]
                if vim.fn.executable(cmd) ~= 1 then
                    table.insert(to_install, server)
                elseif not vim.lsp.is_enabled(lspconfig_name) then
                    table.insert(to_enable, lspconfig_name)
                end
            end

            if #to_enable > 0 then
                vim.lsp.enable(to_enable)
            end

            if #to_install > 0 then
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "LspNotInstalled",
                    data = { servers = to_install },
                })
            end
        end, 100)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("self_config_lsp_attach", {}),
    callback = function(ctx)
        local client = assert(vim.lsp.get_client_by_id(ctx.data.client_id))

        configure_lsp_once()

        -- 対応していたら保存する前に format する.
        if not client:supports_method("textDocument/willSaveWaitUntil")
            and client:supports_method("textDocument/formatting") then
            local group_name = "self_config_lsp_format_" .. client.name .. "_" .. tostring(ctx.buf)
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup(group_name, {}),
                buffer = ctx.buf,
                callback = function()
                    vim.lsp.buf.format { bufnr = ctx.buf, id = client.id, timeout_ms = 1000 }
                end,
            })
        end
    end,
})
