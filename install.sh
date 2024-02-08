#!/usr/bin/env bash
set -eu

SCRIPT_NAME="${0##*/}"
GITHUB_USERNAME='yusnked'
DOTFILES_DIR="${XDG_DATA_HOME:=${HOME}/.local/share}/chezmoi"
BSHELL_ENV="${XDG_CONFIG_HOME:-${HOME}/.config}/_b-shell/env.sh"

# Install chezmoi
CHEZMOI_BIN="$HOME/.local/bin/chezmoi"
if [[ ! -e $CHEZMOI_BIN ]]; then
    BINDIR="$HOME/.local/bin" sh -c "$(curl -fsLS chezmoi.io/getlb)"
    sleep 1
fi

if grep -q 'url = https://github.com/yusnked/dotfiles.git' "$DOTFILES_DIR/.git/config" 2>/dev/null; then
    "$CHEZMOI_BIN" update
    echo "[$SCRIPT_NAME/INFO] Run 'chezmoi update'."
else
    "$CHEZMOI_BIN" init --apply "$GITHUB_USERNAME"
    echo "[$SCRIPT_NAME/INFO] Chezmoi is installed."
fi

sleep 1

# Install Nix by Determinate Nix Installer
NIX_BIN='/nix/var/nix/profiles/default/bin/nix'
if [[ ! -e $NIX_BIN ]]; then
    export NIX_INSTALLER_DIAGNOSTIC_ENDPOINT=''
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |
        sh -s -- install --no-modify-profile --no-confirm

    echo "[$SCRIPT_NAME/INFO] Nix is installed."
fi

sleep 1

source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'

# home-manager install
"$NIX_BIN" run 'nixpkgs#home-manager' -- switch

# Fonts symlink
FONTS_DIR="$XDG_DATA_HOME/fonts"
FONTS_SYMLINK="$FONTS_DIR/HomeManager"
if [[ ! -L $FONTS_SYMLINK && $(uname -s) == Linux ]]; then
    mkdir -p "$FONTS_DIR"
    ln -s "$HOME/.nix-profile/share/fonts" "$FONTS_SYMLINK"
    fc-cache -f
fi

echo "[$SCRIPT_NAME/INFO] Run 'home-manager switch'."

source "$BSHELL_ENV"
"$CHEZMOI_BIN" apply

cat <<-EOF
[$SCRIPT_NAME/INFO] dotfiles installation is complete!

Please restart the shell
EOF
