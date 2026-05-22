# zsh-vi-mode 設定関数. 自動で呼び出される.
zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

() {
    local antidote_git="$XDG_DATA_HOME/zsh/antidote"
    if [[ ! -d "$antidote_git" ]]; then
        git clone --depth=1 https://github.com/mattmc3/antidote "$antidote_git" || return 1
    fi

    fpath[1,0]="$XDG_DATA_HOME/zsh/antidote/functions"
    autoload -Uz antidote

    local antidote_cnf="$ZDOTDIR/antidote.txt"
    __source_generated_cache "$antidote_cnf" antidote.zsh "antidote bundle < ${(q)antidote_cnf}"
}
