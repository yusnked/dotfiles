---@module 'blink.cmp'

local M = {}

---@param cmp blink.cmp.API
---@return boolean|nil
local function cmdline_cr(cmp)
    if not cmp.is_menu_visible() then return false end

    local item = cmp.get_selected_item()
    if item == nil then return false end

    -- 選択項目が Dir なら accept() それ以外なら accept_and_enter()
    local text = item.textEdit and item.textEdit.newText or item.label or ''
    if text:sub(-1) == '/' then
        return cmp.accept()
    end

    return cmp.accept_and_enter()
end

---@type blink.cmp.Config
M.opts = {
    keymap = {
        preset = 'enter',
        ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' },
        ['<C-p>'] = { 'show', 'select_prev', 'fallback_to_mappings' },
        ['<C-u>'] = { 'scroll_signature_up', 'fallback' },
        ['<C-d>'] = { 'scroll_signature_down', 'fallback' },
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
            lua = { inherit_defaults = true, 'lazydev' },
        },
        providers = {
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
        },
    },

    completion = {
        menu = {
            auto_show = true,
        },
        trigger = {
            show_on_keyword = true,
            show_on_trigger_character = true,
            show_in_snippet = false,
        },
        list = {
            selection = {
                preselect = false,
                auto_insert = false,
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 300,
        },
    },

    cmdline = {
        keymap = {
            preset = 'cmdline',
            ['<CR>'] = { cmdline_cr, 'fallback' },
        },
        completion = {
            menu = {
                auto_show = true,
            },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = true,
                },
            },
        },
    },

    signature = {
        enabled = true,
    },
}

---@param _ LazyPlugin
---@param opts blink.cmp.Config
function M.config(_, opts)
    -- blink.cmp の cmdline completion と競合する為.
    vim.opt.wildmenu = false

    require('blink.cmp').setup(opts)
end

return M
