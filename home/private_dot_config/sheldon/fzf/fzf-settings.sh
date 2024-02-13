# fzf configuration for bash or zsh only.
export FZF_DEFAULT_COMMAND='fd --color always --unrestricted -E .git -E .Trash-1000 -E .DS_Store'
export FZF_DEFAULT_OPTS='
    --ansi
    --cycle
    --exact
    --multi
    --preview="\"$SHELDON_CONFIG_DIR/fzf/preview.sh\" {}"
    --preview-window="up,hidden,~3"
    --bind="ctrl-d:preview-half-page-down"
    --bind="ctrl-g:become(\"$SHELDON_CONFIG_DIR/fzf/cd.sh\" {})"
    --bind="ctrl-o:execute-silent(xdg-open {})"
    --bind="ctrl-t:toggle-preview"
    --bind="ctrl-u:preview-half-page-up"
    --bind="ctrl-v:become($EDITOR {+})"
    --bind="ctrl-y:execute-silent(\"$SHELDON_CONFIG_DIR/fzf/pbcopy.sh\" \"{+}\")"
'
FZF_DEFAULT_OPTS="--history=\"$XDG_DATA_HOME/fzf/history\" $FZF_DEFAULT_OPTS"
