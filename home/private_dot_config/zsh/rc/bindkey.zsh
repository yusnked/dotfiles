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
    local meta='^Q'
    __bindkey_import_emacs_meta "$meta"
    __bindkey_register_widgets

    bindkey \
        '^H'        backward-delete-char \
        '^V'        vi-quoted-insert \
        '^X*'       expand-word \
        "${meta}Q"  push-line-or-edit \
        "${meta}q"  push-line-or-edit \
        "${meta}^Q" push-line-or-edit \
        "${meta}^V" quoted-insert

    bindkey -s '^J' "${meta}^V^J"

    # ESC でキャンセルできるようにする.
    bindkey -M command '^[' send-break
    bindkey -M isearch '^[' send-break

    # メニュー補完.
    if bindkey -M menuselect &>/dev/null; then
        # menuselect に未登録のキーは現在のキーマップにフォールバックする.
        # menuselect では一部のウィジェットが通常とは異なる動作になる.
        #
        # up-history                            1 行上に移動.
        # down-history                          1 行下に移動.
        # backward-word                         1 画面上に移動.
        # forward-word                          1 画面下に移動.
        # beginning-of-history                  先頭行に移動.
        # end-of-history                        最終行に移動.
        # vi-backward-blank-word                前の補完グループの最終行に移動.
        # vi-forward-blank-word                 次の補完グループの先頭行に移動.
        # vi-insert                             インタラクティブモードに切り替え.
        # history-incremental-search-backward   補完候補を後方検索.
        # history-incremental-search-forward    補完候補を前方検索.
        # accept-and-hold                       補完メニューを閉じずに候補を確定.
        # accept-and-infer-next-history         候補を確定して次の補完を開始.
        bindkey -M menuselect \
            '^D'  forward-word \
            '^G'  send-break \
            '^H'  undo \
            '^J'  down-history \
            '^K'  up-history \
            '^O'  accept-and-hold \
            '^R'  history-incremental-search-backward \
            '^S'  history-incremental-search-forward \
            '^U'  backward-word \
            '^V'  vi-insert \
            '^?'  undo \
            '^['  send-break \
            '^[G' end-of-history \
            '^[g' beginning-of-history \
            '^[j' vi-forward-blank-word \
            '^[k' vi-backward-blank-word \
            '^[n' vi-forward-blank-word \
            '^[p' vi-backward-blank-word \
            '/'   accept-and-infer-next-history

        # Shift+Tab で補完候補を逆順に選択.
        if [[ -n "$terminfo[kcbt]" ]]; then
            bindkey "$terminfo[kcbt]" reverse-menu-complete
        fi
    fi

    # Ghostty
    if [[ "$TERM_PROGRAM" == ghostty ]]; then
        bindkey \
            "${meta}e"  ghostty-screen-edit \
            "${meta}^E" ghostty-screen-edit
    fi
}
