# dotfiles

My personal dotfiles for macOS (Apple Silicon) and Linux (Homebrew-compatible), managed with [chezmoi](https://www.chezmoi.io/).

## Installation

> [!WARNING]
> This installer is intended for my personal environment.
> Existing configuration files may be overwritten without backup.

**Using curl:**

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/yusnked/dotfiles/main/install.sh)"
```

**Using wget:**

```sh
sh -c "$(wget -qO - https://raw.githubusercontent.com/yusnked/dotfiles/main/install.sh)"
```

The installation script will:

1. Install chezmoi and apply the dotfiles.
2. Install Homebrew if it is not already installed.
3. Optionally install packages using `brew bundle`.
