source "$XDG_CONFIG_HOME/_b-shell/functions.sh"

function reload() {
    chezmoi apply && sleep 1 && exec zsh
}
