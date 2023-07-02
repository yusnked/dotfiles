function zvm_config() {
    # 常にインサートモードからスタートするようにする。
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    # 遅延キーバインドを有効にする。normalとvisualモードのキーバインドを最初にnormalモードに入った時まで遅延する。
    ZVM_LAZY_KEYBINDINGS=true
}

# 遅延キーバインドが有効になっている場合、normalとvisualモードにキーバインドしたい場合はこの関数内でbindする。
# function zvm_after_lazy_keybindings() {

# }

# zsh-vi-modeがモード変更したときに実行される関数
function zvm_after_select_vi_mode() {
    #プロンプトに現在のコマンドモードを表示する用の変数
    typeset -g mode_stat
    case $ZVM_MODE in
        $ZVM_MODE_NORMAL)
            mode_stat='n'
            ;;
        $ZVM_MODE_INSERT)
            mode_stat=' '
            ;;
        $ZVM_MODE_VISUAL)
            mode_stat='v'
            ;;
        $ZVM_MODE_VISUAL_LINE)
            mode_stat='V'
            ;;
        $ZVM_MODE_REPLACE)
            mode_stat='r'
            ;;
    esac
}

source "$NIX_DATA_DIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

