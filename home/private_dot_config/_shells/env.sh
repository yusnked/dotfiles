export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export DOTS_SHELLS_DIR="$XDG_CONFIG_HOME/_shells"

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

source "$DOTS_SHELLS_DIR/helpers.sh"
source "$DOTS_SHELLS_DIR/paths.sh"
