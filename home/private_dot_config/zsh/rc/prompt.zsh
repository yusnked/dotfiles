autoload -Uz add-zsh-hook

# OSC 133
_prompt_executing=""
function __osc133_precmd() {
    local ret="$?"
    if test "$_prompt_executing" != "0"; then
        _PROMPT_SAVE_PS1="$PS1"
        _PROMPT_SAVE_PS2="$PS2"
        PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
        PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
    fi

    if test "$_prompt_executing" != ""; then
        printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
    fi
    printf "\033]133;A;cl=m;aid=%s\007" "$$"
    _prompt_executing=0
}

function __osc133_preexec() {
    PS1="$_PROMPT_SAVE_PS1"
    PS2="$_PROMPT_SAVE_PS2"
    printf "\033]133;C;\007"
    _prompt_executing=1
}
add-zsh-hook precmd __osc133_precmd
add-zsh-hook preexec __osc133_preexec

# git
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }

autoload -Uz _prompt-truncated-path

function _prompt-shlvl() {
    if [[ $SHLVL != 1 ]]; then
        print "$SHLVL"
    fi
}

function toggle-prompt() {
    local -r file="$XDG_STATE_HOME/zsh/no_arrow_prompt"
    if [[ -e $file ]]; then
        rm "$file"
    else
        touch "$file"
    fi
    exec zsh
}

# '' 0xe0b0 Solid Right Arrow
# '' 0xe0b1 Right Arrow
# '' 0xe0b2 Solid Left Arrow
# '' 0xe0b3 Left Arrow

if ! [[ -e "$XDG_STATE_HOME/zsh/no_arrow_prompt" ]]; then
    # Arrow prompt
    PROMPT=$'
%{\e[38;5;243m\e[1;38;5;231;48;5;243m%T\e[38;5;243;48;5;23m $(_prompt-truncated-path 50 231 220) \e[38;5;23;48;5;220m\e[38;5;232m$(_prompt-shlvl)\e[38;5;220;49m \e[m%F{cyan}$vcs_info_msg_0_%f%}
%F{220}${mode_stat:- }%f%B%(?|%F{040}|%F{197})%#%f%b '
else
    # Non Arrow prompt
    PROMPT='
%B%F{243}<%T>%f%b $(_prompt-truncated-path 50 2 3) %F{220}$(_prompt-shlvl)%f %F{cyan}$vcs_info_msg_0_%f
%F{220}${mode_stat:- }%f%B%(?|%F{040}|%F{197})%#%f%b '
fi

autoload -Uz _prompt-pipestatus
add-zsh-hook precmd _prompt-pipestatus
RPROMPT='$_prompt_pipestatus_var'

##### <エスケープシーケンス>
## prompt_bang が有効な場合、!=現在の履歴イベント番号, !!='!' (リテラル)
# ${WINDOW:+"[$WINDOW]"} = screen 実行時にスクリーン番号を表示 (prompt_subst が必要)
# %/ or %d = ディレクトリ (0=全て, -1=前方からの数)
# %~ = ディレクトリ
# %h or %! = 現在の履歴イベント番号
# %L = 現在の $SHLVL の値
# %M = マシンのフルホスト名
# %m = ホスト名の最初の `.' までの部分
# %S (%s) = 突出モードの開始 (終了)
# %U (%u) = 下線モードの開始 (終了)
# %B (%b) = 太字モードの開始 (終了)
# %t or %@ = 12 時間制, am/pm 形式での現在時刻
# %n or $USERNAME = ユーザー ($USERNAME は環境変数なので setopt prompt_subst が必要)
# %N = シェル名
# %i = %N によって与えられるスクリプト, ソース, シェル関数で, 現在実行されている行の番号 (debug用)
# %T = 24 時間制での現在時刻
# %* = 24 時間制での現在時刻, 秒付き
# %w = `曜日-日' の形式での日付
# %W = `月/日/年' の形式での日付
# %D = `年-月-日' の形式での日付
# %D{string} = strftime 関数を用いて整形された文字列 (man 3 strftime でフォーマット指定が分かる)
# %l = ユーザがログインしている端末から, /dev/ プレフィックスを取り除いたもの
# %y = ユーザがログインしている端末から, /dev/ プレフィックスを取り除いたもの (/dev/tty* はソノママ)
# %? = プロンプトの直前に実行されたコマンドのリターンコード
# %_ = パーサの状態
# %E = 行末までクリア
# %# = 特権付きでシェルが実行されているならば `#', そうでないならば `%' == %(!.#.%%)
# %v = psvar 配列パラメータの最初の要素の値
# %{...%} = リテラルのエスケープシーケンスとして文字列をインクルード
# %(x.true-text.false-text) = 三つ組の式。区切り文字はなんでも良い。xに指定できるものは下記参照。
# %<string<, %>string>, %[xstring] = プロンプトの残りの部分に対する, 切り詰めの振る舞い
#         `<' の形式は文字列の左側を切り詰め, `>' の形式は文字列の右側を切り詰めます
# %c, %., %C = $PWD の後ろ側の構成要素

##### PROMPT変数%()で使える条件文字
# ! 特権ユーザか
# # 実効ユーザ ID が n か
# g 実効グループ ID が n か
# ? 直前のコマンドの終了コードが n か
# _ シェルの制御構文が n段以上か
# C カレントディレクトリの絶対パスにスラッシュが n個以上あるか
# /
#
# c
# . %~ の先頭部分置換を行なった結果にスラッシュが n個以上あるか
# ~
#
# D 月を表す数値（1 月 =0） が n に等しいか
# d 日を表す数値が n に等しいか
# j 現在のジョブ数が n以上か
# L $SHLVL の値が n以上か
# l その時点までに出力されている文字数が n以上か
# S $SECONDS （252 ページ） の値が n以上か
# T 時を表す数値が n に等しいか
# t 秒を表す数値が n に等しいか
# v 配列変数psvar の要素数が n以上か
# w 日曜を 0 として曜日を表す数値が n か 

##### 指定できる色
# black   0
# red     1
# green   2
# yellow  3
# blue    4
# magenta 5
# cyan    6
# white   7

