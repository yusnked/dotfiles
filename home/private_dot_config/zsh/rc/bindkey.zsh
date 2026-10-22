# emacs の ESC で始まるキーバインドを指定したプレフィックスに移植する.
__bindkey_import_emacs_meta() {
    emulate -L zsh

    local prefix="$1" keymap="${2:-main}" line
    local -a keylist

    [[ -n "$prefix" ]] || return

    # 改行で分割し, ^[[ と ^[O で始まるキーシーケンスを除外する.
    for line in "${(@)${(f)$(bindkey -pM emacs '^[')}:#\"\^\[[[O]*}"; do
        # キー表記のクォートを外して ESC を置換し, ウィジェット名と対にする.
        # 例: '"^[A" accept-and-hold' -> "${prefix}A" "accept-and-hold"
        keylist+=("$prefix${${(Q)${line%% *}}#\^\[}" "${line#* }")
    done

    if (( $#keylist )); then
        bindkey -M $keymap "${keylist[@]}"
        bindkey -M $keymap -r $prefix
    fi
}

__bindkey_register_widgets() {
    emulate -L zsh

    local widgets=("$ZDOTDIR"/widgets/*(N.:t)) widget
    (( $#widgets )) || return 0

    autoload -Uz "${widgets[@]}"
    for widget in "${widgets[@]}"; do
        zle -N "$widget"
    done
}

__bindkey_setup() {
    __bindkey_import_emacs_meta '^Q'
    __bindkey_register_widgets

    bindkey \
        '^H'   backward-delete-char \
        '^Q^Q' push-line \
        '^X*'  expand-word

    # ESC でキャンセルできるようにする.
    bindkey -M command '^[' send-break
    bindkey -M isearch '^[' send-break

    # メニュー補完.
    if bindkey -M menuselect &>/dev/null; then
        bindkey -M menuselect \
            '^J' accept-and-infer-next-history \
            '^[' send-break
    fi

    # Ghostty
    if [[ "$TERM_PROGRAM" == ghostty ]]; then
        bindkey \
            '^Qe'  ghostty-screen-edit \
            '^Q^E' ghostty-screen-edit
    fi
}
