#!/usr/bin/env bash

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
        bat --force-colorization --number --paging=never \
            --file-name="$target"
    else
        cat
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
        hexyl --border none --length 16KiB -- "$1"
    elif command -v hexdump >/dev/null 2>&1; then
        hexdump -C -n 16384 -- "$1"
    else
        od -Ax -tx1 -N 16384 < "$1"
    fi
}

image() {
    if command -v chafa >/dev/null 2>&1; then
        # offset はプレビューヘッダーを固定している分.
        local max=64 lines_offset=3
        local cols=$FZF_PREVIEW_COLUMNS
        local lines=$FZF_PREVIEW_LINES

        [[ -n "$cols" && -n "$lines" ]] || return

        ((lines -= lines_offset)) || :
        ((cols > max)) && cols=$max
        ((lines > max)) && lines=$max
        ((cols < 1)) && cols=1
        ((lines < 1)) && lines=1

        # Ghostty で画像が表示された後消えないので, 妥協でユニコード表示にする.
        chafa --format=symbols --size="${cols}x${lines}" "$1"
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
