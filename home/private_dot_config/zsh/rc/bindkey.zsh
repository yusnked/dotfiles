# This file must be loaded after "zsh-vi-mode" is loaded.

() {
    autoload -Uz bind-widget

    if [[ -n $ZVM_VERSION ]]; then
        local keymap='viins'
        bindkey -v
    else
        local keymap='emacs'
        bindkey -e
    fi

    # ^g keybindings
    bindkey -M $keymap -r '^g'
    bindkey -M $keymap '^gh' run-help
    bindkey -M $keymap '^g^h' run-help

    local key
    for key in \' \" \` \( \) \{ \} \[ \]; do
        bind-widget $keymap $key brackets-and-quotes-expantion
    done
    bind-widget $keymap '^h' backward-delete-char-or-expantion
    bind-widget $keymap '^?' backward-delete-char-or-expantion

}
