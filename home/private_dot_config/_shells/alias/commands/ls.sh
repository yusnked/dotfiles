if ! type eza &>/dev/null; then
    if ls --version &>/dev/null; then
        # gnu-ls
        alias ls="ls --color=auto --time-style='+%Y-%m-%d %H:%M'"
    else
        # bsd-ls
        alias ls="ls -GD '%Y-%m-%d %H:%M'"
    fi
    alias la='ls -A'
    alias ll='ls -lh'
    alias li='ll -i'
    alias lla='ll -A'
    alias lai='lla -i'
fi
