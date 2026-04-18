local did_configure_lsp = false
local function configure_lsp_once()
    if did_configure_lsp then return end
    did_configure_lsp = true

    require('self.lsp.config')
end

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('self_lsp_enable', {}),
    callback = function(ctx)
        require('self.lsp.enable').run(ctx)
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('self_lsp_attach', {}),
    callback = function(ctx)
        configure_lsp_once()
        require('self.lsp.attach').run(ctx)
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('self_lsp_detach', {}),
    callback = function(ctx)
        require('self.lsp.autocmd').clear(ctx.buf, ctx.data.client_id)
    end,
})
