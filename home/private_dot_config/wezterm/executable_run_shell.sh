#!/usr/bin/env bash

# nixでインストールされたzshが存在すればそれを起動する
nix_zsh="$HOME/.nix-profile/bin/zsh"
if [ -x "$nix_zsh" ]; then
    eval "exec $nix_zsh -l"
fi

# 存在しなければ、zsh -> bash の順番に起動を試みる
if which zsh > /dev/null 2>&1; then
    exec /usr/bin/env zsh -l
elif which bash > /dev/null 2>&1; then
    exec /usr/bin/env bash -l
fi

