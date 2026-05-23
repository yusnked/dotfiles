# Named directories.
hash -d dots="$HOME/.local/share/chezmoi"
hash -d dots-config=~dots/home/private_dot_config

# Prompt.
autoload -Uz promptinit && promptinit

if [[ "$FPATH" == *powerlevel10k* ]]; then
    prompt powerlevel10k
    if [[ -r "$ZDOTDIR/.p10k.zsh" ]]; then
        source "$ZDOTDIR/.p10k.zsh"
    else
        p10k configure
    fi

    # git のマークを消す.
    typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
    typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_EXPANSION=
else
    prompt dots_fallback
fi
