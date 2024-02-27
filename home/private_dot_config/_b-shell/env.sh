export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export NIX_DATA_DIR="$HOME/.nix-profile/share"

export EDITOR='nvim'
export LANG='ja_JP.UTF-8'
export LC_TIME='C'

export DOTS_OS="${DOTS_OS:-$(uname -s)}"

source "$XDG_CONFIG_HOME/_b-shell/helpers.sh"

# Nix multi-user mode
if [[ -r '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]]; then
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Home-manager
if [[ -r "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]]; then
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
path-add /nix/var/nix/profiles/default/bin "$HOME/.nix-profile/bin"

if [[ $DOTS_OS == Darwin ]]; then
    # Homebrew
    path-add /usr/local/{sbin,bin} /opt/homebrew/{sbin,bin}

    export BROWSER='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
elif [[ $DOTS_OS == Linux ]]; then
    path-add -m push "$HOME/.local/flatpak"
fi

path-add "$HOME/.local/bin"
