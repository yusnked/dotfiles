#!/usr/bin/env bash

# デフォルトはmultiでSELinuxが有効になっている環境ではsingle
# なのでlinuxでnixbldグループが存在しない場合にsingleと判定

user_mode='multi'
if [ "$(uname -s)" = 'Linux' ]; then
    if ! cat /etc/group | grep -q 'nixbld'; then
        user_mode='single'
    fi
fi

echo $user_mode

