source "$XDG_CONFIG_HOME/_b-shell/prompt.sh"

if [[ $COLORTERM == truecolor && ! -e "$XDG_STATE_HOME/no_starship_prompt" ]] &&
    type starship &>/dev/null; then
    # Starship
    _configure_starship_once
else
    # git
    autoload -Uz vcs_info
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
    zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
    zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
    zstyle ':vcs_info:*' actionformats '[%b|%a]'
    precmd() { vcs_info; }

    autoload -Uz _prompt-truncated-path

    PROMPT='
%B%F{yello}%n@%m%f%b:$(_prompt-truncated-path 50 2 3) %F{cyan}$vcs_info_msg_0_%f
%B%(?|%F{040}|%F{197})%#%f%b '
fi

RPROMPT='$_prompt_pipestatus_var'
