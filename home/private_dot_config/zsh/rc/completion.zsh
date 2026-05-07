# fpath が全て追加された後にこのファイルを読み込むこと.
() {
    local cache_dir="$XDG_CACHE_HOME/zsh"

    # menu select を使うために必要. compinit より前にロードする必要あり.
    zmodload zsh/complist

    autoload -Uz compinit
    compinit -d "$cache_dir/zcompdump"

    zstyle ':completion:*' use-cache true
    zstyle ':completion:*' cache-path "$cache_dir/zcompcache"

    zstyle ':completion:*' completer _expand_alias _complete _match _prefix _ignored
    zstyle ':completion:*:prefix:*:*:*' completer _complete

    # 補完を smart-case 的にマッチさせ, 区切り文字や部分語での補完も試す.
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+r:|[-_./]=* r:|=*' \
        'm:{a-z}={A-Z} l:|=* r:|=*'
    zstyle ':completion:*:prefix:*:*:*' matcher-list 'm:{a-z}={A-Z}'

    # パス中の // を / と同じように扱う. (false なら // は /*/ と同じになる)
    zstyle ':completion:*' squeeze-slashes true

    # 既に存在するディレクトリ名はそのまま受け入れ, 余計な補完探索を避ける.
    zstyle ':completion:*' accept-exact-dirs true

    # ファイルの補完候補を新しい順に並べる.
    zstyle ':completion:*' file-sort modification

    # 候補一覧上で選択できるようにする.
    zstyle ':completion:*' menu select

    # 補完候補をグループごとにまとめる.
    zstyle ':completion:*' group-name ''

    # 補完候補の説明を表示する.
    zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

    # 補完候補がない場合の表示.
    zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

    # 補完候補を詳しく表示する.
    zstyle ':completion:*' verbose true

    # LS_COLORS を使う. なければ GNU ls 風のデフォルト色を使う.
    if [[ -n "${LS_COLORS-}" ]]; then
        zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
    else
        zstyle ':completion:*:default' list-colors ''
    fi
}

