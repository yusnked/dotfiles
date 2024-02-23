function _configure_starship_once() {
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
        # Recache if problems occur in the cache.
        source "$cache_file" 2>/dev/null || starship init $shell_type >"$cache_file" &&
            source "$cache_file"
    fi

    # Unset self.
    unset -f _configure_starship_once
}

# OSC 133
# https://gitlab.freedesktop.org/Per_Bothner/specifications/blob/master/proposals/semantic-prompts.md
_prompt_osc133_executing=''
function __prompt_osc133_precmd() {
    local ret="$?"

    if [[ -n $ZSH_VERSION ]]; then
        local -r PEL='%{'
        local -r PER='%}'
    else
        local -r PEL='\['
        local -r PER='\]'
    fi

    if [[ $_prompt_osc133_executing != 0 ]]; then
        _PROMPT_SAVE_PS1="$PS1"
        _PROMPT_SAVE_PS2="$PS2"
        PS1=$PEL$'\e]133;P;k=i\a'$PER$PS1$PEL$'\e]133;B\a\e]122;> \a'$PER
        PS2=$PEL$'\e]133;P;k=s\a'$PER$PS2$PEL$'\e]133;B\a'$PER
    fi
    if [[ -n $_prompt_osc133_executing ]]; then
        printf '\033]133;D;%s;aid=%s\007' "$ret" "$$"
    fi
    printf '\033]133;A;cl=m;aid=%s\007' "$$"
    _prompt_osc133_executing=0
}

function __prompt_osc133_preexec() {
    PS1="$_PROMPT_SAVE_PS1"
    PS2="$_PROMPT_SAVE_PS2"
    printf '\033]133;C;\007'
    _prompt_osc133_executing=1
}

# Use Bash-Preexec to run this in Bash.
# https://github.com/rcaloras/bash-preexec
preexec_functions+=(__prompt_osc133_preexec)
precmd_functions+=(__prompt_osc133_precmd)
