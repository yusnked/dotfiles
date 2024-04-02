# Create and attach a session for each terminal.
function tmuxs() {
    [[ -n $TMUX ]] && return 0

    local -r TERM_NAME="${DOTS_TERMINAL:-unknown}"

    local target_session

    if ! tmux has 2>/dev/null; then
        target_session="${TERM_NAME}-0"
        tmux new -ds "$target_session"
    fi

    local -r session_filter_pattern="#{m|r:^${TERM_NAME}-[1-9]?[0-9]$,#S}"

    if [[ -z $target_session ]]; then
        # If there are detached sessions, target the session with the lowest number.
        local detach_session
        detach_session="$(tmux ls \
            -f "#{&&:$session_filter_pattern,#{==:#{session_attached},0}}" \
            -F '#S')"

        if [[ -n $detach_session ]]; then
            detach_session="${detach_session//$TERM_NAME-/}"
            detach_session="$(printf '%s' "$detach_session" | sort -n)"

            target_session="${TERM_NAME}-${detach_session%%$'\n'*}"
        fi
    fi

    if [[ -z $target_session ]]; then
        local exists_session_list
        exists_session_list="$(tmux ls -f "$session_filter_pattern" -F '#S')"
        local i new_session_name
        for i in {0..99}; do
            new_session_name="${TERM_NAME}-$i"
            if [[ ! $exists_session_list =~ $new_session_name ]]; then
                target_session="$new_session_name"
                tmux new -ds "$target_session"
                break
            fi
        done
    fi

    if [[ -n "$target_session" ]]; then
        if [[ $1 =~ ^(-e|--exec)$ ]]; then
            exec tmux attach -t "$target_session"
        else
            tmux attach -t "$target_session"
        fi
    else
        return 1
    fi
}

function tmux-mv() {
    [[ -z $TMUX ]] && return 1

    local -r kill_session="$(tmux display -p '#{session_id}')"
    if [[ $# -gt 0 ]]; then
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
