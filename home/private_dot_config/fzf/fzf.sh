# fzf configuration for bash or zsh only.
export FZF_DEFAULT_COMMAND='fd --color always --unrestricted -E .git -E .Trash-1000 -E .DS_Store'
export FZF_DEFAULT_OPTS='
    --ansi
    --cycle
    --exact
    --multi
    --no-unicode
    --preview="\"$XDG_CONFIG_HOME/fzf/preview.sh\" {}"
    --preview-window="up,hidden,~3"
    --bind="ctrl-d:preview-half-page-down"
    --bind="ctrl-o:execute-silent(xdg-open {})"
    --bind="ctrl-q:become(\"$XDG_CONFIG_HOME/fzf/cd.sh\" {})"
    --bind="ctrl-t:toggle-preview"
    --bind="ctrl-u:preview-half-page-up"
    --bind="ctrl-v:become($EDITOR {+})"
    --bind="ctrl-y:execute-silent(\"$XDG_CONFIG_HOME/fzf/pbcopy.sh\" \"{+}\")"
'
FZF_DEFAULT_OPTS="--history=\"$XDG_DATA_HOME/fzf/history\" $FZF_DEFAULT_OPTS"

if [[ -n $ZSH_VERSION ]]; then
    source "$NIX_DATA_DIR/fzf/completion.zsh"
    source "$NIX_DATA_DIR/fzf/key-bindings.zsh"
    bindkey -M main -r '^T'
    bindkey -M main -r '^[c'
elif [[ -n $BASH_VERSION ]]; then
    source "$NIX_DATA_DIR/fzf/completion.bash"
    source "$NIX_DATA_DIR/fzf/key-bindings.bash"
fi

