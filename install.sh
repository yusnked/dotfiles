#!/bin/sh
set -eu

readonly SCRIPT_NAME='dotfiles/install.sh'
readonly REPO_URL='https://github.com/yusnked/dotfiles.git'
readonly CHEZMOI_INSTALL_URL='https://get.chezmoi.io'
readonly CHEZMOI_BIN="$HOME/.local/bin/chezmoi"
readonly DOTFILES_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"

info() { printf '\n%s: INFO: %s\n' "$SCRIPT_NAME" "$*"; }
error() { printf '\n%s: ERROR: %s\n' "$SCRIPT_NAME" "$*" >&2; }

download() {
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$1"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO - "$1"
    else
        error 'curl or wget is required.'
        return 1
    fi
}

prompt() {
    printf '\n%s: %s [Y/n]: ' "$SCRIPT_NAME" "$1"
    IFS= read -r answer || return 1
    case "$answer" in
        [nN]|[nN][oO]) return 1 ;;
        *) return 0 ;;
    esac
}

dots_origin_url() {
    [ -f "$DOTFILES_PATH/.git/config" ] && awk '
        /^\[remote "origin"\]$/ { found = 1; next }
        /^\[/ { found = 0 }
        found && /^[[:space:]]*url[[:space:]]*=/ {
            sub(/^[^=]*=[[:space:]]*/, "")
            sub(/[[:space:]]+$/, "")
            print
            exit
        }
    ' "$DOTFILES_PATH/.git/config"
}

brew_bin() {
    # Darwin x86_64 Homebrew は Dotfiles 対象外.
    if [ -x /opt/homebrew/bin/brew ]; then
        printf '%s\n' /opt/homebrew/bin/brew
    elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
        printf '%s\n' /home/linuxbrew/.linuxbrew/bin/brew
    else
        return 1
    fi
}

# まず ~/.local/bin に chezmoi をインストールする. 既に存在すれば上書きされる.
installer=$(download "$CHEZMOI_INSTALL_URL") || { error 'Failed to download chezmoi installer.'; exit 1; }
mkdir -p "$HOME/.local/bin"
sh -c "$installer" -- -b "$HOME/.local/bin"
[ -x "$CHEZMOI_BIN" ] || { error 'chezmoi installation failed.'; exit 1; }

# 既に ~/.local/share/chezmoi が存在する場合, 同じ repo なら update する.
if [ -e "$DOTFILES_PATH" ] || [ -L "$DOTFILES_PATH" ]; then
    if [ "$(dots_origin_url)" = "$REPO_URL" ]; then
        info 'Updating existing dotfiles repository.'
        "$CHEZMOI_BIN" --source "$DOTFILES_PATH" --use-builtin-git=on update
    else
        error "Existing source directory does not match $REPO_URL"
        error 'Installation aborted.'
        exit 1
    fi
else
    "$CHEZMOI_BIN" --source "$DOTFILES_PATH" --use-builtin-git=on init --apply "$REPO_URL"
fi

# Homebrew をインストール.
if ! brew_bin >/dev/null; then
    if sh "$DOTFILES_PATH/scripts/install/homebrew.sh"; then
        info 'Homebrew installation completed.'
    else
        error 'Dotfiles were deployed, but Homebrew installation failed. Exiting.'
        exit 1
    fi
fi

BREW_BIN=$(brew_bin) || { error 'Homebrew was not found.'; exit 1; }
readonly BREW_BIN

# chezmoi は homebrew で管理する.
"$BREW_BIN" install -y chezmoi
rm -f "$CHEZMOI_BIN"

if prompt 'Install packages?'; then
    # ~/.config/homebrew/Brewfile を読み込んでもらうためには XDG_CONFIG_HOME を設定する必要がある.
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}" "$BREW_BIN" bundle --global
fi

printf '\n%s: dotfiles installation is complete!\nPlease restart the shell.\n' "$SCRIPT_NAME"
