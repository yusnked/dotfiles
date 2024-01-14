#!/usr/bin/env bash
set -eu

SCRIPT_NAME="${0##*/}"
GITHUB_USERNAME='yusnked'
DOTFILES_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/chezmoi"
BSHELL_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/_b-shell"

# Install chezmoi
PATH="$HOME/.local/bin:$PATH"
if ! type chezmoi &>/dev/null || ! [[ -d $DOTFILES_DIR ]]; then
    sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply "$GITHUB_USERNAME"

    echo "[$SCRIPT_NAME/INFO] Chezmoi is installed."
else
    chezmoi update
fi

sleep 1

# Install Nix
cd "$DOTFILES_DIR"
bash ./install_scripts/nix-install.sh

echo "[$SCRIPT_NAME/INFO] Nix is installed."

sleep 1

# home-manager install
source "$BSHELL_DIR/env.sh"
nix run 'nixpkgs#home-manager' -- switch

echo "[$SCRIPT_NAME/INFO] home-manager is installed."

cat <<-EOF
[$SCRIPT_NAME/INFO] dotfiles installation is complete!

Please restart the shell
EOF
