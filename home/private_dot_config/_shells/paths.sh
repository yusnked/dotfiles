# Nix
path-add /nix/var/nix/profiles/default/bin "$HOME/.nix-profile/bin"

if [[ ${DOTS_OS:=$(uname -s)} == Darwin ]]; then
    # Homebrew
    path-add /usr/local/{sbin,bin} /opt/homebrew/{sbin,bin}

elif [[ $DOTS_OS == Linux ]]; then
    # Flatpak
    path-add -m push "$HOME/.local/flatpak"
fi

path-add "$HOME/.local/bin"

# mise
path-add "$DOTS_DATA_HOME/mise/shims"
