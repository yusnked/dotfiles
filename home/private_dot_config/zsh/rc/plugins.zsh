# zsh-vi-mode 設定関数. 自動で呼び出される.
zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

() {
    local antidote_git="$XDG_DATA_HOME/zsh/antidote"
    if [[ ! -d "$antidote_git" ]]; then
        git clone --depth=1 https://github.com/mattmc3/antidote "$antidote_git" || return 1
    fi

    # Antidote の関数ディレクトリを自前の関数の直後に追加 (なければ先頭).
    local fpath_idx=${fpath[(i)$ZDOTDIR/completions]}
    (( fpath_idx <= $#fpath )) || fpath_idx=0
    fpath[fpath_idx+1,fpath_idx]=("$XDG_DATA_HOME/zsh/antidote/functions")

    autoload -Uz antidote

    local antidote_cnf="$ZDOTDIR/antidote.txt"
    __cache_source "$antidote_cnf" "antidote bundle < ${(q)antidote_cnf}"
}
