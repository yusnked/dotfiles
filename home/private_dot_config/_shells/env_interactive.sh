export RUNEWIDTH_EASTASIAN=0
export GPG_TTY="$TTY"
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"

if [[ -x /proc/$$/exe ]]; then
    DOTS_ISHELL="$(readlink /proc/$$/exe)"
else
    DOTS_ISHELL="$(lsof -ap$$ -dtxt -Fn | sed '3!d;s/.//;q')"
fi
export DOTS_ISHELL
