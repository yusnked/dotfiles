#!/usr/bin/env bash

set -eu

if [[ -f "$HOME/.terminfo/74/tmux-256color" || -f "$HOME/.terminfo/t/tmux-256color" ]]; then
    exit 0
fi

readonly TEMP_DIR="$(mktemp -d /tmp/install-tmux-256color-XXXX)"
trap 'rm -r "$TEMP_DIR"' EXIT

curl -LsS https://invisible-island.net/datafiles/current/terminfo.src.gz \
    -o "$TEMP_DIR/terminfo.src.gz"
gunzip "$TEMP_DIR/terminfo.src.gz"

tic -xe tmux-256color "$TEMP_DIR/terminfo.src"
