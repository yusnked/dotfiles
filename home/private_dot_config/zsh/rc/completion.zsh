# ==========================================================
# Completion options
# ==========================================================

# 補完で完全な候補を挿入した後, カーソルを単語末尾へ移動する.
# setopt ALWAYS_TO_END

# 絶対パスを値に持つパラメータを, 自動的に named directory として扱う.
# setopt AUTO_NAME_DIRS

# 曖昧補完時, 1回目では候補一覧を出さず, 2回連続の補完で一覧を表示する.
# setopt BASH_AUTO_LIST

# alias を展開せず, alias 自体を補完対象として扱う.
# setopt COMPLETE_ALIASES

# 補完開始時にカーソルを単語末尾へ移動せず, カーソル位置の前後を使って補完する.
setopt COMPLETE_IN_WORD

# glob パターンを含む語を, 即展開せず補完候補として扱う.
setopt GLOB_COMPLETE

# 曖昧補完時にビープ音を鳴らさない.
unsetopt LIST_BEEP

# 補完候補一覧を詰めて表示する.
setopt LIST_PACKED

# 補完候補一覧を列優先ではなく行優先で表示する.
# setopt LIST_ROWS_FIRST

# 曖昧補完時, 候補一覧を出す代わりに最初の候補を即挿入する.
# setopt MENU_COMPLETE

# 入力文字列が補完候補と完全一致する場合, より長い候補があってもその候補を採用する.
# setopt REC_EXACT


# ==========================================================
# Completion Styles
# ==========================================================

zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

zstyle ':completion:*' completer _expand_alias _complete _match _prefix _ignored
zstyle ':completion:*:prefix:*:*:*' completer _complete

# 補完を smart-case 的にマッチさせ, 区切り文字や部分語での補完も試す.
zstyle ':completion:*' matcher-list \
    'm:{a-z}={A-Z}' '+r:|[-_./]=* r:|=*' 'm:{a-z}={A-Z} l:|=* r:|=*'
zstyle ':completion:*:prefix:*:*:*' matcher-list 'm:{a-z}={A-Z}'

# パス中の // を / と同じように扱う. (false なら // は /*/ と同じになる)
zstyle ':completion:*' squeeze-slashes true

# 既に存在するディレクトリ名はそのまま受け入れ, 余計な補完探索を避ける.
zstyle ':completion:*' accept-exact-dirs true

# ファイルの補完候補を新しい順に並べる.
zstyle ':completion:*' file-sort modification

# 補完候補をグループごとにまとめる.
zstyle ':completion:*' group-name ''

# 補完候補の説明を表示する.
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# 補完候補がない場合の表示.
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# 補完候補を詳しく表示する.
zstyle ':completion:*' verbose true

# cd/chdir/pushd で - から始まるときもオプション補完を候補に含める.
zstyle ':completion:*:options' complete-options true

# LS_COLORS を使う. なければ GNU ls 風のデフォルト色を使う.
if [[ -n "${LS_COLORS-}" ]]; then
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
else
    zstyle ':completion:*:default' list-colors ''
fi

# メニュー補完を有効にする.
# zsh/complist は compinit より前にロードする必要あり.
zmodload zsh/complist
zstyle ':completion:*' menu select
