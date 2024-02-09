alias chezmoi-reset-once='chezmoi state delete-bucket --bucket=scriptState'

function chezmoi-reload() {
    chezmoi apply && sleep 0.5 && exec "$DOTS_ISHELL"
}

# Chezmoi toggle source-path <-> target-path
function chezmoi-toggle() {
    local dir="$(chezmoi target-path "$PWD" 2>/dev/null || chezmoi source-path "$PWD" 2>/dev/null)"
    if [[ -z $dir ]]; then
        if [[ $PWD == $HOME ]]; then
            builtin cd "$(chezmoi source-path)"
        else
            return 1
        fi
    fi
    builtin cd "$dir"
}
