### zsh-syntax-highlighting の色設定
# これ以上の文字数のコマンドラインをハイライトしない
typeset -x ZSH_HIGHLIGHT_MAXLENGTH=512
# 有効化するタイプライター main brackets pattern regexp cursor root line
typeset -x ZSH_HIGHLIGHT_HIGHLIGHTERS
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets regexp)

typeset -xA ZSH_HIGHLIGHT_STYLES
typeset -xA ZSH_HIGHLIGHT_REGEXP
() {
    local co_error='fg=197'
    local co_command='fg=040'
    local co_options='fg=087'
    local co_alias="$co_command,underline"
    local co_path='fg=087'
    local co_shell='fg=220'
    local co_builtin="$co_shell,underline"
    local co_pattern='fg=219'
    local co_command_sub='fg=141'
    local co_arithmetic='fg=039'
    local co_history="$co_command_sub"
    local co_quoted='fg=215'
    local co_sequence='fg=038'
    local co_arg='fg=087'
    local co_comment='fg=035'
    local co_default='fg=254'

    ## highlighters/main
    # unknown-token: 不明なトークンやエラー
    ZSH_HIGHLIGHT_STYLES[unknown-token]="$co_error"
    # reserved-word: シェルの予約後
    ZSH_HIGHLIGHT_STYLES[reserved-word]="$co_shell"
    # alias: エイリアス
    ZSH_HIGHLIGHT_STYLES[alias]="$co_alias"
    # suffix-alias: サフィックスエイリアス (zsh 5.1.1 以降が必要)
    ZSH_HIGHLIGHT_STYLES[suffix-alias]="$co_alias"
    # global-alias: グローバルエイリアス
    ZSH_HIGHLIGHT_STYLES[global-alias]="$co_alias"
    # builtin: シェル組み込みコマンド
    ZSH_HIGHLIGHT_STYLES[builtin]="$co_builtin"
    # function: 関数名
    ZSH_HIGHLIGHT_STYLES[function]='fg=099'
    # command: コマンド名
    ZSH_HIGHLIGHT_STYLES[command]="$co_command"
    # precommand: プリコマンド修飾子
    ZSH_HIGHLIGHT_STYLES[precommand]="$co_builtin"
    # commandseparator: コマンド区切り記号(; &&)
    ZSH_HIGHLIGHT_STYLES[commandseparator]="$co_shell"
    # hashed-command: ハッシュ化されたコマンド(?)
    ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=red"
    # autodirectory: AUTO_CD-オプションが設定されている場合のコマンド位置のディレクトリ名
    ZSH_HIGHLIGHT_STYLES[autodirectory]="$co_path"
    # path: 既存ファイル名
    ZSH_HIGHLIGHT_STYLES[path]="$co_path"
    # path_pathseparator: プリコマンド修ファイル名のパス区切り文字 ( /); 設定されていない場合pathと同じ設定になる。
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]="$co_white"
    # path_prefix: 既存のファイル名のプレフィックス
    ZSH_HIGHLIGHT_STYLES[path_prefix]="$co_error"
    # path_prefix_pathseparator: 既存のファイル名のプレフィックスのパス区切り ( /); 設定されていない場合path_prefixと同じ設定になる。
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]="$co_error"
    # globbing: グロビング式 ( *.txt)
    ZSH_HIGHLIGHT_STYLES[globbing]="$co_pattern"
    # history-expansion: 履歴展開式 (!fooと^foo^bar)
    ZSH_HIGHLIGHT_STYLES[history-expansion]="$co_history"
    # command-substitution: コマンド置換 $()
    ZSH_HIGHLIGHT_STYLES[command-substitution]="$co_command_sub"
    # command-substitution-unquoted: 引用符で囲まれていないコマンド置換
    ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]="$co_command_sub"
    # command-substitution-quoted: 引用されたコマンド置換
    ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]="$co_command_sub"
    # command-substitution-delimiter: コマンド置換区切り文字 $( および )
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]="$co_command_sub"
    # command-substitution-delimiter-unquoted: 引用符で囲まれていないコマンド置換区切り文字
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]="$co_command_sub"
    # command-substitution-delimiter-quoted: 引用符で囲まれたコマンド置換区切り文字
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]="$co_command_sub"
    # process-substitution: プロセス置換
    ZSH_HIGHLIGHT_STYLES[process-substitution]="$co_command_sub"
    # process-substitution-delimiter: プロセス置換区切り文字 <( )
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]="$co_command_sub"
    # arithmetic-expansion: 算術展開
    ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]="$co_arithmetic"
    # single-hyphen-option: ショートオプション
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="$co_options"
    # double-hyphen-option: ロングオプション
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="$co_options"
    # back-quoted-argument: バックティック コマンド置換
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="$co_command_sub"
    # back-quoted-argument-unclosed: 閉じていないバッククォート コマンド置換
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]="$co_command_sub"
    # back-quoted-argument-delimiter: バックティック コマンド置換区切り文字
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]="$co_command_sub"
    # single-quoted-argument: 一重引用符で囲まれた引数
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="$co_quoted"
    # single-quoted-argument-unclosed: 単一引用符で囲まれていない引数
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]="$co_quoted"
    # double-quoted-argument: 二重引用符で囲まれた引数
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="$co_quoted"
    # double-quoted-argument-unclosed: 二重引用符で囲まれていない引数
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]="$co_quoted"
    # dollar-quoted-argument: ドル引用符付きの引数
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="$co_quoted"
    # dollar-quoted-argument-unclosed: 閉じられていないドル引用符の引数
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]="$co_quoted"
    # rc-quote: RC_QUOTESオプションが設定されている場合の単一引用符内に 2 つの単一引用符( 'foo''bar')
    ZSH_HIGHLIGHT_STYLES[rc-quote]="$co_sequence"
    # dollar-double-quoted-argument: 二重引用符内のパラメーター展開 "$foo"
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="$co_arg"
    # back-double-quoted-argument: 二重引用符で囲まれた引数内のバックスラッシュ エスケープ シーケンス
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="$co_sequence"
    # back-dollar-quoted-argument: ドル引用符で囲まれた引数内のバックスラッシュ エスケープ シーケンス
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]="$co_sequence"
    # assign: 変数代入
    ZSH_HIGHLIGHT_STYLES[assign]="$co_arg"
    # redirection: リダイレクト演算子
    ZSH_HIGHLIGHT_STYLES[redirection]="$co_shell"
    # comment: コメント、setopt INTERACTIVE_COMMENTS有効な場合
    ZSH_HIGHLIGHT_STYLES[comment]="$co_comment"
    # named-fd: 名前付きファイル記述子 (echo foo {fd}>&2 の fd)
    ZSH_HIGHLIGHT_STYLES[named-fd]="$co_shell"
    # numeric-fd: 数値ファイル記述子 (echo foo {fd}>&2 の 2)
    ZSH_HIGHLIGHT_STYLES[numeric-fd]="$co_shell"
    # arg0: 上に列挙したもの以外のコマンド ワード
    ZSH_HIGHLIGHT_STYLES[arg0]="$co_default"
    # default: それ以外の全て
    ZSH_HIGHLIGHT_STYLES[default]="$co_default"

    ## highlighters/brackets
    # cursor-matchingbracket: カーソルがブラケット上にある場合、対応するブラケット
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'
    # bracket-error: 一致しないカッコ
    ZSH_HIGHLIGHT_STYLES[bracket-error]="$co_error"
    # bracket-level-1: ネストレベル 1 のカッコ
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]="$co_shell"
    # bracket-level-2: ネストレベル 2 のカッコ
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]="$co_comment"
    # bracket-level-3: ネストレベル 3 のカッコ
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]="$co_arg"
    # bracket-level-4: ネストレベル 4 のカッコ
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=213"

    # highlighters/regexp
    # $var
    ZSH_HIGHLIGHT_REGEXP+=('\$[!#$*@?_-]' "$co_arg")
    ZSH_HIGHLIGHT_REGEXP+=('\$[#^=~+]?[A-Za-z][0-9A-Za-z_]*' "$co_arg")
    # ${var}
    ZSH_HIGHLIGHT_REGEXP+=('\$\{[!#$*@?_-]\}' "$co_arg")
    ZSH_HIGHLIGHT_REGEXP+=('\$\{[#^=~+]?[A-Za-z][0-9A-Za-z_]*(\[(-?[1-9][0-9]*|0|\*|@)\])?\}' "$co_arg")
    ZSH_HIGHLIGHT_REGEXP+=('\$\{[A-Za-z_][0-9A-Za-z_]*(\[(-?[1-9][0-9]*|0|\*|@)\])?((:?[-=+?]|::=|(#{1,2}[^#]|%{1,2}[^%]|/{1,2}[^/]))[^}]*)?\}' "$co_arg")
}

source "$NIX_DATA_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

