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

