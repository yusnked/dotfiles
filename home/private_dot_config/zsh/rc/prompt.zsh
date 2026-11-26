# Named directories
hash -d dots="$XDG_DATA_HOME/chezmoi"
hash -d dots-config=~dots/home/private_dot_config

autoload -Uz promptinit _terminal_title

# プロンプトテーマシステムを有効にする.
promptinit

# OSC 2 による CWD / 実行コマンドのタイトル設定を有効にする.
_terminal_title enable

if [[ "$FPATH" == *powerlevel10k* ]]; then
    prompt powerlevel10k
    if [[ -r "$ZDOTDIR/.p10k.zsh" ]]; then
        source "$ZDOTDIR/.p10k.zsh"
    else
        p10k configure
    fi

    # git のマークを消す.
    typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
    typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_EXPANSION=
else
    prompt dots_fallback
fi
