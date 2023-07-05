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
    echo -e ' \\e[48;5;226;38;5;129mhello\\e[49m world!\\e[0m -> \e[48;5;226;38;5;129mhello\e[49m world!\e[0m'
    echo -e '\nhttps://en.wikipedia.org/wiki/ANSI_escape_code#8-bit'
}

function ansi-color-24bit() {
    local -r COUNT=$((${1:-6} - 1))
    if ! ((COUNT >= 1)); then
        echo 'Error: $1: The number of columns is an integer greater than or equal to 2' >&2
        return 1
    fi

    local -r MAX=255
    local -r INTERVAL=$((MAX / COUNT))
    local red=0 green=0 blue=0
    while ((blue <= MAX)); do
        [[ $blue == $((INTERVAL * COUNT)) ]] && blue=$MAX
        green=0
        while ((green <= MAX)); do
            [[ $green == $((INTERVAL * COUNT)) ]] && green=$MAX
            red=0
            while ((red <= MAX)); do
                if [[ $red == $((INTERVAL * COUNT)) ]];then
                    red=$MAX
                    printf '\e[38;2;%d;%d;%dm #%02X%02X%02X\e[m\n' $red $green $blue $red $green $blue
                else
                    printf '\e[38;2;%d;%d;%dm #%02X%02X%02X\e[m' $red $green $blue $red $green $blue
                fi
                red=$((red + INTERVAL))
            done
            green=$((green + INTERVAL))
        done
        blue=$((blue + INTERVAL))
    done

    cat <<EOS

fg: \e[38;2;{r};{g};{b}m{text}\e[39m
bg: \e[48;2;{r};{g};{b}m{text}\e[49m
reset: \e[0m or \e[m
ESC: \e, \033 or \x1b

e.g.)
EOS

    echo -e ' \\e[38;2;255;0;0mhello world!\\e[0m\n -> \e[38;2;255;0;0mhello world!\e[0m'
    echo -e ' \\e[48;2;0;153;153;38;2;255;0;0mhello\\e[49m world!\\e[0m\n -> \e[48;2;0;153;153;38;2;255;0;0mhello\e[49m world!\e[0m'
    echo -e '\nhttps://en.wikipedia.org/wiki/ANSI_escape_code#24-bit'
}

