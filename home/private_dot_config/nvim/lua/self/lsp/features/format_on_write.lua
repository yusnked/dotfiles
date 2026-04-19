local M = {}

local autocmd_register = require('self.lsp.autocmd').register
local specs_by_name = require('self.lsp.registry').specs_by_name

---@return boolean
local function is_globally_enabled()
    return vim.g.LSP_FORMAT_ON_WRITE_ENABLED ~= 0
end

local function notify_status()
    local enabled = is_globally_enabled()
    vim.notify(
        enabled and 'Format on write is enabled.' or 'Format on write is disabled.',
        vim.log.levels.INFO,
        { title = 'self.lsp' }
    )
end

vim.api.nvim_create_user_command('LspFormatOnWrite', function(opts)
    local arg = opts.fargs[1]

    if arg == nil or arg == 'status' then
        notify_status()
        return
    end

    if arg == 'on' then
        vim.g.LSP_FORMAT_ON_WRITE_ENABLED = 1
        notify_status()
        return
    end

    if arg == 'off' then
        vim.g.LSP_FORMAT_ON_WRITE_ENABLED = 0
        notify_status()
        return
    end

    if arg == 'toggle' then
        vim.g.LSP_FORMAT_ON_WRITE_ENABLED =
            is_globally_enabled() and 0 or 1
        notify_status()
        return
    end

    vim.notify(
        ('Invalid argument: %s.'):format(arg),
        vim.log.levels.ERROR,
        { title = 'self.lsp' }
    )
end, {
    nargs = '?',
    complete = function()
        return { 'on', 'off', 'toggle', 'status' }
    end,
    desc = 'Control global LSP format on write',
})

---@param client vim.lsp.Client
---@param ctx vim.api.keyset.create_autocmd.callback_args
function M.enable(client, ctx)
    local spec = specs_by_name[client.name]
    if spec
        and spec.format_on_write
        and not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
        local group_name = 'self_lsp_format_' .. client.name .. '_b' .. tostring(ctx.buf)
        autocmd_register(ctx.buf, client.id, 'BufWritePre', {
            group = vim.api.nvim_create_augroup(group_name, {}),
            buffer = ctx.buf,
            callback = function()
                if is_globally_enabled() then
                    vim.lsp.buf.format { bufnr = ctx.buf, id = client.id, timeout_ms = 1000 }
                end
            end,
        })
    end
end

return M
