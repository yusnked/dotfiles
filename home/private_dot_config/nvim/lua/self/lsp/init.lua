local enable_augroup = vim.api.nvim_create_augroup('self.lsp.enable', {})

vim.api.nvim_create_autocmd('FileType', {
    group = enable_augroup,
    once = true,
    callback = function(initial_ctx)
        local enable = require('self.lsp.enable')
        local helpers = require('self.lsp.helpers')

        local lsp_specs = require('self.lsp.specs')
        local ft_to_lsp_names = helpers.index_by_filetype(lsp_specs)

        vim.schedule(function()
            local buf = initial_ctx.buf
            local filetype = initial_ctx.match

            if ft_to_lsp_names[filetype]
                and helpers.should_enable(buf, filetype) then
                enable.for_filetype(filetype, lsp_specs, ft_to_lsp_names)
            end
        end)

        vim.api.nvim_create_autocmd('FileType', {
            group = enable_augroup,
            pattern = vim.tbl_keys(ft_to_lsp_names),
            callback = function(ctx)
                vim.schedule(function()
                    local buf = ctx.buf
                    local filetype = ctx.match

                    if helpers.should_enable(buf, filetype) then
                        enable.for_filetype(filetype, lsp_specs, ft_to_lsp_names)
                    end
                end)
            end,
        })
    end,
})

local config_loaded = false

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('self.lsp.attach', {}),
    callback = function(ctx)
        if not config_loaded then
            require('self.lsp.config')
            config_loaded = true
        end

        local client = vim.lsp.get_client_by_id(ctx.data.client_id)
        if client then
            require('self.lsp.features').enable(client, ctx)
        end
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('self.lsp.detach', {}),
    callback = function(ctx)
        -- バッファを削除したり lsp stop や restart したときに LspDetach が発生してるので,
        -- autocmd 重複登録の心配はなさそう.
        require('self.lsp.helpers').del_augroup(ctx.buf, ctx.data.client_id)
    end,
})
