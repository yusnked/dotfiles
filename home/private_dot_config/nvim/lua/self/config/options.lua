-- vim.opt がどの型を受け付けるのか調べるには下記コマンドを実行する.
-- =vim.api.nvim_get_option_info2('{option_name}', {})
local opt = vim.opt

opt.fileencodings = { 'ucs-bom', 'utf-8', 'cp932', 'default', 'latin1' }

opt.confirm = true
opt.mouse = 'a'
opt.shortmess:append('aI')

opt.title = true
opt.titlestring = '%t%( %M%)'

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = 'number'
opt.signcolumn = 'yes'

opt.list = true -- 不可視文字を表示.
opt.listchars = {
    'eol:↴',
    'extends:…',
    'nbsp:+',
    'precedes:…',
    'space:⋅',
    'tab:> ',
    'trail:-',
}
opt.ambiwidth = 'single'

opt.scrolloff = 3
opt.sidescrolloff = 3
opt.wrap = false
opt.virtualedit = 'block' -- Visual blockで仮想空白を許可.

opt.expandtab = true
opt.tabstop = 8      -- Tab文字の表示幅. 互換性の為8固定推奨(らしい)
opt.shiftwidth = 4
opt.softtabstop = -1 -- 負の数指定でshiftwidthの値を使用.

opt.splitbelow = true
opt.splitright = true

opt.diffopt = {
    'internal',
    'filler',
    'closeoff',
    'indent-heuristic',
    'algorithm:histogram',
    'inline:word',
    'linematch:60',
}

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = 'split'
if vim.fn.executable('rg') == 1 then
    opt.grepprg = "rg --vimgrep --smart-case --hidden --no-messages --glob '!.git/*'"
    opt.grepformat = '%f:%l:%c:%m'
end

opt.jumpoptions = { 'clean', 'stack', 'view' }

opt.wildmode = { 'longest:full', 'full' }
opt.wildignorecase = true
opt.wildignore:append {
    '*/.git/*',
    '*/node_modules/*',
    '*/__pycache__/*',
    '*.swp',
    '*.swo',
    '*.tmp',
    '*.bak',
    '*.orig',
}
opt.wildoptions:append('fuzzy')

opt.completeopt = { 'menuone', 'noselect', 'popup', 'fuzzy' }
opt.pumheight = 15
opt.pumwidth = 20
opt.pummaxwidth = 60
opt.pumblend = 10

-- : cmdline, / search, @ input-line 履歴の保存件数は省略で &history.
opt.shada = {
    '!',      -- 大文字のみのグローバル変数を保存 (g:FOO_BAR)
    "'1000",  -- 最近編集した最大 N ファイルについてマークを保存.
    '<500',   -- N 行より長いレジスタを保存しない.
    's50',    -- 内容が N KiB より大きい ShaDa 項目を保存しない.
    'h',      -- ShaDa 読み込み時に 'hlsearch' の効果を復元しない.
    'r/tmp/', -- このパス以下のファイルについてマークを保存しない.
    'r/private/',
}
opt.undofile = true  -- 永続 Undo.

opt.timeoutlen = 800 -- マッピングの待ち時間.
opt.updatetime = 1000

opt.helplang = 'ja'
