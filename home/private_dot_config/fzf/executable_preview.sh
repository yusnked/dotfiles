#!/usr/bin/env bash -eu

if [[ -z $1 ]]; then exit 1; fi
target="$1"

exa="$(exa -ld --no-permissions --octal-permissions --time-style=long-iso --git "$target")"
mime="$(file -b --mime "$target")"
is_git_dir="$(git rev-parse --is-inside-work-tree 2> /dev/null || true)"

if [[ -L $target ]]; then
    status="$exa"
elif [[ $is_git_dir == true ]]; then
    status="$(echo $exa | cut -d' ' -f 1-6) $(basename "$target")"
else
    status="$(echo $exa | cut -d' ' -f 1-5) $(basename "$target")"
fi

# Preview header
cat <<END
$status
$mime
================================================================================
END

if [[ -d $target ]]; then
    if [[ -L $target ]]; then
        ls -FL1 --color=always "$target"
        exit 0
    fi
    ls -F1 --color=always "$target"
    exit 0
fi

bat='head -n 1024 "$target" | bat --force-colorization --number -'

case "$mime" in
    *charset=binary)
        hexyl --border none "$target" --length 16KiB
    ;;
    *)
        eval $bat
    ;;
esac

