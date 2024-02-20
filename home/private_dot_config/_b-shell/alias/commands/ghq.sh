function ghq-cd() {
    builtin cd "$(ghq root)/$(ghq list | fzf)"
}

function ghq-home() {
    open "https:/$(ghq list | fzf)"
}
