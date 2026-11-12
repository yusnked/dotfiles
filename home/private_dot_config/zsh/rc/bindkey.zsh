# emacs の ESC で始まるキーバインドを指定したプレフィックスに移植する.
__bindkey_import_emacs_meta() {
    emulate -L zsh

    local prefix="$1" keymap="${2:-main}" line
    local -a keylist

    # ${1:-^[} にしないのはエディタのハイライトが壊れるため.
    [[ -z "$prefix" ]] && prefix='^['

    # main のエイリアスを解決し, 実際のキーマップ名を取得する.
    if [[ "$keymap" == main ]]; then
        # bindkey -lL main の出力例: bindkey -A viins main
        keymap=${$(bindkey -lL main)[3]}
    fi

    [[ "$keymap" == emacs && "$prefix" == '^[' ]] && return

    # 改行で分割し, ^[[ と ^[O で始まるキーシーケンスを除外する.
    for line in "${(@)${(f)$(bindkey -pM emacs '^[')}:#\"\^\[[[O]*}"; do
        # キー表記のクォートを外して ESC を置換し, ウィジェット名と対にする.
        # 例: '"^[A" accept-and-hold' -> "${prefix}A" "accept-and-hold"
        keylist+=("$prefix${${(Q)${line%% *}}#\^\[}" "${line#* }")
    done

    (( $#keylist )) || return 0

    bindkey -M "$keymap" "${keylist[@]}"
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
    __bindkey_import_emacs_meta
    __bindkey_register_widgets

    autoload -Uz \
        edit-command-line \
        expand-absolute-path \
        select-word-style

    zle -N edit-command-line
    zle -N expand-absolute-path

    # シェル構文を考慮して単語削除・移動する.
    select-word-style shell

    bindkey \
        '^H'   backward-delete-char \
        '^I'   complete-word \
        '^Q'   meta-prefix \
        '^V'   vi-quoted-insert \
        '^Xh'  _complete_help \
        '^XH'  _complete_params \
        '^X^A' expand-absolute-path \
        '^X^E' edit-command-line \
        '^X*'  expand-word \
        '^X?'  _complete_debug \
        '^[q'  push-line-or-edit \
        '^[Q'  push-line-or-edit \
        '^[^Q' push-line-or-edit \
        '^[^V' quoted-insert

    bindkey -s '^J' '^[^V^J'

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
            '^[g' beginning-of-history \
            '^[j' vi-forward-blank-word \
            '^[k' vi-backward-blank-word \
            '^[n' vi-forward-blank-word \
            '^[p' vi-backward-blank-word \
            '^[G' end-of-history \
            '/'   accept-and-infer-next-history

        # Shift+Tab で補完候補を逆順に選択.
        if [[ -n "$terminfo[kcbt]" ]]; then
            bindkey "$terminfo[kcbt]" reverse-menu-complete
        fi
    fi

    # Ghostty
    if [[ "$TERM_PROGRAM" == ghostty ]]; then
        bindkey \
            '^[e'  ghostty-screen-edit \
            '^[^E' ghostty-screen-edit
    fi
}
