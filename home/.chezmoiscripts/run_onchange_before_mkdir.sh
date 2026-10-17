#!/bin/sh

set -eu

data="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p -- \
    "$data/fzf" \
    "$data/zoxide"
