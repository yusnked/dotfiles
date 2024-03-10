export FZF_DEFAULT_COMMAND='fd --color always --unrestricted -E .git -E .DS_Store -E ".Trash-*"'
export FZF_DEFAULT_OPTS="--ansi --cycle --exact --multi
    --preview='\"$SHELDON_CONFIG_DIR/fzf/preview.sh\" {}'
    --preview-window='up,hidden,~3'
    --history='$XDG_DATA_HOME/fzf/history'
    --bind='ctrl-d:preview-half-page-down'
    --bind='ctrl-l:transform([[ -e {} ]] && echo \"become(\\\"$SHELDON_CONFIG_DIR/fzf/cd.sh\\\" {})\")'
    --bind='ctrl-o:transform([[ -e {} ]] && echo \"execute-silent(xdg-open {} 2>/dev/null)\")'
    --bind='ctrl-t:toggle-preview'
    --bind='ctrl-u:preview-half-page-up'
    --bind='ctrl-v:transform(testall -f {+} && testall -r {+} && echo \"become($EDITOR {+})\")'
    --bind='ctrl-y:execute-silent(\"$SHELDON_CONFIG_DIR/fzf/pbcopy.sh\" \"{+}\")'
"

# If you set LANG=ja_JP.UTF-8, the layout will be broken if you do not set this environment variable.
export RUNEWIDTH_EASTASIAN=0
