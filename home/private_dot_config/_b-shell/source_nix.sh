# Nix multi-user mode
if [ -r '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# Home-manager
if [ -r "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    source "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

