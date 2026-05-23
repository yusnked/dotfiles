# ==========================================================
# Changing Directories
# ==========================================================

# ディレクトリ名だけで cd する.
setopt AUTO_CD

# /で始まらない存在しないディレクトリ名を~展開(名前付きディレクトリ)する.
setopt CDABLE_VARS

# cd 履歴を自動でディレクトリスタックに積む.
# setopt AUTO_PUSHD

# ディレクトリスタックの重複を避ける.
setopt PUSHD_IGNORE_DUPS

# pushd/popd で毎回スタックを表示しない.
setopt PUSHD_SILENT

# cd - などで移動先を表示しない.
setopt CD_SILENT

# cd コマンドの検索パスを指定するディレクトリの配列.
# cdpath=()

# ディレクトリスタックの最大保持数.
DIRSTACKSIZE=20


# ==========================================================
# Expansion and Globbing
# ==========================================================

# zsh の強力な glob 拡張を有効化する.
setopt EXTENDED_GLOB

# * を . で始まる隠しファイルにもマッチさせる. 常時 *(D) 状態.
# setopt GLOB_DOTS

# **/* を ** と短く書けるようにする.
# setopt GLOB_STAR_SHORT

# 履歴修飾子 :s/:& の置換対象を文字列ではなくパターンとして扱う.
# setopt HIST_SUBST_PATTERN

# @(...) *(...) +(...) ?(...) !(...) 形式の ksh 風グロブを使う.
# setopt KSH_GLOB

# 引数中の name=... の ... にある ~ や =cmd を展開する.
setopt MAGIC_EQUAL_SUBST

# グロブ展開の結果がディレクトリだった場合, 末尾に / を付ける.
setopt MARK_DIRS

# 数値を含むファイル名を自然順に並べる. 常時 *(n) 状態.
setopt NUMERIC_GLOB_SORT

# =~ で PCRE ライブラリの Perl 互換の正規表現を使用する.
# setopt REMATCH_PCRE

# 関数内で暗黙的なグローバル変数を警告する.
# setopt WARN_CREATE_GLOBAL

# 関数内で「外側スコープの既存変数」を上書きしたら警告する.
# setopt WARN_NESTED_VAR


# ==========================================================
# History
# ==========================================================

# 履歴に開始時刻と実行時間を保存する.
setopt EXTENDED_HISTORY

# 履歴が上限に達したとき, 一意な履歴より古い重複履歴を先に削除する.
setopt HIST_EXPIRE_DUPS_FIRST

# 履歴ファイルの書き込みロックに fcntl(2) を使う.
setopt HIST_FCNTL_LOCK

# 履歴検索で, すでに見つかったものと同じ行を重複表示しない.
setopt HIST_FIND_NO_DUPS

# 過去の同一コマンドを消して履歴を一意化する. 古い方が削除される.
# setopt HIST_IGNORE_ALL_DUPS

# 直前と同じコマンドは履歴に追加しない.
setopt HIST_IGNORE_DUPS

# 先頭スペース付きのコマンドは履歴に残さない.
setopt HIST_IGNORE_SPACE

# 履歴展開の単語参照を正確にするため, 履歴読込時にシェル風に単語分割する.
# setopt HIST_LEX_WORDS

# インタラクティブに定義した関数は履歴に残さない.
# setopt HIST_NO_FUNCTIONS

# fc -l で履歴を見たこと自体は履歴に残さない.
setopt HIST_NO_STORE

# 履歴に追加するコマンド行の余分な空白を詰める.
setopt HIST_REDUCE_BLANKS

# ヒストリファイルに保存するときに重複したコマンドラインを削除する.
# setopt HIST_SAVE_NO_DUPS

# 履歴展開を即実行せず, 展開後の内容を編集バッファで確認する.
setopt HIST_VERIFY

