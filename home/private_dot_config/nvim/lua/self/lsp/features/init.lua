local M = {}

local specs = require('self.lsp.specs')
local helpers = require('self.lsp.helpers')

---@class self.lsp.Features
---@field format_on_write? boolean

--- グローバルで feature が有効かどうかを表す.
---
--- self.lsp.Spec.features 用の self.lsp.Features を流用するのは
--- 意味論的には正確ではないが, 別に型を定義するメリットも薄いので流用する.
---@type self.lsp.Features
M.status = {
    format_on_write = true,
}

local actions = {
    on = function() return true end,
    off = function() return false end,
    toggle = function(current) return not current end,
}

-- LspAttach イベントが発火するまでこのコマンドは定義されない.
vim.api.nvim_create_user_command('LspFeature', function(opts)
    if #opts.fargs < 2 then
        helpers.notify('No LSP feature specified.', 'ERROR')
        return
    end

    local action = opts.fargs[1]

    local apply = actions[action]
    if apply == nil then
        helpers.notify(('Unknown action: %s'):format(action), 'ERROR')
        return
    end

    for i = 2, #opts.fargs do
        local name = opts.fargs[i]

        if M.status[name] ~= nil then
            M.status[name] = apply(M.status[name])
            helpers.notify(('%s: %s'):format(name, M.status[name] and 'on' or 'off'), 'INFO')
        else
            helpers.notify(('Unknown LSP feature: %s'):format(name), 'ERROR')
        end
    end
end, {
    nargs = '+',
    ---@param arg_lead string 入力位置の単語.
    ---@param cmdline string 入力位置を除くコマンドライン全体.
    complete = function(arg_lead, cmdline)
        local args = vim.split(cmdline, '%s+', { trimempty = true })

        local candidates
        if #args < 2 then
            candidates = vim.tbl_keys(actions)
        else
            candidates = vim.tbl_keys(M.status)
        end

        -- 入力位置の単語で始まる候補だけを返す.
        return vim.iter(candidates)
            :filter(function(candidate) return vim.startswith(candidate, arg_lead) end)
            :totable()
    end,
    desc = 'Control LSP features',
})

---@param client vim.lsp.Client
---@param ctx vim.api.keyset.create_autocmd.callback_args
function M.enable(client, ctx)
    local buf = ctx.buf
    local client_id = client.id
    local client_name = client.name

    local spec = specs[client_name]
    if not (spec and spec.features) then
        return
    end

    local augroup = helpers.get_augroup(buf, client_id, client_name)
    local features = spec.features
    ---@cast features self.lsp.Features

    if features.format_on_write then
        require('self.lsp.features.format_on_write').enable(client, buf, augroup)
    end
end

return M
