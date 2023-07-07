if ! which zoxide &> /dev/null; then
    return 0
fi

export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"

if [[ -n $ZSH_VERSION ]]; then
    eval "$(zoxide init zsh --hook pwd)"
elif [[ -n $BASH_VERSION ]]; then
    eval "$(zoxide init bash --hook pwd)"
fi

