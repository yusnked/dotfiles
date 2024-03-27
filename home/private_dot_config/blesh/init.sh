bleopt prompt_eol_mark=$'\033[1;7m%\033[m'
bleopt exec_errexit_mark=''
bleopt exec_elapsed_mark=''

# Disable autocomplete
bleopt complete_auto_complete=''

# Hooks
blehook "PRECMD!=__prompt_osc133_precmd"
blehook "PREEXEC!=__prompt_osc133_preexec"
_prompt_pipestatus_message='pipestatus: '
function __prompt_pipestatus_precmd() {
    _prompt_pipestatus_ret=$?
    if [[ __prompt_pipestatus_executing -eq 1 ]]; then
        if [[ ${#BLE_PIPESTATUS[@]} -eq 1 ]]; then
            __prompt_pipestatus "$_prompt_pipestatus_ret"
        else
            __prompt_pipestatus "${BLE_PIPESTATUS[@]}"
        fi
        printf '%s\n' "$_prompt_pipestatus_var"
        __prompt_pipestatus_executing=''
    else
        _prompt_pipestatus_var=''
    fi
    __prompt_pipestatus_executing=''
}
function __prompt_pipestatus_preexec() {
    __prompt_pipestatus_executing=1
}
blehook "PRECMD!=__prompt_pipestatus_precmd"
blehook "PREEXEC!=__prompt_pipestatus_preexec"
