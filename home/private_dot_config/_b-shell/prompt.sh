function _starship-settings() {
    if [[ -n $ZSH_VERSION ]]; then
        local shell_type='zsh'
    elif [[ -n $BASH_VERSION ]]; then
        local shell_type='bash'
    else
        return 1
    fi

    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
    export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
    local cache_file="$STARSHIP_CACHE/${shell_type}-prompt.sh"
    if [[ ! -r $cache_file || $STARSHIP_CONFIG -nt $cache_file ]]; then
        mkdir -p "$STARSHIP_CACHE"
        starship init $shell_type >"$cache_file"
        source "$cache_file"
    else
        # Recache if problems occur in the cache
        source "$cache_file" 2>/dev/null || starship init $shell_type >"$cache_file" &&
            source "$cache_file"
    fi
}
_starship-settings
unset -f _starship-settings
