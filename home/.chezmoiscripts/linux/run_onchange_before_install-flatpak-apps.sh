#!/usr/bin/env bash

set -eu

# sudo rm -r /var/lib/flatpak

readonly flatpak_bin='/var/lib/flatpak/exports/bin'
readonly target_bin="$HOME/.local/flatpak"

# --symlink {name}: Enable symlink
# $1 : Application ID
# $2~: flatpak override args (optional)
# https://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-override
function install() {
    local args=()
    local symlink_name=''
    while [[ $# > 0 ]]; do
        case $1 in
        --)
            shift
            break
            ;;
        --symlink)
            symlink_name="${2?}"
            shift 2
            ;;
        *)
            args+=("$1")
            shift
            ;;
        esac
    done
    args+=("$@")
    set "${args[@]}"

    # Set id
    local -r id_pattern='^[^ .]+\.[^ .]+\.[^ .]+$'
    if [[ $1 =~ $id_pattern ]]; then
        local -r id="$1"
        shift
    else
        echo "flatpak install: Not ID: $1" >&2
        exit 1
    fi

    # Install apps
    if [[ ! -x $flatpak_bin/$id ]]; then
        flatpak install -y flathub "$id"
        if [[ $# > 0 ]]; then
            eval sudo flatpak override "$@" "$id"
        fi
    fi

    # Create symlink
    if [[ -n $symlink_name ]]; then
        ln -s "$flatpak_bin/$id" "$target_bin/$symlink_name"
    fi
}

echo 'Install Flatpak and Apps...'
sudo -v

# Install Flatpak
install_flatpak_flag=0
if ! type flatpak &>/dev/null; then
    if type apt-get &>/dev/null; then
        sudo apt-get update && sudo apt-get install -y flatpak
    else
        # TODO: Add other package managers as needed.
        exit 0
    fi

    flatpak remote-add --if-not-exists flathub 'https://dl.flathub.org/repo/flathub.flatpakrepo'
    install_flatpak_flag=1
fi

# Install Apps
if [[ $install_flatpak_flag == 1 ]] || type flatpak &>/dev/null; then
    # Remove symlinks
    rm -r "$target_bin" 2>/dev/null || :
    mkdir -p "$target_bin"

    install org.cryptomator.Cryptomator -- --filesystem={/media,/mnt}
    install org.videolan.VLC --symlink vlc
    install org.wezfurlong.wezterm --symlink wezterm -- --filesystem=host
fi
