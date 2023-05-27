#!/usr/bin/env bash

# Referenced to: https://nixos.org/manual/nix/stable/installation/installing-binary.html
# 公式インストーラーでインストールした場合のアンインストールスクリプト

function restore_etc_files_from_backup() {
    local etc_dir="$(readlink -f /etc)"

    for etc_file in $(sudo find "${etc_dir:-/etc}" -name '*.backup-before-nix' -type f); do
        echo "Do you want to run"
        echo -n "\"sudo mv $etc_file ${etc_file%.backup-before-nix}\" [y/n]: "
        read input

        if [[ $input =~ ^[yY](es)? ]]; then
            sudo mv "$etc_file" "${etc_file%.backup-before-nix}"
        fi
    done
}

kernel_name=$(uname -s)
if [ "$kernel_name" = 'Darwin' ]; then

    # Nixデーモンサービスを停止して削除
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
    sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
    sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist

    # nixbldグループと_nixbuildNユーザーを削除
    sudo dscl . -delete /Groups/nixbld
    for u in $(sudo dscl . -list /Users | grep _nixbld); do
        sudo dscl . -delete /Users/$u
    done

    # vifsで/etc/fstabから Nix Store ボリュームの自動マウント設定を削除
    while true; do
        fstab_line=$(grep -e ' /nix apfs ' /etc/fstab)
        if [ -z "$fstab_line" ]; then
            break
        fi

        cat <<-EOF
Run sudo vifs.
Please remove the line:
"$fstab_line"

Press any key...
EOF
        read

        sudo vifs
    done

    # /etc/synthetic.confからnixの行を削除
    # これによりマウントポイント用の空の /nix ディレクトリの自動生成を停止
    target_file='/etc/synthetic.conf'
    temp_file="$(mktemp)"
    sed '/^nix$/d' "$target_file" > "$tempfile"
    sudo mv "$tempfile" "$target_file"
    sudo chown 'root:wheel' "$target_file"
    sudo chmod 644 "$target_file"

    # /etc/synthetic.confが empty file なら削除
    synthetic_contents=$(cat /etc/synthetic.conf)
    if [ -z "$synthetic_contents" ]; then
        sudo rm /etc/synthetic.conf
    fi

    # Nix store volume を削除
    sudo diskutil apfs deleteVolume /nix

    # Nix によって作成されたファイルの削除
    sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels \
        ~/.nix-profile ~/.nix-defexpr ~/.nix-channels

    # Nixによって書き換えられた/etc以下の設定ファイルがあれば戻す
    restore_etc_files_from_backup

elif [ "$kernel_name" = 'Linux' ]; then

    # Nix デーモンサービスを削除
    sudo systemctl stop nix-daemon.service
    sudo systemctl disable nix-daemon.socket nix-daemon.service
    sudo systemctl daemon-reload

    # systemd サービスファイルを削除
    sudo rm /etc/systemd/system/nix-daemon.service /etc/systemd/system/nix-daemon.socket
    sudo rm /etc/tmpfiles.d/nix-daemon.conf

    # Nixによって作成されたファイルを削除
    sudo rm -rf /nix /etc/nix /etc/profile/nix.sh /etc/profile.d/nix.sh ~root/.nix-profile ~root/.nix-defexpr \
        ~root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels

    # ビルドユーザーとそのグループを削除
    for i in $(seq 1 32); do
        sudo userdel nixbld$i
    done
    sudo groupdel nixbld

    # Nixによって書き換えられた/etc以下の設定ファイルがあれば戻す
    restore_etc_files_from_backup
fi

