function path-add() {
    if [[ $# == 0 ]]; then
        cat <<END
path-add(): Add a path like typeset -agxUT PATH path in zsh

path-add [options] path1 [path2 ...]

OPTIONS
    --check-exists    -e -- Check for the existence of paths after this flag. (defualt)
    --no-check-exists -E -- Do not check for the existence of paths after this flag.
    --method          -m -- How to add a path. [unshift(defualt)|push]
    --target          -t -- Environment variable to add paths. (default: PATH)
END
        return 0
    fi

    local check_exists=1
    local method=unshift
    local target=PATH
    while [[ $# > 0 ]]; do
        case "$1" in
        --check-exists | -e)
            check_exists=1
            shift
            ;;
        --no-check-exists | -E)
            check_exists=0
            shift
            ;;
        --method | -m)
            shift
            case $1 in
            unshift | push)
                method=$1
                shift
                ;;
            *)
                echo Error: path-add: Unknown method "$1" >&2
                return 1
                ;;
            esac
            ;;
        --target | -t)
            shift
            [[ -z $1 ]] && continue
            if [[ -n $ZSH_VERSION ]]; then
                target=${(U)1}
            else
                target=${1^^}
            fi
            shift
            ;;
        *)
            local target_path="${1}"
            shift

            # Check exists.
            if [[ $check_exists == 1 && ! -d $target_path ]]; then
                continue
            fi

            # Export target.
            if eval \[\[ -z \$__path_add_exported_$target ]]; then
                if [[ -n $ZSH_VERSION ]]; then
                    eval typeset -agxUT $target ${(L)target}
                else
                    eval export $target
                fi
                eval __path_add_exported_$target=1
            fi

            # Remove duplicates.
            eval local unique_paths=\":\$${target}:\"
            if [[ -z $ZSH_VERSION && $unique_paths =~ :$target_path: ]]; then
                if [[ $method == push ]]; then
                    # Same as "typeset -U" behaviour.
                    local unique_paths_left="${unique_paths%%:$target_path:*}:"
                    local unique_paths_right=":${unique_paths#*:$target_path:}"
                    unique_paths_right="${unique_paths_right//:$target_path:/:}"
                    PATH="${unique_paths_left#:}$target_path${unique_paths_right%:}"
                    continue
                else
                    unique_paths="${unique_paths//:$target_path:/:}"
                fi
            fi

            # Add a path to the target.
            case "$method" in
            unshift)
                local temp="$target_path${unique_paths%:}"
                eval $target=\"${temp%:}\"
                ;;
            push)
                local temp="${unique_paths#:}$target_path"
                eval $target=\"${temp#:}\"
                ;;
            esac
            ;;
        esac
    done
}
