#!/usr/bin/env bash

set -eu

# sudo rm -r /var/lib/flatpak

# Install Apps
function main() {
    install org.cryptomator.Cryptomator -- --filesystem={/media,/mnt}
    install org.videolan.VLC --symlink vlc
    install org.wezfurlong.wezterm --symlink wezterm -- --filesystem=host

    # Development
    if [[ $(chezmoi execute-template '{{.packages.isDevelopment}}' 2>/dev/null) == true ]]; then
        vscodium_posthook() {
            local -r settings_host="$XDG_CONFIG_HOME/Code/User/settings.json"
            local -r settings_flatpak="$HOME/.var/app/com.vscodium.codium/config/VSCodium/User/settings.json"
            ln -sf "$settings_host" "$settings_flatpak"
        }
        install com.vscodium.codium --symlink code --posthook vscodium_posthook
    fi
}

# --symlink {name}: Enable symlink
# $1 : Application ID
# $2~: flatpak override args (optional)
# https://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-override
function install() {
    local symlink_name='' posthook='' args=()
    while [[ $# -gt 0 ]]; do
        case $1 in
        --)
            shift
            break
            ;;
        --symlink)
            symlink_name="${2?}"
            shift 2
            ;;
        --posthook)
            posthook="${2?}"
            shift 2
            ;;
        *)
            args+=("$1")
            shift
            ;;
        esac
    done
    args+=("$@")
    set -- "${args[@]}"

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
        if [[ $# -gt 0 ]]; then
            sudo flatpak override "$@" "$id"
        fi
        # Posthook
        [[ -n $posthook ]] && $posthook
    fi

    # Create symlink
    if [[ -n $symlink_name ]]; then
        ln -s "$flatpak_bin/$id" "$target_bin/$symlink_name"
    fi
}

readonly flatpak_bin='/var/lib/flatpak/exports/bin'
readonly target_bin="$HOME/.local/flatpak"

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

if [[ $install_flatpak_flag == 1 ]] || type flatpak &>/dev/null; then
    # Remove symlinks
    rm -r "$target_bin" 2>/dev/null || :
    mkdir -p "$target_bin"
    main
fi
