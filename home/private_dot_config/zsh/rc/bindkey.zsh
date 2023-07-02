() {
    # zsh-vi-modeを導入しているのでそっちでもキーバインドが追加される。viins以外はそっちに書く。
    bindkey -v
    # viinsモードの[^G]はプレフィクスキーとして使いたいので自身に割り当てられてるものを削除する。
    bindkey -M viins -r '^g'

    # ' " ` ( { [ を入力したときに閉じる記号も入力し、すぐ削除したときに閉じる記号も削除するウィジェット
    autoload -Uz _brackets-and-quotes-expantion _backward-delete-char-or-expantion
    zle -N brackets-and-quotes-expantion _brackets-and-quotes-expantion
    local key
    for key in \' \" \` \( \) \{ \} \[ \]; do
        bindkey -M viins $key brackets-and-quotes-expantion
    done
    zle -N backward-delete-char-or-expantion _backward-delete-char-or-expantion
    bindkey -M viins '^h' backward-delete-char-or-expantion
    bindkey -M viins '^?' backward-delete-char-or-expantion
}

