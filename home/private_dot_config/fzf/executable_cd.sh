#!/usr/bin/env bash

set -e

target_path="${1?}"
if [[ -d $target_path ]]; then
    readonly target_dir="$target_path"
elif [[ $target_path =~ / ]]; then
    readonly target_dir="${target_path%/*}"
else
    readonly target_dir='.'
fi

readonly cd_cmd="builtin cd '$target_dir'"$'\n'

if [[ $TERM_PROGRAM == tmux ]]; then
    tmux send -lt "$TMUX_PANE" "$cd_cmd"
    exit
fi

case $DOTS_TERMINAL in
wezterm)
    wezterm cli send-text --no-paste "$cd_cmd"
    ;;
*)
    builtin cd "$target_dir"
    echo $'\n'"cd in new shell. (SHLVL: $SHLVL)"
    exec "${DOTS_ISHELL-$SHELL}"
    ;;
esac
