alias \
    alz='autoload -Uz'

autoload -Uz \
    cdr \
    mkcd

if (( $+commands[7zz] )); then
    alias 7za="7zz a -mx=9 -md=64M -xr'!.DS_Store' -xr'!__MACOSX' -xr'!.AppleDouble' -xr'!.Spotlight-V100' -xr'!.fseventsd'"
fi

if (( $+commands[chezmoi] )); then
    alias chezmoi-reset-once='chezmoi state delete-bucket --bucket=scriptState'
    autoload -Uz chezmoi-toggle
fi

if (( $+commands[eza] )); then
    alias ls='eza --color --icons --hyperlink --group-directories-first --group --git --time-style="+%y/%m/%d %H:%M"'
elif ls --version &>/dev/null; then
    # GNU ls
    alias ls="ls -hF --color=auto --time-style='+%Y-%m-%d %H:%M'"
else
    # BSD ls
    alias ls="ls -hF -G -D '%Y-%m-%d %H:%M'"
fi
alias \
    la='ls -A' \
    ll='ls -l' \
    li='ll -i' \
    lla='ll -A' \
    lai='lla -i'

if (( $+commands[ghq] )); then
    autoload -Uz ghq-cd
fi

if (( $+commands[gpg] )); then
    alias gpg-kill='gpgconf --kill gpg-agent'
fi

if (( $+commands[nvim] )); then
    alias \
        vi='nvim' \
        view='nvim -R'
fi

if (( $+commands[xsel] )); then
    alias \
        pbcopy='xsel --clipboard --input' \
        pbpaste='xsel --clipboard --output'
fi
