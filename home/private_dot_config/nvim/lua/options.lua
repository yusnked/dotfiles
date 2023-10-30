local options = {
    encoding = 'utf-8',
    fileencoding = 'utf-8',
    fileencodings = 'ucs-bom,utf-8,iso-2022-jp,cp932,euc-jp,default,latin',

    title = false,
    mouse = 'a',
    -- 無名レジスタの代わりに+レジスタを使う。X-windowsの規定値 "autoselect,exclude:cons\llinux"の
    -- excludeより右に要素を追加できないので先頭に追加する
    -- clipboard = "unnamedplus" .. vim.o.clipboard,

    termguicolors = true,

    number = true,
    relativenumber = true,
    numberwidth = 4,
    signcolumn = 'yes',
    scrolloff = 3,
    laststatus = 3, -- Global Status Line

    ambiwidth = 'single',

    expandtab = true,
    tabstop = 4,
    shiftwidth = 0,
    softtabstop = -1,

    ignorecase = true,
    smartcase = true,
}

local vsoptions = {
    isprint = '1-255'
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

if not NOT_VSCODE then
    for k, v in pairs(vsoptions) do
        vim.opt[k] = v
    end
end
