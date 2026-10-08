#!/bin/sh

set -eu

readonly BREW_INSTALL_URL='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
readonly MIN_GLIBC_VERSION='2.13'

error() { printf '\nERROR: %s\n' "$*" >&2; }

is_supported_glibc() (
    version=$(getconf GNU_LIBC_VERSION 2>/dev/null | awk '{ print $2 }')

    [ -n "$version" ] || return 1

    major=${version%%.*}
    minor=${version#*.}
    minor=${minor%%.*}

    min_major=${MIN_GLIBC_VERSION%%.*}
    min_minor=${MIN_GLIBC_VERSION#*.}
    min_minor=${min_minor%%.*}

    [ "$major" -gt "$min_major" ] ||
        {
            [ "$major" -eq "$min_major" ] &&
                [ "$minor" -ge "$min_minor" ]
        }
)

can_install_homebrew() {
    case "$(uname -s):$(uname -m)" in
        Darwin:arm64)
            return 0
            ;;

        Linux:x86_64|Linux:aarch64)
            is_supported_glibc
            ;;

        *)
            return 1
            ;;
    esac
}

install_homebrew_dependencies() {
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y \
            bash \
            build-essential \
            procps \
            curl \
            file \
            git

    elif command -v dnf >/dev/null 2>&1; then
        if sudo dnf group install -y development-tools; then
            :
        else
            sudo dnf group install -y 'Development Tools'
        fi

        sudo dnf install -y \
            bash \
            procps-ng \
            curl \
            file \
            git

    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed --noconfirm \
            bash \
            base-devel \
            procps-ng \
            curl \
            file \
            git

    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper --non-interactive install \
            bash \
            gcc \
            make \
            procps \
            curl \
            file \
            git

    else
        error 'unsupported package manager.'
        return 1
    fi
}

# Darwin x86_64 Homebrew は Dotfiles 対象外.
is_homebrew_installed() {
    [ -x /opt/homebrew/bin/brew ] || [ -x /home/linuxbrew/.linuxbrew/bin/brew ]
}

install_homebrew() {
    if is_homebrew_installed; then
        return 0
    fi

    if ! can_install_homebrew; then
        error 'Homebrew is not supported on this system.'
        return 1
    fi

    case "$(uname -s)" in
        Linux)
            install_homebrew_dependencies
            ;;

        Darwin)
            ;;
    esac

    if ! command -v bash >/dev/null 2>&1; then
        error 'bash is required to install Homebrew.'
        return 1
    fi

    if ! command -v curl >/dev/null 2>&1; then
        error 'curl is required to install Homebrew.'
        return 1
    fi

    installer=$(curl -fsSL "$BREW_INSTALL_URL") || {
        error 'Failed to download Homebrew installer.'
        return 1
    }
    bash -c "$installer"
}

install_homebrew
is_homebrew_installed
