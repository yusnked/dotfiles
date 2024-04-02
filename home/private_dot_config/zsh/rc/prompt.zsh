source "$DOTS_SHELLS_DIR/prompt.sh"

if [[ $COLORTERM == truecolor && ! -e "$XDG_STATE_HOME/no_starship_prompt" ]] &&
    type starship &>/dev/null; then
    # Starship
    _configure_starship_once
else
    # Something like bash's PROMPT_DIRTRIM.
    __prompt_dirtrim() {
        [[ $PWD == $__prompt_dirtrim_prevpwd ]] && return 0
        local tilde len="${PROMPT_DIRTRIM:-3}"
        tilde="$(print -P '%-1~')/"
        _prompt_dirtrim_var="$(print -P "%($((len + 2))c|${tilde##/*/}.../|%($((len + 1))c|${tilde/\/*\//...\/}|))%$len~")"
        __prompt_dirtrim_prevpwd="$PWD"
    }
    precmd_functions+=(__prompt_dirtrim)

    PROMPT_DIRTRIM=3
    PROMPT='%B%F{yello}%n@%m%f%b:%F{green}${_prompt_dirtrim_var}%f <<git-prompt>>
%B%(?|%F{040}|%F{197})%(2L|%L|)%#%f%b '
    _configure_gitprompt_once
fi

RPROMPT='$_prompt_pipestatus_var'
