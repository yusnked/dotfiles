function code-install-extensions() {
    local extensions_file
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        extensions_file="$(git rev-parse --show-toplevel)/.vscode/extensions.json"
    else
        extensions_file="$PWD/.vscode/extensions.json"
    fi
    local -r extensions_file

    if [[ ! -f $extensions_file ]]; then
        printf '\033[1;31mERROR\033[0m: %s\n' "No such file: $extensions_file" >&2
        return 1
    fi

    # Processing assumes that the Extension ID does not contain spaces.
    local -r lf=$'\n' tab=$'\t'
    local extensions_file_content extensions extension
    extensions_file_content="$(cat "$extensions_file")"

    # Remove all spaces and comments.
    while IFS='' read -r extension; do
        extensions+="${extension%%//*}$lf"
    done < <(printf '%s' "${extensions_file_content//[$tab ]/}")

    # Extract the values from recommendations at the end of the file and replace commas with newlines.
    extensions="${extensions##*\"recommendations\":\[}"
    extensions="${extensions%%\]*}"
    extensions="${extensions//,/"$lf"}"

    local errors ret
    while IFS='' read -r extension; do
        extension="${extension#*\"}"
        extension="${extension%\"*}"
        if [[ -n $extension ]]; then
            code --install-extension "$extension"
            ret="$?"
            [[ $ret -ne 0 ]] && errors+="    $extension$lf"
        fi
    done < <(printf '%s' "$extensions")

    if [[ -z $errors ]]; then
        printf '\n%s\n' 'All recommended extensions have been installed.'
    else
        printf '\n\033[1;31mERROR\033[0m: %s\n%s' \
            'Installed the extensions, but an error occurred with the following installations:' \
            "$errors"
        return 1
    fi
}
