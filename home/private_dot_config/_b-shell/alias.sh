### chezmoi
# run_once属性はファイルの内容が変更されたとき一度だけ実行される。それをリセットするコマンド
alias chezmoi-reset-once='chezmoi state delete-bucket --bucket=scriptState'

### Nix
alias nix-hash-git="nix run 'nixpkgs#nix-prefetch-git' --"

### xsel -b
if [[ $DOTS_OS != Darwin ]]; then
    alias pbcopy='xsel -b'
    alias pbpaste='xsel -b'
fi

### ls   exaが存在すればlsを置き換える
if which exa &>/dev/null; then
    alias ls='exa --color=auto --time-style=long-iso --icons --group --git'
    alias la='ls -a'
    alias ll='ls -l'
    alias li='ll -i'
    alias lla='ls -la'
    alias lai='lla -i'
    alias lt='ls -T'
else
    if ls --version &>/dev/null; then
        # gnu-ls
        alias ls="ls --color=auto --time-style='+%Y-%m-%d %H:%M'"
    else
        # bsd-ls
        alias ls="ls -GD '%Y-%m-%d %H:%M'"
    fi
    alias la='ls -A'
    alias ll='ls -l'
    alias lh='ll -h'
    alias li='ll -i'
    alias lla='ls -la'
    alias lah='lla -h'
    alias lai='lla -i'
fi

if which nvim &>/dev/null; then
    alias vi='nvim'
    alias vim='nvim'
    alias view='nvim -R'
fi

if type wezterm &>/dev/null; then
    alias imgcat='wezterm imgcat'
fi

### docker-compose
alias dco='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcv='docker-compose down && docker-compose up'
alias dce='docker-compose exec'
alias dcr='docker-compose run --user=${UID} --no-deps'
alias dcR='docker-compose run --user=${UID} --no-deps --rm'
