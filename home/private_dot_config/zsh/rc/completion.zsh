# 補完機能を有効にする
autoload -Uz compinit
compinit -u

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

# AUTO_PARAM_KEYS: (デフォON) 補完時自動的に挿入されたカンマや空白などを}などを押すことで自動的に消すことができる。
#unsetopt AUTO_PARAM_KEYS

# cmigemoとfdを使用してローマ字でファイル名を補完 (濁音にマッチしない問題あり)
# function _cmigemo_complete_widget() {
#   local expl match_files
# 
#   match_files="$(fd $(cmigemo -d "$XDG_DATA_HOME/migemo-dict/utf-8/migemo-dict" -w "$PREFIX") -d1)"
# 
#   if [ ${#match_files[*]} -ne 0 ]; then
#     _wanted -V files expl "migemo search" compadd -U -- "${(f)match_files}"
#   fi
# }
# zle -C cmigemo-complete-widget menu-complete _cmigemo_complete_widget

