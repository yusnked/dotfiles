local opt = vim.opt

opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.fileencodings = 'ucs-bom,utf-8,iso-2022-jp,cp932,euc-jp,default,latin'

opt.title = false
opt.mouse = 'a'

opt.termguicolors = true

opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.signcolumn = 'yes'
opt.scrolloff = 3
opt.laststatus = 3
opt.shortmess:append('I')

opt.list = true
opt.listchars:append('eol:↴,space:⋅')

opt.ambiwidth = 'single'

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 0
opt.softtabstop = -1

opt.ignorecase = true
opt.smartcase = true

opt.grepprg = 'rg -S.g"!.git/**" --vimgrep $* >/dev/null'
opt.grepformat = '%f:%l:%c:%m'
