function prompt-toggle() {
    local -r file="$DOTS_STATE_HOME/no_starship_prompt"
    if [[ -e $file ]]; then
        rm "$file"
    else
        mkdir -p "$DOTS_STATE_HOME"
        touch "$file"
    fi
    exec "$DOTS_ISHELL"
}

function mkcd() {
    command mkdir -p "$@" && for arg in "$@"; do
        [[ -d "$arg" && -x "$arg" ]] && cd "$arg" && break
    done
}

function cdr() {
    local root_dir
    root_dir="$(git rev-parse --show-toplevel 2>/dev/null || echo "$HOME")"
    local target_dir="${root_dir}${1+/$1}"
    if [[ -d "$target_dir" ]]; then
        builtin cd "$target_dir" || return
    else
        echo "cdr: no such directory: $target_dir" >&2
        return 1
    fi
}
