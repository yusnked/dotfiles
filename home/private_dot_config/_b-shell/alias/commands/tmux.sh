function tmux() {
    if [[ $# == 0 ]]; then
        command tmux new "$DOTS_ISHELL" -l
    else
        command tmux "$@"
    fi
}
