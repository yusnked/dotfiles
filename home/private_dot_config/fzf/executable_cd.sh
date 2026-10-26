#!/usr/bin/env bash

set -eo pipefail

[[ "$#" -gt 0 && -e "$1" ]] || exit 1

dir="$1"
[[ -d "$dir" ]] || dir="$(dirname -- "$dir")"

old_pwd="$PWD"
CDPATH= builtin cd -L -- "$dir"
[[ "$PWD" == "$old_pwd" ]] && exit 0

dir="$PWD"

# 送信先のシェルでも実行できる POSIX 準拠の cd コマンドを生成する.
# builtin は POSIX 非標準. -- は dir が絶対パスのため使用しない.
printf -v cd_cmd "cd '%s'" "${dir//\'/\'\\\'\'}"

# macOS の Bash 3.2 では ${VAR,,} が使えないため tr で小文字に正規化する.
case "$(printf '%s:%s' "$TERM_PROGRAM" "$DOTS_OS" | tr '[:upper:]' '[:lower:]')" in
    ghostty:darwin)
        osascript -e '
            on run argv
                tell application "Ghostty"
                    set term to focused terminal of selected tab of front window
                    input text (item 1 of argv) to term
                    send key "enter" to term
                end tell
            end run
        ' "$cd_cmd"
        ;;
    tmux:*)
        tmux send-keys -t "$TMUX_PANE" -l "$cd_cmd"
        tmux send-keys -t "$TMUX_PANE" Enter
        ;;
    wezterm:*)
        wezterm cli send-text --no-paste "${cd_cmd}"$'\n'
        ;;
    *)
        # 表示する SHLVL はあくまで目安で正しいとは限らない.
        # ただし, 試した限りではこの時点で SHLVL が既に +1 されており,
        # exec {bash,zsh} では増えないため, 正しい値が表示される.
        printf -- '-> %s\n   New shell - SHLVL %s\n' "$dir" "$SHLVL"
        exec "${DOTS_ISHELL:-$SHELL}"
        ;;
esac
