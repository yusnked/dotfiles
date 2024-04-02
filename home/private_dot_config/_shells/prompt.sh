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
    if [[ ! $cache_file -nt $STARSHIP_CONFIG ]] || ! source "$cache_file" 2>/dev/null; then
        mkdir -p "$STARSHIP_CACHE"
        starship init $shell_type --print-full-init >"$cache_file"

        sed -i "/^\s*#/d;/^$/d" "$cache_file"
        if [[ -n $ZSH_VERSION ]]; then
            # Display named directories in zsh.
            sed -i "/^R\?PROMPT=/s/)'$/ --logical-path \"\${(%):-%~}\"&/" "$cache_file"
        fi

        printf '\033[32mINFO\033[39m: Re-cache starship source file: %s\n' "$cache_file" >&2
        source "$cache_file"
    fi

    # Unset self.
    unset -f _configure_starship_once
}

# The order in which the following functions are hooked is important!
# In bash, Bash-Preexec is required to run the following hooks.
# https://github.com/rcaloras/bash-preexec

# Make something like zsh's PROMPT_SP available in bash as well.
# Note that the display may be corrupted if the terminal is not VT220 compatible.
if [[ -n $BASH_VERSION ]]; then
    _prompt_sp_executing=0
    function __prompt_sp_precmd() {
        if [[ $_prompt_sp_executing != 0 ]]; then
            local POS
            IFS='[;' read -r -s -d R -p $'\033[6n' -a POS
            [[ ${POS[2]} -gt 1 ]] && printf '\033[1;7m%%\033[m\n'
        fi
        _prompt_sp_executing=0
    }
    function __prompt_sp_preexec() {
        _prompt_sp_executing=1
    }
    precmd_functions+=(__prompt_sp_precmd)
    preexec_functions+=(__prompt_sp_preexec)
fi

# Decoration pipestatus
function __prompt_pipestatus() {
    local PEL PER FMTL FMTR RETVAR
    local -a inputted_codes
    while [[ $# -gt 0 ]]; do
        case $1 in
        -f)
            local -r FMTL="${2%%\{\}*}"
            local -r FMTR="${2#*\{\}}"
            shift 2
            ;;
        -v)
            local -r RETVAR="$2"
            shift 2
            ;;
        -e)
            local -r PEL="${2% *}"
            local -r PER="${2#* }"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            inputted_codes+=("$1")
            shift
            ;;
        esac
    done
    inputted_codes+=("$@")

    local -rA BEGIN_COLOR=(
        [success]="$PEL"$'\033[38;5;70m'"$PER"
        [error]="$PEL"$'\033[38;5;124m'"$PER"
        [signal]="$PEL"$'\033[38;5;136m'"$PER"
        [default]="$PEL"$'\033[38;5;247m'"$PER"
    )
    local -r END_COLOR="$PEL"$'\033[39m'"$PER"

    local status_codes status_code state
    for status_code in "${inputted_codes[@]}"; do
        if [[ $status_code -ge 129 && $status_code -le 159 ]]; then
            # shellcheck disable=SC2154
            status_codes+=" ${BEGIN_COLOR[signal]}${signals[$((status_code - 127))]}"
        else
            if [[ $status_code -eq 0 ]]; then
                state=success
            else
                state=error
            fi
            status_codes+=" ${BEGIN_COLOR[$state]}$status_code"
        fi
    done
    # shellcheck disable=SC2154
    status_codes="${BEGIN_COLOR[default]}${FMTL}${status_codes# }${BEGIN_COLOR[default]}${FMTR}${END_COLOR}"
    if [[ -n $RETVAR ]]; then
        printf -v "$RETVAR" '%s' "$status_codes"
    else
        printf '%s\n' "$status_codes"
    fi
}
if [[ -n $ZSH_VERSION ]]; then # zsh
    function __prompt_pipestatus_precmd() {
        _prompt_pipestatus_ret=$?
        if [[ $_prompt_pipestatus_executing == 1 ]]; then
            local copied_pipestatus=("${pipestatus[@]}")
            [[ ${#copied_pipestatus[@]} -eq 1 ]] && copied_pipestatus=("$_prompt_pipestatus_ret")
            __prompt_pipestatus -f '[{}]' -e '%{ %}' -v _prompt_pipestatus_var -- "${copied_pipestatus[@]}"
        else
            _prompt_pipestatus_var=''
        fi
        _prompt_pipestatus_executing=''
    }
elif [[ -n $BASH_VERSION ]]; then # bash with bash-preexec
    # shellcheck disable=SC2207
    signals=('' EXIT $(kill -l {129..159}))

    function __prompt_pipestatus_precmd() {
        if [[ $_prompt_pipestatus_executing == 1 ]]; then
            # shellcheck disable=SC2154
            if [[ $__bp_last_ret_value -ge 129 && ${signals[$((__bp_last_ret_value - 127))]} =~ ^(STOP|TSTP)$ ]]; then
                __prompt_pipestatus -f '[pipestatus: {}]' -- "$__bp_last_ret_value"
            else
                __prompt_pipestatus -f '[pipestatus: {}]' -- "${BP_PIPESTATUS[@]}"
            fi
        fi
        _prompt_pipestatus_executing=''
    }
fi
function __prompt_pipestatus_preexec() {
    _prompt_pipestatus_executing=1
}
precmd_functions+=(__prompt_pipestatus_precmd)
preexec_functions+=(__prompt_pipestatus_preexec)

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
        # shellcheck disable=SC2025
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
precmd_functions+=(__prompt_osc133_precmd)
preexec_functions+=(__prompt_osc133_preexec)
