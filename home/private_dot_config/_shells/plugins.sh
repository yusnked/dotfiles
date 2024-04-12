if type sheldon &>/dev/null; then
    function _sheldon-settings() {
        if [[ -n $ZSH_VERSION ]]; then
            local shell_type='zsh'
        elif [[ -n $BASH_VERSION ]]; then
            local shell_type='bash'
        else
            return 1
        fi

        export SHELDON_CONFIG_DIR="$DOTS_CONFIG_HOME/sheldon"
        export SHELDON_CONFIG_FILE="$SHELDON_CONFIG_DIR/plugins.toml"
        local cache_dir="$DOTS_CACHE_HOME/sheldon"
        local cache_file="$cache_dir/${shell_type}-plugins.sh"
        if [[ ! -r $cache_file || $SHELDON_CONFIG_FILE -nt $cache_file ]]; then
            mkdir -p "$cache_dir"
            sheldon --profile $shell_type source >"$cache_file"
        fi
        source "$cache_file"
    }
    _sheldon-settings
    unset -f _sheldon-settings
fi
