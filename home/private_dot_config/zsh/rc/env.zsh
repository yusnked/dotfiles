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

# fzf
# fzf が古いプレビューを中断する性質を利用し, sleep で疑似 debounce する.
export FZF_DEFAULT_OPTS="--cycle --multi --with-shell='bash -c'
    --history='$XDG_DATA_HOME/fzf/history'
    --preview='sleep 0.1; \"$XDG_CONFIG_HOME/fzf/preview.sh\" {}'
    --preview-window='right,60%,hidden,~3,<84(up,50%,hidden,~3)'
    --bind='ctrl-d:half-page-down,ctrl-u:half-page-up'
    --bind='ctrl-n:down-match,ctrl-p:up-match'
    --bind='ctrl-o:execute-silent(test $DOTS_OS = Darwin && open {} || xdg-open {})'
    --bind='ctrl-r:toggle-sort'
    --bind='ctrl-t:toggle-preview'
    --bind='ctrl-y:execute-silent(command -v cbcopy >/dev/null && cbcopy < {+f})'
    --bind='ctrl-/:toggle-wrap-word,alt-/:toggle-preview-wrap-word'
    --bind='alt-c:transform(test -e {} && printf \"become(%q %s)\" \"$XDG_CONFIG_HOME/fzf/cd.sh\" \{})'
    --bind='alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind='alt-n:next-history,alt-p:prev-history'
    --bind='alt-r:toggle-raw'
"

# zoxide のデータベース保存先. ディレクトリは存在しなければ自動作成される.
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"

# vivid (LS_COLORS)
() {
    [[ "$COLORTERM" != truecolor ]] && local no_tc='--color-mode 8-bit '
    __cache_source "$commands[vivid]" "vivid ${no_tc-}generate tokyonight-night" LS_COLORS
}
