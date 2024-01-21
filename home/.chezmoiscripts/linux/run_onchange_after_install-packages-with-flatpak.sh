#!/usr/bin/env bash

set -eu

if type flatpak &>/dev/null; then
    readonly flatpak_bin='/var/lib/flatpak/exports/bin'
    readonly target_bin="$HOME/.local/flatpak"

    readonly install_packages=(
        org.videolan.VLC
        org.wezfurlong.wezterm
    )

    readonly enable_symlinks=(
        vlc
        wezterm
    )

    function additional-options() {
        local full_package="$1"
        case "$full_package" in
        org.wezfurlong.wezterm)
            sudo flatpak override --filesystem=host org.wezfurlong.wezterm
            ;;
        esac
    }

    function create-symlinks() {
        rm -r "$target_bin" 2>/dev/null || :
        mkdir -p "$target_bin" 2>/dev/null || :

        local full_package=
        for full_package in "${install_packages[@]}"; do
            local package="${full_package##*.}"
            package="${package,,}"
            if [[ ${enable_symlinks[*]} =~ $package ]]; then
                ln -s "$flatpak_bin/$full_package" "$target_bin/$package"
            fi
        done
    }

    for full_package in "${install_packages[@]}"; do
        if ! [[ -x $flatpak_bin/$full_package ]]; then
            flatpak install -y flathub "$full_package"
            additional-options "$full_package"
        fi
    done

    create-symlinks
fi
