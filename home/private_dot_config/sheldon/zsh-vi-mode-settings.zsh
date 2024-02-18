function zvm_config() {
    [[ $TERM == wezterm ]] && ZVM_TERM='xterm-256color'
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_LAZY_KEYBINDINGS=true
}

# 遅延キーバインド有効時, normalとvisualモードへのbindはこの関数内でする.
function zvm_after_lazy_keybindings() {
    bindkey -M vicmd '^r' redo

    autoload -Uz bind-widget
    bind-widget vicmd 'q' push-line-or-edit-and-enter-insert-mode
}

# zsh-vi-modeがモード変更したときに実行される関数.
# function zvm_after_select_vi_mode() {
#
# }
