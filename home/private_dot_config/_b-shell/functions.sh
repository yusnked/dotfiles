# mkdirして作成したディレクトリにcdする
function mkcd() {
    command mkdir -p "$@" && for arg in "$@"; do
        [ -d "$arg" -a -x "$arg" ] && cd "$arg" && break 1
    done
}

# gitリポジトリのルートに移動
function cdr() {
    local git_root="$(git rev-parse --show-toplevel 2> /dev/null || true)"
    if [[ -n $git_root ]]; then
        cd "$git_root"
    else
        cd ~
    fi
}

# nixpkgs run
function nprun() {
    local pname="${1}"
    shift
    nix run "nixpkgs#${pname}" -- "$@"
}

# nixpkgs install
function npinstall() {
    local pname="${1}"
    shift
    nix profile install "nixpkgs#${pname}"
}

function nplist() {
    nix profile list | cut -d ' ' -f 1,4 --output-delimiter=' - '
}

# ANSI color
function ansi-color-8bit() {
    local code
    for code in {0..255}; do
        printf '\e[38;5;%dm%4d\e[m' $code $code
        if ((code % 16 == 15)); then
            printf '\n'
        fi
    done

    cat <<EOS

fg: \e[38;5;{n}m{text}\e[39m        bg: \e[48;5;{n}m{text}\e[49m
reset: \e[0m or \e[m               ESC: \e, \033 or \x1b
e.g.)
EOS

    echo -e ' \\e[38;5;123mhello world!\\e[0m -> \e[38;5;123mhello world!\e[0m'
    echo -e ' \\e[48;5;226m\\e[38;5;129mhello\\e[49m world!\\e[0m -> \e[48;5;226m\e[38;5;129mhello\e[49m world!\e[0m'
    echo -e '\nhttps://en.wikipedia.org/wiki/ANSI_escape_code#8-bit'
}

