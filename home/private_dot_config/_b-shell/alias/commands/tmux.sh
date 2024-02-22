function tmux-mv() {
    [[ -z $TMUX ]] && return 1

    local -r kill_session="$(tmux display -p '#{session_id}')"
    if [[ $# > 0 ]]; then
        tmux switch-client -t "${1?}:" && tmux kill-session -t "$kill_session"
    else
        local -r sessions="$(tmux ls -f '#{==:#{session_attached},0}' -F '#S')"
        if [[ -z $sessions ]]; then
            echo "No unattached sessions" >&2
            return 1
        fi

        local selected_session
        selected_session="$(echo "$sessions" | fzf)" || return 1
        tmux switch-client -t "${selected_session}:" &&
            tmux kill-session -t "$kill_session"
    fi
}
