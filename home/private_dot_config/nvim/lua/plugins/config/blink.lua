---@module 'blink.cmp'

local M = {}

---@return integer[]
local function get_listed_normal_bufs()
    return vim.iter(vim.api.nvim_list_bufs())
        :filter(function(buf)
            return vim.api.nvim_buf_is_loaded(buf)
                and vim.bo[buf].buftype == ''
                and vim.bo[buf].buflisted
        end)
        :totable()
end

---@param cmp blink.cmp.API
---@return boolean?
local function cmdline_enter(cmp)
    if not cmp.is_menu_visible() then return false end

    local item = cmp.get_selected_item()
    if item == nil then return false end

    -- 選択項目がディレクトリなら確定するだけで, コマンドの実行はしない.
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
        ['<C-b>'] = { 'scroll_signature_up', 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_signature_down', 'scroll_documentation_down', 'fallback' },
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
            lua = { inherit_defaults = true, 'lazydev' },
        },
        providers = {
            buffer = {
                opts = {
                    get_bufnrs = get_listed_normal_bufs,
                    max_total_buffer_size = 1024 * 1024, -- 1MiB
                },
            },
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
        },
    },

    completion = {
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
            ['<CR>'] = { cmdline_enter, 'fallback' },
            -- auto_show と相性が悪くコマンドライン履歴が使いにくくなるため無効化.
            -- 項目の選択は <Tab> / <S-Tab> に一本化する.
            ['<C-n>'] = { 'fallback_to_mappings' },
            ['<C-p>'] = { 'fallback_to_mappings' },
        },
        completion = {
            menu = {
                auto_show = true,
            },
            list = {
                selection = {
                    preselect = false,
                },
            },
        },
    },

    signature = {
        enabled = true,
    },
}

return M
