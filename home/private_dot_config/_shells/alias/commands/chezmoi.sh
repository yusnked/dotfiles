alias chezmoi-reset-once='chezmoi state delete-bucket --bucket=scriptState'

function chezmoi-reinit() {
    local init_file
    init_file="$(chezmoi execute-template '{{ .chezmoi.configFile }}')"
    if [[ -f $init_file ]]; then
        rm "$init_file" && chezmoi init
    else
        return 1
    fi
}

function chezmoi-reload() {
    chezmoi apply && sleep 0.5 && exec "$DOTS_ISHELL"
}

# Chezmoi toggle source-path <-> target-path
function chezmoi-toggle() {
    local dir
    dir="$(chezmoi target-path "$PWD" 2>/dev/null || chezmoi source-path "$PWD" 2>/dev/null)"
    if [[ -z $dir ]]; then
        if [[ $PWD == "$HOME" ]]; then
            builtin cd "$(chezmoi source-path)" || return
        else
            return 1
        fi
    fi
    builtin cd "$dir" || return
}
