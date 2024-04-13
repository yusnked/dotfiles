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

# fzf (NEED: export RUNEWIDTH_EASTASIAN=0)
export FZF_DEFAULT_COMMAND='fd --color always --unrestricted -E .git -E .DS_Store -E ".Trash-*"'
export FZF_DEFAULT_OPTS="--ansi --cycle --exact --multi
    --preview='\"$DOTS_CONFIG_HOME/fzf/preview.sh\" {}'
    --preview-window='up,hidden,~3'
    --history='$DOTS_DATA_HOME/fzf/history'
    --bind='ctrl-d:preview-half-page-down'
    --bind='ctrl-l:transform([[ -e {} ]] && echo \"become(\\\"$DOTS_CONFIG_HOME/fzf/cd.sh\\\" {})\")'
    --bind='ctrl-o:transform([[ -e {} ]] && echo \"execute-silent(xdg-open {} 2>/dev/null)\")'
    --bind='ctrl-t:toggle-preview'
    --bind='ctrl-u:preview-half-page-up'
    --bind='ctrl-v:transform(testall -f {+} && testall -r {+} && echo \"become($EDITOR {+})\")'
    --bind='ctrl-y:execute-silent(\"$DOTS_CONFIG_HOME/fzf/pbcopy.sh\" \"{+}\")'
"
