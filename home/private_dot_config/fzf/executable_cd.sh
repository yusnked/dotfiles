#!/usr/bin/env bash
set -eu

dir="$1"
if ! [[ -d $dir ]]; then
    dir="${dir%/*}"
fi

# Weztermを使用している場合はペインに文字を送って現在のプロセスでcdする
if [[ $TERM_PROGRAM == WezTerm ]]; then
    exec echo "cd \"$dir\"" | wezterm cli send-text --no-paste
    exit
fi

# それ以外の場合はサブシェルでそのディレクトリを開く
cd "$dir"
exec "$DOTS_ISHELL"

