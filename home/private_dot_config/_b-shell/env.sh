export LC_ALL=${LC_ALL:-ja_JP.UTF-8}
export LANG=${LANG:-ja_JP.UTF-8}

export EDITOR=nvim

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export NIX_DATA_DIR="$HOME/.nix-profile/share"

export DOTFILES_OS="${DOTFILES_OS:-$(uname -s)}"

# PATH
source "$XDG_CONFIG_HOME/_b-shell/add-2path.sh"
if [[ $DOTFILES_OS == Darwin ]]; then
    # Homebrew
    add-2path '/usr/local/sbin' unshift exists
    add-2path '/usr/local/bin' unshift exists
    add-2path '/opt/homebrew/sbin' unshift exists
    add-2path '/opt/homebrew/bin' unshift exists
fi

# Nix multi-user mode
if [[ -r '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]]; then
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
add-2path '/nix/var/nix/profiles/default/bin' unshift exists
add-2path "$HOME/.nix-profile/bin" unshift exists

# Home-manager
if [[ -r "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]]; then
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

add-2path "$HOME/.local/bin" unshift exists

