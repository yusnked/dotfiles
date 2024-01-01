#!/usr/bin/env bash
set -eu

SCRIPT_NAME="${0##*/}"
DOTFILES_URL='https://github.com/yusnked/dotfiles.git'
DOTFILES_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/chezmoi"
BSHELL_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/_b-shell"
NIX_CMD="/nix/var/nix/profiles/default/bin/nix --experimental-features 'nix-command flakes'"

if [[ -e /nix ]]; then
    exit 0
fi

if ! which git curl >/dev/null 2>&1; then
    echo "[$SCRIPT_NAME/ERROR] You need git and curl to install." >&2
    exit 1
fi

# git clone dotfiles
if [[ -e $DOTFILES_DIR ]]; then
    cat <<-EOF
[$SCRIPT_NAME/WARN]
"$DOTFILES_DIR"
directory already exists.
You must delete that directory to install.

EOF
    echo -n 'Delete? [y/n]: '
    read confirm
    if [[ ! $confirm =~ ^[Yy](es)?$ ]]; then
        echo 'Installation aborted.' >&2
        exit 1
    fi

    rm -rf "$DOTFILES_DIR"
fi

mkdir -p "$DOTFILES_DIR"
git clone "$DOTFILES_URL" "$DOTFILES_DIR"

echo "[$SCRIPT_NAME/INFO] Cloned dotfiles from $DOTFILES_URL."

sleep 1

# Install Nix
cd "$DOTFILES_DIR"
bash ./install_scripts/nix-install.sh

echo "[$SCRIPT_NAME/INFO] Nix is installed."

sleep 1

# source _b-shell/env.sh and chezmoi install
# 1回profile installしておかないとhome-manager switchした時にエラーになる.
eval $NIX_CMD profile install 'nixpkgs#chezmoi'
eval $NIX_CMD run 'nixpkgs#chezmoi' -- init
eval $NIX_CMD run 'nixpkgs#chezmoi' -- apply "$BSHELL_DIR"
source "$BSHELL_DIR/env.sh"
chezmoi apply
eval $NIX_CMD profile remove 0

echo "[$SCRIPT_NAME/INFO] Chezmoi is installed."

sleep 1

# home-manager install
eval $NIX_CMD run 'nixpkgs#home-manager' -- switch

echo "[$SCRIPT_NAME/INFO] home-manager is installed."

cat <<-EOF
[$SCRIPT_NAME/INFO] dotfiles installation is complete!

Please restart the shell
EOF
