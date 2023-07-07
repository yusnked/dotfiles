# Bash or Zsh
function __generate_flatpak_app_func() {
    if ! which flatpak &> /dev/null ; then
        return 0
    fi

    for app_id in $(flatpak list --app --columns=application); do
        local app_name=${app_id##*.}

        which $app_name &> /dev/null && continue
        alias $app_name &> /dev/null && continue

        eval "function $app_name() { flatpak run $app_id \"\$@\"; }"
    done
}
__generate_flatpak_app_func
unset -f __generate_flatpak_app_func

