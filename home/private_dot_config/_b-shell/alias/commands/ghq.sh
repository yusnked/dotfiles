function ghq-cd() {
    local repo="$(ghq list | fzf)"
    if [[ -n $repo ]]; then
        builtin cd "$(ghq root)/$repo"
    else
        return 1
    fi
}

function ghq-home() {
    local repo="$(ghq list | fzf)"
    if [[ -n $repo ]]; then
        xdg-open "https:/$repo" 2>/dev/null
    else
        return 1
    fi
}
