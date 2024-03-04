#!/usr/bin/env bash

set -e

target="${1%/}"

[[ -e $target ]] || exit

readonly bat_flags='--force-colorization --number'
readonly eza_flags='-la --color=always --git --icons --no-permissions --octal-permissions --time-style=long-iso'
readonly header_color='240'

# Header line
readonly line_width_80='================================================================================'
header_line="$line_width_80$line_width_80$line_width_80$line_width_80$line_width_80"
header_line="${header_line:0:$FZF_PREVIEW_COLUMNS}"

mime="$(file -b --mime "$target")"
if [[ ${mime##*charset=} != binary ]]; then
    readonly nkf="$(head -n 512 "$target" 2>/dev/null | nkf --guess)"
fi

# Preview header
echo $(
    if [[ $target =~ / ]]; then
        cd_dir="${target%/*}"
        target_dir="${target##*/}"
    else
        cd_dir='.'
        target_dir="$target"
    fi
    cd "$cd_dir" 2>/dev/null
    eza -d $eza_flags "$target_dir" 2>/dev/null
)
echo -e "\e[38;5;${header_color}m$mime${nkf:+ [nkf: $nkf]}\e[39m"
echo -e "\e[38;5;${header_color}m$header_line\e[39m"

if [[ ! -r $target ]]; then
    echo '<PERMISSION DENIED>'
    exit
fi

case "$mime" in
inode/x-empty\;*)
    echo "<EMPTY FILE>"
    ;;
inode/directory\;*)
    directories="$(eza $eza_flags "$target" | head -n 512)"
    if [[ -n $directories ]]; then
        echo "$directories"
    else
        echo '<EMPTY DIRECTORY>'
    fi
    ;;
*charset=binary)
    hexyl --border none "$target" --length 16KiB
    ;;
*charset=us-ascii | *charset=utf-8)
    head -n 512 "$target" | bat $bat_flags
    ;;
*)
    head -n 512 "$target" | nkf | bat $bat_flags
    ;;
esac
