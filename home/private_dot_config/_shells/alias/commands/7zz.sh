_alias_7zz_7za='7zz a -mx=9 -md=64M'
if [[ $DOTS_OS == Darwin ]]; then
    alias 7za="$_alias_7zz_7za -xr'!.DS_Store' -xr'!__MACOSX' -xr'!.AppleDouble' -xr'!.Spotlight-V100' -xr'!.fseventsd'"
else
    alias 7za="$_alias_7zz_7za"
fi
unset _alias_7zz_7za
