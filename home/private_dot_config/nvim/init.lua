vim.loader.enable()

require('self.source_vimrc')

-- TODO: vscode-neovim / neovide 向けの設定分岐を実装する.
-- 現時点では未対応環境で本体設定を読み込まず, 最低限起動のみ保証する.
local is_neovide = vim.g.neovide
local is_vscode = vim.g.vscode == 1
if is_neovide or is_vscode then
    return
end

require('self.lsp')

require('self.lazy')
