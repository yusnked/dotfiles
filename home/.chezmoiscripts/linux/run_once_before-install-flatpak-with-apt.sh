#!/usr/bin/env bash

set -eu

# sudo rm -r /var/lib/flatpak

if ! type flatpak &>/dev/null && type apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y flatpak
    flatpak remote-add --if-not-exists flathub 'https://dl.flathub.org/repo/flathub.flatpakrepo'
fi
