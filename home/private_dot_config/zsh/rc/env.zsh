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

# Homebrew.
zsh-defer -a +2 __source_generated_cache "${commands[brew]}" homebrew.zsh 'brew shellenv'
# brew shellenv が FPATH を環境変数に設定するため解除.
zsh-defer -a typeset -g +x FPATH

# PATH の一番上に更新.
zsh-defer -a -c '
    path[1,0]="$HOME/.local/bin"
    fpath=(
        "$ZDOTDIR/functions"
        "$ZDOTDIR/completions"
        $fpath
    )
'
