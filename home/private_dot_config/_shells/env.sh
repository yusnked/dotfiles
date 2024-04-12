export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

if [[ -n $FLATPAK_SANDBOX_DIR ]]; then
    export DOTS_CACHE_HOME="${HOST_XDG_CACHE_HOME:-$HOME/.cache}"
    export DOTS_CONFIG_HOME="${HOST_XDG_CONFIG_HOME:-$HOME/.config}"
    export DOTS_DATA_HOME="${HOST_XDG_DATA_HOME:-$HOME/.local/share}"
    export DOTS_STATE_HOME="${HOST_XDG_STATE_HOME:-$HOME/.local/state}"
else
    export DOTS_CACHE_HOME="$XDG_CACHE_HOME"
    export DOTS_CONFIG_HOME="$XDG_CONFIG_HOME"
    export DOTS_DATA_HOME="$XDG_DATA_HOME"
    export DOTS_STATE_HOME="$XDG_STATE_HOME"
fi

export DOTS_SHELLS_DIR="$DOTS_CONFIG_HOME/_shells"

export EDITOR='nvim'
export LANG='ja_JP.UTF-8'
export LC_TIME='C'

export DOTS_OS="${DOTS_OS:-$(uname -s)}"

# Nix multi-user mode
if [[ -r '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]]; then
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Home-manager
if [[ -r "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]]; then
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
