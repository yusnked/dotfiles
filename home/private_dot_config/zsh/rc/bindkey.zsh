__bindkey_copy_emacs_esc_bindings_to_viins_ctrl_q() {
    local line
    local -a keylist
    bindkey -pM emacs '^[' | while IFS= read -r line; do
        # 矢印キー系 (^[[, ^[O) のバインドは除外.
        [[ "$line" == \"\^\[[O[]* ]] && continue
        keylist+=( "^Q${${(Q)${line%% *}}#\^\[}" "${line#* }" )
    done
    if (( $#keylist )); then
        bindkey -M viins "${keylist[@]}"
        bindkey -M viins -r '^Q'
    fi
}

__bindkey_setup() {
    local keymap="${1:-viins}"
    if [[ "$keymap" == viins ]]; then
        bindkey -M $keymap \
            '^H'   backward-delete-char \
            '^Q^Q' push-line \
            '^X*'  expand-word

        zsh-defer -a __bindkey_copy_emacs_esc_bindings_to_viins_ctrl_q
    elif [[ "$keymap" == emacs ]]; then
        bindkey -e
    fi

    bindkey -M command '^[' send-break
    bindkey -M isearch '^[' send-break

    if bindkey -M menuselect &>/dev/null; then
        bindkey -M menuselect \
            '^J' accept-and-infer-next-history \
            '^[' send-break
    fi
}

# =========================================================
# zsh-vi-mode
# =========================================================
if [[ -n "$ZVM_VERSION" ]]; then
    zvm_after_init_commands+=(__bindkey_setup)
else
    # zsh-vi-mode がロードされてなければフォールバック.
    zsh-defer -a -c '__bindkey_setup emacs'
fi
