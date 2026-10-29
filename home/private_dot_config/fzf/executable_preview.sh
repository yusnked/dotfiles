#!/usr/bin/env bash

# Zsh からも呼び出されるので Bash 独自の構文は使わないこと.
# exec するため対話シェルから source で使わないこと.

list() {
    if command -v eza >/dev/null 2>&1; then
        eza -la --color=always --icons --group-directories-first \
            --group --git --time-style=long-iso "$@"
    elif ls --version >/dev/null 2>&1; then
        # GNU ls.
        ls -lahF --color=always --time-style=long-iso "$@"
    else
        # BSD ls.
        CLICOLOR_FORCE=1 ls -lahFG -D '%Y-%m-%d %H:%M' "$@"
    fi
}

cat_file() {
    if command -v bat >/dev/null 2>&1; then
        exec bat \
            --force-colorization \
            --number \
            --paging=never \
            --file-name="$target"
    else
        exec cat
    fi
}

convert_encoding() {
    if command -v nkf >/dev/null 2>&1; then
        nkf -w
    else
        cat
    fi
}

# バイナリの先頭 16 KiB を表示する.
hex_file() {
    if command -v hexyl >/dev/null 2>&1; then
        exec hexyl --border none --length 16KiB -- "$1"
    elif command -v hexdump >/dev/null 2>&1; then
        exec hexdump -C -n 16384 -- "$1"
    else
        exec od -Ax -tx1 -N 16384 < "$1"
    fi
}

image() {
    if command -v chafa >/dev/null 2>&1; then
        # offset はプレビューヘッダーを固定している分.
        local cols=96 lines=48 lines_offset=3
        local max_cols=${FZF_PREVIEW_COLUMNS:-$COLUMNS}
        local max_lines=$((${FZF_PREVIEW_LINES:-$LINES} - lines_offset))

        ((cols > max_cols)) && cols=$max_cols
        ((lines > max_lines)) && lines=$max_lines
        ((cols < 1)) && cols=1
        ((lines < 1)) && lines=1

        if [[ "$TERM_PROGRAM" != ghostty ]]; then
            exec chafa \
                --format=symbols \
                --probe=off \
                --size="${cols}x${lines}" \
                -- "$1"
        fi

        # fzf が古いプレビューを中断する性質を利用し, sleep で疑似 debounce する.
        sleep 0.25

        # Ghostty では Kitty Graphics Protocol を使用して画像をプレビューする.
        #
        # Kitty 形式では画像が残留するため, プレビュー更新前と fzf 終了後に
        # エスケープシーケンスで削除する必要がある.
        # ただし, 全画像を削除するため他の画像に影響する可能性がある.
        #
        # アニメーション画像は表示が乱れて TUI 全体が崩れるため無効化する.
        #
        # Unicode プレースホルダー形式なら画像の残留を回避できるが,
        # chafa には直接指定する方法がない (2026/10/29 時点).
        # --passthrough=tmux を指定し, sed で tmux 用のエスケープシーケンスを
        # 除去するハックが必要になる.
        # また, 画像を表示する度にメモリ使用量が増え続ける問題もある.
        exec chafa \
            --format=kitty \
            --probe=off \
            --animate=off \
            --size="${cols}x${lines}" \
            -- "$1"
    else
        hex_file "$1"
    fi
}

header() {
    local width="${FZF_PREVIEW_COLUMNS:-80}" line

    printf -v line '%*s' "$width" ''
    line="${line// /-}"

    list -d -- "${target##*/}" 2>/dev/null || :
    printf '\033[38;5;240m%s\033[0m\n\033[38;5;240m%s\033[0m\n' "$mime" "$line"
}

# Ghostty なら画像削除用エスケープシーケンスをまず送る.
[[ "$TERM_PROGRAM" == ghostty ]] && printf '\033_Ga=d,d=A\033\\'

target="${1:-}"
# 誤爆の可能性から / は除外する.
[[ -n "$target" && "$target" != '/' ]] || exit 0
[[ -e "$target" || -L "$target" ]] || exit 0

# header のファイルパスを簡素化するために cd するので target は絶対パスにする.
target="${target%/}"
[[ "$target" == /* ]] || target="$PWD/$target"

builtin cd -- "${target%/*}/" 2>/dev/null || :

# mime 取得 (リンク先もたどる).
if [[ -L "$target" && ! -e "$target" ]]; then
    mime='inode/symlink'
else
    mime="$(file -Lb --mime -- "$target" 2>/dev/null)" || mime=unknown
fi
header

if [[ -L "$target" && ! -e "$target" ]]; then
    printf '%s\n' '<BROKEN SYMLINK>'
    exit 0
elif [[ ! -f "$target" && ! -d "$target" ]]; then
    printf '%s\n' '<SPECIAL FILE>'
    exit 0
elif [[ ! -r "$target" ]]; then
    printf '%s\n' '<PERMISSION DENIED>'
    exit 0
fi

case "$mime" in
    inode/directory\;*)
        listing=$(list -- "$target" 2>/dev/null | head -n 512)
        printf '%s\n' "${listing:-<EMPTY DIRECTORY>}"
        ;;
    inode/x-empty\;*)
        printf '%s\n' '<EMPTY FILE>'
        ;;
    image/*)
        image "$target"
        ;;
    *charset=binary)
        hex_file "$target"
        ;;
    *charset=us-ascii | *charset=utf-8)
        # テキストの先頭 32 KiB を表示する (マルチバイト文字が途中で切れる問題あり).
        # head -c は POSIX 非標準だが OpenBSD 以外で使える.
        head -c 32768 < "$target" | cat_file
        ;;
    *)
        head -c 32768 < "$target" | convert_encoding | cat_file
        ;;
esac
