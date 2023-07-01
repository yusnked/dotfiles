# Need "typeset -Ux PATH path" before calling this function in zsh.
function add-2path() {
    local -r target_path="${1:?add-2path target_path [unshift/push [exists]]}"
    local -r method="${2:-unshift}"
    local -r check_exists="$3"

    if [[ -n $check_exists && ! -d $target_path ]]; then
        return 0
    fi

    local replaced_path="$PATH"
    if [[ -n $BASH_VERSION ]]; then
        replaced_path=":$replaced_path"
        replaced_path="${replaced_path//:$target_path/}"
        replaced_path=${replaced_path:1}

        if [[ $replaced_path != $PATH && $method == push ]]; then
            # Same as "typeset -U" behaviour.
            return 0
        fi
    fi

    case "$method" in
        unshift)
            PATH="$target_path:$replaced_path"
            ;;
        push)
            PATH="$replaced_path:$target_path"
            ;;
        *)
            return 1
            ;;
    esac
}

