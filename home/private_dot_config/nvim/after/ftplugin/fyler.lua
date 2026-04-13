local bufnr = vim.api.nvim_get_current_buf()
local root_dir = require('fyler.views.finder')._current.dir

-- WIP: fyler auto tcd
vim.b._fyler_prev_cwd = vim.uv.cwd()
vim.cmd.tcd(root_dir)
require('self.modules.statusline.abbrev_cwd').refresh()

vim.api.nvim_create_autocmd('BufHidden', {
    buffer = bufnr,
    callback = function()
        vim.cmd.tcd(vim.b._fyler_prev_cwd)
        require('self.modules.statusline.abbrev_cwd').refresh()
    end,
})

do -- デフォルトキーを無効化する.
    local keys = { 'q', '<C-t>', '|', '^', '=', '.', '#' }
    local opts = { buffer = bufnr }
    local del = vim.keymap.del
    for _, lhs in ipairs(keys) do
        del('n', lhs, opts)
    end
end

do -- which-key.nvim
    local wk = {
        { 'gx', desc = 'Open system' },
        { '-', desc = 'Goto parent' },
        { '_', desc = 'Goto CWD' },
        { '<C-g>', desc = 'Goto node' },
        { '<CR>', desc = 'Select' },
        { '<BS>', desc = 'Collapse all' },
        { '<localleader>c', desc = 'cd to fyler root' },
        { '<localleader>l', desc = 'lcd to fyler root' },
        { '<localleader>t', desc = 'tcd to fyler root' },
    }
    for i = 1, #wk do
        wk[i].buffer = bufnr
    end
    require('which-key').add(wk)
end