# INC_APPEND_HISTORY, INC_APPEND_HISTORY_TIME, SHARE_HISTORY は排他的オプション.
# コマンド終了後に履歴へ追記し, EXTENDED_HISTORY の実行時間を正しく記録する.
setopt INC_APPEND_HISTORY_TIME

# ヒストリファイルのパス. (デフォルトは ~/.zsh_history)
HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"

# メモリ上のヒストリの最大イベント数.
HISTSIZE=75000

# ヒストリファイルに保存する最大数.
SAVEHIST=50000


# ==========================================================
# Input/Output
# ==========================================================

# > リダイレクトで既存ファイルを上書きできないようにする.
# unsetopt CLOBBER

# NO_CLOBBER 時に空の通常ファイルは > で上書きできるようにする.
# setopt CLOBBER_EMPTY

# コマンド名のスペルミスを実行前に補正候補として提示する.
# setopt CORRECT

# 引数を含むすべての単語をスペル補正対象にする.
# setopt CORRECT_ALL

# ^S/^Q による出力停止・再開をシェルの行編集で無効にする.
unsetopt FLOW_CONTROL

# Ctrl-D だけではシェルを終了せず exit や logout を要求する.
setopt IGNORE_EOF

# インタラクティブシェルでも # 以降をコメントとして扱う.
setopt INTERACTIVE_COMMENTS

# コマンドの場所を記憶するときに, 実行可能ファイルだけを対象にする.
# setopt HASH_EXECUTABLES_ONLY

# シングルクォート文字列内の '' を単一の ' として扱う.
# setopt RC_QUOTES

# rm * や rm path/* の実行前に確認しない.
# setopt RM_STAR_SILENT

# rm * や rm path/* の確認前に10秒待ち, その間の入力を無視する.
# setopt RM_STAR_WAIT

# スペル補正の候補から除外するコマンド名パターン.
# CORRECT_IGNORE=''

# スペル補正の候補から除外するファイル名パターン.
# CORRECT_IGNORE_FILE=''


# ==========================================================
# Job Control
# ==========================================================

# disown した停止中ジョブを自動で再開する.
# setopt AUTO_CONTINUE

# 単語1つだけのコマンドを停止中ジョブの再開候補として扱う.
# setopt AUTO_RESUME

# バックグラウンドジョブを通常優先度で実行する.
# unsetopt BG_NICE

# ジョブ状態通知をデフォルトで詳細形式にする.
setopt LONG_LIST_JOBS

# bg ジョブの状態変化を即時通知せず, 次のプロンプト直前まで遅らせる.
# unsetopt NOTIFY

# 指定秒数以上かかったコマンドの実行時間を自動表示する.
# REPORTTIME=10

# time/REPORTTIME で表示する実行時間の形式.
# TIMEFMT=$'%J  %U user %S system %P cpu %*E total'


# ==========================================================
# Scripts and Functions
# ==========================================================

# 16進数や8進数(OCTAL_ZEROES 必要)を C 言語風の表記で出力する.
setopt C_BASES

# 算術式の演算子優先順位を C 言語に近づける.
setopt C_PRECEDENCES

# 関数内の break/continue が呼び出し元のループへ伝播しないようにする.
setopt LOCAL_LOOPS

# 関数内で変更したオプションを関数終了時に元へ戻す.
# setopt LOCAL_OPTIONS

# 関数内で変更した pattern disable 状態を関数終了時に元へ戻す.
# setopt LOCAL_PATTERNS

# 関数内で設定した trap を関数終了時に元へ戻す.
# setopt LOCAL_TRAPS

# 先頭0の整数を8進数として解釈する.
# setopt OCTAL_ZEROES

# パイプライン全体の終了ステータスを右端の非0終了ステータスにする.
setopt PIPE_FAIL


# ==========================================================
# Zle
# ==========================================================

# ZLE のエラー時にビープを鳴らさない.
unsetopt BEEP

# 結合文字を端末が正しく合成表示できるものとして扱う.
# setopt COMBINING_CHARS
