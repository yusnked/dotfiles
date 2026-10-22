# zsh-vi-mode
# 自動的に呼び出される設定関数.
zvm_config() {
    # Insert モードから始める.
    ZVM_LINE_INIT_MODE="$ZVM_MODE_INSERT"
}
# 初期化後にバインドキーの設定を呼び出す.
zvm_after_init_commands+=(__bindkey_setup)

# Antidote
() {
    local repo_dir="$XDG_DATA_HOME/zsh/antidote"
    if [[ ! -d "$repo_dir" ]]; then
        git clone --depth=1 https://github.com/mattmc3/antidote "$repo_dir" || return
    fi

    # Antidote の関数ディレクトリを自作関数ディレクトリの直後に追加する (なければ先頭).
    local idx=${fpath[(i)$ZDOTDIR/widgets]}
    (( idx <= $#fpath )) || idx=0
    fpath[idx+1,idx]=("$XDG_DATA_HOME/zsh/antidote/functions")

    autoload -Uz antidote

    local config="$ZDOTDIR/antidote.txt"
    __cache_source "$config" "antidote bundle < ${(q)config}"
}

# zsh-vi-mode がロードされていなければ emacs キーバインドにフォールバックする.
if [[ -z "$ZVM_VERSION" ]]; then
    bindkey -e
    zsh-defer -a __bindkey_setup
fi
