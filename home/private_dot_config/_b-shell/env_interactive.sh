export GPG_TTY=$TTY

if [[ -x /proc/$$/exe ]]; then
    export DOTS_ISHELL="$(readlink /proc/$$/exe)"
else
    export DOTS_ISHELL="$(lsof -ap$$ -dtxt -Fn | sed '3!d;s/.//;q')"
fi

