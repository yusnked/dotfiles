#!/usr/bin/env bash

# install Nix (multi-user)
# 公式インストールスクリプトを使ってマルチユーザーインストール

install_url='https://nixos.org/nix/install'

if which nix >/dev/null; then
    exit 0
fi

# NIX_INSTALLER_NO_MODIFY_PROFILEを設定すると/etc/.{bashrc,zshrc}等への書き込みを抑制できる
# と思っていたがsingle userのみ有効らしい。
kernel_name=$(uname -s)
if [ $kernel_name == 'Darwin' ]; then
    curl -L "$install_url" | sh
elif [ $kernel_name == 'Linux' ]; then
    curl -L "$install_url" | sh -s -- --daemon
fi

# 設定ファイルを変更して欲しくない為の苦肉の策
# 書き換えられた端からbackupファイルで上書きする
etc_dir="$(readlink -f /etc)"
for etc_file in $(sudo find "${etc_dir:-/etc}" -name '*.backup-before-nix' -type f); do
    sudo mv "$etc_file" "${etc_file%.backup-before-nix}" &&
        echo "Run \"sudo mv $etc_file ${etc_file%.backup-before-nix}\""
done
