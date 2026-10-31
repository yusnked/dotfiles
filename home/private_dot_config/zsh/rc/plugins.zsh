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

    # Ghostty 利用時に画像プレビューで Kitty Graphics Protocol を使用する.
    # see: ~/.config/fzf/preview.sh
    if [[ "$TERM_PROGRAM" == ghostty ]]; then
        autoload -Uz hook-widget-post
        __delete_kitty_images() { printf '\033_Ga=d,d=A\033\\'; }

        hook-widget-post fzf-completion __delete_kitty_images
        hook-widget-post fzf-file-widget __delete_kitty_images
    fi

    unset -f __plugin_fzf_setup
}
zsh-defer -a __plugin_fzf_setup

# fzf-tab
# 通常の Tab 補完を維持し, メニュー補完から fzf-tab を呼び出せるようにする.
__plugin_fzf_tab_setup() {
    # menuselect キーマップが存在しなければ設定をスキップする.
    bindkey -M menuselect &>/dev/null || return

    local dir
    dir="$(antidote path Aloxaf/fzf-tab)" || return
    [[ -r "$dir/fzf-tab.plugin.zsh" ]] || return

    # シンプルにするため emacs と viins の Tab 割り当てが違う場合を考慮しない.
    local orig_tab="${${$(builtin bindkey '^I')##* }:-expand-or-complete}"

    # 通常補完で使用する zstyle の値を保存する.
    # 未設定の場合は既定値を使用する (未設定状態は復元しない).
    zstyle -s ':completion:*:descriptions' format __plugin_fzf_tab_orig_desc ||
        __plugin_fzf_tab_orig_desc='[%d]'
    zstyle -s ':completion:*' list-grouped __plugin_fzf_tab_orig_list_grouped ||
        __plugin_fzf_tab_orig_list_grouped=true

    source "$dir/fzf-tab.plugin.zsh" || return

    # Tab を復元して fzf-tab-complete の呼び出しキーを設定.
    local trigger='^X^R'
    bindkey -M viins '^I' "$orig_tab" "$trigger" fzf-tab-complete
    bindkey -M emacs '^I' "$orig_tab" "$trigger" fzf-tab-complete

    # ユーザー定義ウィジェットを menuselect で通常通り実行することはサポートされていない.
    # そのため, メニュー補完を抜けて fzf-tab-complete を呼び出すキー入力を送る.
    bindkey -M menuselect '^G' send-break
    bindkey -M menuselect -s '^R' "^G$trigger" '^S' "^G$trigger"

    # fzf-tab は list-grouped を false に設定するので復元する.
    zstyle ':completion:*' list-grouped "$__plugin_fzf_tab_orig_list_grouped"

    # グループごとの色を識別しやすくするために表示される候補先頭の中点を非表示にする.
    zstyle ':fzf-tab:*' prefix ''

    # fzf-tab はデフォルトで FZF_DEFAULT_OPTS を使用しない.
    # {} を含まない --bind='...' から ... を抽出して配列で指定する.
    zstyle ':fzf-tab:*' fzf-bindings \
        ${(@)${${${(M)${(f)FZF_DEFAULT_OPTS}:#*--bind=\'*}:#*\{*\}*}#*--bind=\'}%\'}

    # 通常補完と fzf-tab 補完で zstyle の設定と呼び出す補完関数を切り替える.
    __plugin_fzf_tab_prev=0
    function _main_complete() {
        if (( IN_FZF_TAB )); then
            if ! (( __plugin_fzf_tab_prev )); then
                zstyle ':completion:*' list-grouped false
                zstyle ':completion:*:descriptions' format '[%d]'
            fi
            # 補完関数が失敗しても状態が不整合にならないよう, 呼び出し前に更新する.
            __plugin_fzf_tab_prev=$IN_FZF_TAB
            -ftb-complete "$@"
        else
            if (( __plugin_fzf_tab_prev )); then
                zstyle ':completion:*' list-grouped "$__plugin_fzf_tab_orig_list_grouped"
                zstyle ':completion:*:descriptions' format "$__plugin_fzf_tab_orig_desc"
            fi
            __plugin_fzf_tab_prev=$IN_FZF_TAB
            _ftb__main_complete "$@"
        fi
    }

    unset -f __plugin_fzf_tab_setup
}
