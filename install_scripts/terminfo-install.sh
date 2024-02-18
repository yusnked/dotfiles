#!/usr/bin/env bash

set -e

readonly TEMP_DIR="$(mktemp -d /tmp/install-terminfo-XXXX)"
trap 'rm -r "$TEMP_DIR"' EXIT
cd "$TEMP_DIR"

unset FORCE_INSTALL
if [[ $1 == -f ]]; then
    readonly FORCE_INSTALL=1
fi

function download_terminfo.src() {
    if [[ ! -f ./terminfo.src ]]; then
        curl -LsSO 'https://invisible-island.net/datafiles/current/terminfo.src.gz'
        gunzip 'terminfo.src.gz'
    fi
    cat './terminfo.src'
}

function download_wezterm.terminfo() {
    curl -LsS 'https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo'
}

function install_terminfo() {
    local terminfo="${1?}"
    local -r TERMINFO_SRC="${2?}"
    local -r FIRST_CHAR="${terminfo:0:1}"
    local -r TERMIFNO_DIR="$HOME/.terminfo"
    if [[ -z $FORCE_INSTALL && (-f $TERMIFNO_DIR/$FIRST_CHAR/$terminfo ||
        -f $TERMIFNO_DIR/$(printf '%x' \'$FIRST_CHAR)/$terminfo) ]]; then
        return 0
    fi
    tic -o "$TERMIFNO_DIR" -xe "$terminfo" <(eval "download_$TERMINFO_SRC")
}

install_terminfo 'tmux-256color' 'terminfo.src'
install_terminfo 'wezterm' 'wezterm.terminfo'
