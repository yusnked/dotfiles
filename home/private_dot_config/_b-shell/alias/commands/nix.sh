alias nix-hash-git="nix run 'nixpkgs#nix-prefetch-git' --"

function nprun() {
    local pname="${1}"
    shift
    nix run "nixpkgs#${pname}" -- "$@"
}

function npinstall() {
    local pname="${1}"
    shift
    nix profile install "nixpkgs#${pname}"
}

function home-manager() {
    case $1 in
    "upgrade")
        nix flake update --flake ~/.config/home-manager && nprun home-manager switch
        ;;
    *)
        nprun home-manager "$@"
        ;;
    esac
}
