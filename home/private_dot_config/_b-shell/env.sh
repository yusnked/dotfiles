### 言語設定
export LC_ALL=${LC_ALL:-ja_JP.UTF-8}
export LANG=${LANG:-ja_JP.UTF-8}

### XDG Base Directory
# ユーザー個別の設定が書き込まれるディレクトリ (/etc と類似)。
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
# ユーザー個別の重要でない (キャッシュ) データが書き込まれるディレクトリ (/var/cache と類似)。
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
# ユーザー個別のデータファイルが書き込まれるディレクトリ (/usr/share と類似)。
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
# ユーザー個別の状態ファイルをが書き込まれるディレクトリ (/var/lib と類似).
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export EDTOR=nvim

