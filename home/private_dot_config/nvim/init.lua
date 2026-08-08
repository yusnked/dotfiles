vim.loader.enable()

require('self.config')

-- root ならオプションを安全側に倒してこれ以降の設定を読み込まない.
if require('self.env').is_root then
    local opt = vim.opt
    opt.secure = true
    opt.modeline = false
    opt.exrc = false
    opt.swapfile = false
    opt.undofile = false
    opt.shadafile = 'NONE'
    return
end

-- TODO: vscode-neovim / neovide 向けの設定分岐を実装する.
-- 現時点では基本設定のみ読み込み, LSP やプラグインは読み込まない.
local is_neovide = vim.g.neovide
local is_vscode = vim.g.vscode == 1
if is_neovide or is_vscode then
    return
end

require('self.lsp')

require('self.lazy')
