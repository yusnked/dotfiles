#!/bin/sh

for cmd in /opt/homebrew/bin/zsh /home/linuxbrew/.linuxbrew/bin/zsh; do
    [ -x "$cmd" ] && exec "$cmd" -l
done

# -l は POSIX 非標準だが, 主要なシェルではログインシェルとして起動する.
[ -x "$SHELL" ] && exec "$SHELL" -l

exec /bin/sh -l
