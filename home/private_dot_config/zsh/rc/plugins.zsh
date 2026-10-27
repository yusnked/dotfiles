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

# fzf
__plugin_fzf_setup() {
    FZF_CTRL_T_COMMAND='fd --color=always --hidden --no-ignore-vcs'
    FZF_ALT_C_COMMAND='fd --color=always --hidden --no-ignore-vcs --type=d'

    local preview="--preview-window='default,right,60%,~3,<84(down,50%,~3)'"
    FZF_CTRL_R_OPTS="--history='$XDG_DATA_HOME/fzf/history-command' --bind='ctrl-t:ignore'"
    FZF_CTRL_T_OPTS="$preview --ansi"
    FZF_ALT_C_OPTS="$preview --ansi"
    FZF_COMPLETION_OPTS="$preview --ansi"

    __cache_source "$commands[fzf]" 'fzf --zsh'

    # Tab に割り当てられる fzf-completion のパス・ディレクトリ補完に fd を使用する.
    _fzf_compgen_path() { ${(z)FZF_CTRL_T_COMMAND} . "$1"; }
    _fzf_compgen_dir() { ${(z)FZF_ALT_C_COMMAND} . "$1"; }

    autoload -Uz _fzf_complete_git

    unset -f __plugin_fzf_setup
}
zsh-defer -a __plugin_fzf_setup
