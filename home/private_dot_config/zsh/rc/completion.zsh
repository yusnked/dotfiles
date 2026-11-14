# ==========================================================
# Completion options
# ==========================================================

# 補完で完全な候補を挿入した後, カーソルを単語末尾へ移動する.
# setopt ALWAYS_TO_END

# 曖昧補完時, 補完候補一覧を自動的に表示しない.
unsetopt AUTO_LIST

# 絶対パスを値に持つパラメータを, 自動的に named directory として扱う.
# setopt AUTO_NAME_DIRS

# 曖昧補完時, 1 回目では候補一覧を表示せず, 連続 2 回目の補完で表示する.
# setopt BASH_AUTO_LIST

# alias を展開せず, alias 自体を補完対象として扱う.
# setopt COMPLETE_ALIASES

# 補完開始時にカーソルを単語末尾へ移動せず, カーソル位置の前後を使って補完する.
setopt COMPLETE_IN_WORD

# _complete で glob パターンを考慮して補完する.
# setopt GLOB_COMPLETE

# 曖昧補完時に BEL を鳴らさない.
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

# cache-path のディレクトリは存在しなくても自動生成される.
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# _expand はコマンドの補完文脈を考慮せず、グロブ展開などを先に試す.
# そのためグロブ展開はパス補完専用と割り切り _match は使用しない.
zstyle ':completion:*' completer _expand_alias _expand _complete _ignored _complete_migemo
zstyle ':completion:*:ignored:*:*:*' completer _complete

# matcher-list は completer ごとに先頭から順番に試行される.
# _main_complete は各試行の規則を _matcher に設定するが, 入力自体は変換しない.
# _description などを通じて compadd -M に渡され, 候補の照合時に適用される.
#
# マッチング規則:
#   m:word-pat=match-pat         文字の対応関係を定義する.
#   l:anchor|word-pat=match-pat  anchor を左側として右側の word-pat を match-pat に対応させる.
#   r:word-pat|anchor=match-pat  anchor を右側として左側の word-pat を match-pat に対応させる.
#
#   anchor が空の場合 l: は左端 r: は右端が anchor になる.
#
# matcher-list の各要素は独立しており, + で始めた場合のみ前の規則を引き継ぐ.
() {
    # 小文字の入力を対応する大文字の候補にも一致させる.
    local smart_case='m:{a-z}={A-Z}'

    local -a matcher_list=(
        # 1回目: smart case の前方一致.
        "$smart_case"

        # 2回目: 区切り文字の直前と右端に * を補ったかのように一致させる.
        # 例: f-b -> foo-bar
        "$smart_case r:|[-_./]=* r:|=*"

        # 3回目: 左端と右端に * を補ったかのように一致させる.
        # 例: bar -> foobar.txt
        "$smart_case l:|=* r:|=*"
    )

    # 通常補完は3段階で試し, その他は1段階だけ試す.
    zstyle ':completion:*:complete:*:*:*' matcher-list "${matcher_list[@]}"
    zstyle ':completion:*' matcher-list "$smart_case"
}

# パス中の // を / と同じように扱う (false なら // は /*/ と同じになる).
zstyle ':completion:*' squeeze-slashes true

# 既存のディレクトリ名はそのまま受け入れ, 不要な補完探索を避ける.
zstyle ':completion:*' accept-exact-dirs true

# ファイルの補完候補を新しい順に並べる.
zstyle ':completion:*' file-sort modification

# 補完候補をグループごとにまとめる.
zstyle ':completion:*' group-name ''

# ~ 補完では named directory をユーザー名より先に表示する.
zstyle ':completion:*:complete:-tilde-:*' group-order named-directories users directory-stack

# 補完候補の説明を表示する.
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'

# 補完候補がない場合に表示するメッセージ.
zstyle ':completion:*:warnings' format '%F{yellow}-- no matches found --%f'

# 補完候補の詳細情報を表示する.
zstyle ':completion:*' verbose true

# cd/chdir/pushd で - から始まるときもオプション補完を候補に含める.
zstyle ':completion:*:options' complete-options true

# LS_COLORS を使う. なければ GNU ls 風のデフォルト色を使う.
if [[ -n "${LS_COLORS-}" ]]; then
    # LS_COLORS の no による文字色が, メニュー補完の選択色にも影響する.
    # ma (選択候補の色) は未指定時に 7 (前景色と背景色の反転) が使われるが,
    # 再描画時に直前の色属性が残り, 上下の移動方向で背景色が変わることがある.
    # ma=0;7 で色属性をリセットしてから反転することで, この問題を回避する.
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=0;7'
else
    zstyle ':completion:*:default' list-colors ''
fi

# メニュー補完を有効にする.
# zsh/complist は compinit より前にロードする必要がある.
zmodload zsh/complist
zstyle ':completion:*' menu auto select
