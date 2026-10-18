if (( $+commands[nvim] )); then
    export EDITOR=nvim
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
else
    if (( $+commands[vim] )); then
        export EDITOR=vim
    else
        export EDITOR=vi
    fi
    export MANPAGER="${MANPAGER:-less}"
fi
export VISUAL="$EDITOR"

export LESS='-FRX'
# less の履歴ファイルをホームディレクトリに作らない.
export LESSHISTFILE='-'

export GPG_TTY="$TTY"

# go-runewidth 系ツールで曖昧幅文字を半角として扱う.
export RUNEWIDTH_EASTASIAN=0

# zoxide のデータベースが保存されるディレクトリ. 存在しなくても自動で作成される.
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"

# vivid (LS_COLORS)
() {
    [[ "$COLORTERM" != truecolor ]] && local no_tc='--color-mode 8-bit '
    __cache_source "$commands[vivid]" "vivid ${no_tc-}generate tokyonight-night" LS_COLORS
}
