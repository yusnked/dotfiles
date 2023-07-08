local options = {
    -- Vim内部で使用される文字コード
    encoding = 'utf-8',
    -- 新規作成ファイルの文字コード
    fileencoding = 'utf-8',
    -- file読み込み時に使用される文字コード
    fileencodings = 'ucs-bom,utf-8,iso-2022-jp,cp932,euc-jp,default,latin',
    -- 一部の2幅の文字が1幅で表示され見切れる問題を回避
    ambiwidth = 'single',
    -- ターミナルのウィンドウタイトルに現在のファイル名を表示
    title = false,
    -- mouseを全モードで利用
    mouse = 'a',
    -- 無名レジスタの代わりに+レジスタを使う。X-windowsの規定値 "autoselect,exclude:cons\llinux"の
    -- excludeより右に要素を追加できないので先頭に追加する
    -- clipboard = "unnamedplus" .. vim.o.clipboard,

    -- 行番号設定
    number = true,
    relativenumber = true,
    numberwidth = 4,

    expandtab = true,
    -- 自動インデントや << コマンドなどでずれる幅
    shiftwidth = 4,
    -- <Tab>や<BS>を打ち込んだときにカーソルが動く幅
    softtabstop = 4,
    -- 画面上でタブ文字が占める幅の設定
    tabstop = 4,

    ignorecase = true,
    smartcase = true,

    -- カーソル行の前後何行かを常に表示
    scrolloff = 3,

    -- gitのステータスなどを表示する行を表示
    signcolumn = 'yes',
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.list = true
vim.opt.listchars:append 'space:⋅'

