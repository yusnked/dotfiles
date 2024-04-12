# 補完機能を有効にする
autoload -Uz compinit
compinit -d "$DOTS_CACHE_HOME/zsh/.zcompdump"

# ^wで単語削除などをする際の単語の区切りを設定(word-charsで設定した以外の文字を全て単語の構成要素とみなす)
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /:@+|"
zstyle ':zle:*' word-style unspecified

# M-.で直前コマンドの最後の引数を取得する際に&などがあるとそれを拾ってしまうので、より適切な物を拾ってくれるように設定。
autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補を詰めて表示
setopt list_packed

# 補完候補一覧をカラー表示
autoload colors
zstyle ':completion:*' list-colors ''

# migemoでファイル補完
autoload -Uz _complete-migemo
zle -C complete-migemo menu-complete _complete-migemo
