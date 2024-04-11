#!/usr/bin/env bash

# {{ output "cat" "./extensions.txt" | comment "# " -}}
# {{ if lookPath "code" -}}
# vscode is installed!
# {{ end -}}

set -eu

if type code &>/dev/null; then
    errors=''
    while IFS='' read -r extension; do
        if [[ -n $extension ]]; then
            code --install-extension "$extension" || errors+="    $extension"$'\n'
        fi
    done <'./extensions.txt'

    if [[ -z $errors ]]; then
        printf '\n\033[1;32mINFO\033[0m: vscode: %s\n' 'All extensions have been installed.'
    else
        printf '\n\033[1;31mERROR\033[0m: vscode: %s\n%s' \
            'Installed the extensions, but an error occurred with the following installations:' \
            "$errors"
    fi
fi
