#!/usr/bin/env bash

dir='.'
if [[ -d $1 ]]; then
    dir="$1"
else
    replaced="${1%/*}"
    if [[ $replaced != $1 ]]; then
        dir="$replaced"
    fi
fi

case $DOTS_TERMINAL in
wezterm)
    echo "cd \"$dir\"" | wezterm cli send-text --no-paste
    ;;
*)
    cd "$dir" && exec "$DOTS_ISHELL"
    ;;
esac
