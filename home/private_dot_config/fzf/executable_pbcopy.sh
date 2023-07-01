#!/usr/bin/env bash -eu

if [[ $(uname -s) == Darwin ]]; then
    echo -n "$@" | pbcopy
else
    echo -n "$@" | xsel -b
fi

