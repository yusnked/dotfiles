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
