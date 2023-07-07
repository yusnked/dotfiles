# zsh-deferでうまく読み込めないので同期的に(普通にsource)して読み込む。

##### Changing Directories
### options
# AUTO_CD: 通常のコマンドとして実行できないコマンドが発行され、それがディレクトリ名であった場合自動でcdする。
setopt AUTO_CD

# AUTO_PUSHD: CDした後元いたディレクトリを自動でディレクトリスタックに追加する。
#setopt AUTO_PUSHD

# CDABLE_VARS: /で始まらなく、存在しないディレクトリ名が入力されたときに~展開(名前付きディレクトリ)を試みる。
setopt CDABLE_VARS

# CD_SILENT: 例えば cd - などをしたときにどこにcdするかを表示しない。POSIX_CDを上書きする?
setopt CD_SILENT

# CHASE_DOTS: ..を含むディレクトリに移動したときに..の前のディレクトリをキャンセルしてから移動する。CHASE_LINKSで上書きされる。
#setopt CHASE_DOTS

# CHASE_LINKS: ディレクトリを移動するときにシンボリックリンクを物理バスに直してから移動する。
#setopt CHASE_LINKS

# POSIX_CD <k> <s>: cd chdir pushd コマンドの挙動を変更し、POSIX標準と互換性を持たせる。
#setopt POSIX_CD

# PUSHD_IGNORE_DUPS: ディレクトリスタックに重複したパスを追加しない。
setopt PUSHD_IGNORE_DUPS

# PUSHD_MINUS: スタック内のディレクトリを指定するための + - の意味を反転する。
#setopt PUSHD_MINUS

# PUSHD_SILENT: pushd popd を使ったときにスタック内のパスを表示しない。
#setopt PUSHD_SILENT

# PUSHD_TO_HOME: 引数なしの pushd を pushd $HOME　とする。
#setopt PUSHD_TO_HOME

### variables
# cdpath <S> <Z> (CDPATH <S>): cd コマンドの検索パスを指定するディレクトリの配列。
cdpath=()

# DIRSTACKSIZE: ディレクトリスタックの最大保持数。AUTO_PUSHDを使用する場合は設定した方が良い。
DIRSTACKSIZE=20


##### Completion
### options
# ALWAYS_LAST_PROMPT <D>: 補完候補を表示したとき新しいプロンプトを表示せずに元のプロンプトを使う。
#unsetopt ALWAYS_LAST_PROMPT

# ALWAYS_TO_END: 補完時に文字列末尾へカーソル移動。(compsysをすでに使っているからか元々末尾に移動するので違いがわからなかった)
#setopt ALWAYS_TO_END

# AUTO_LIST <D>: 候補が複数あるときに自動的に一覧を出す。
#unsetopt AUTO_LIST

# AUTO_MENU <D>: 候補が複数あるときに補完キーの連打で自動的にメニュー補完に移行。MENU_COMPLETEオプションが優先される。
#unsetopt AUTO_MENU

# AUTO_NAME_DIRS: ディレクトリの絶対パスを設定した変数を代入直後から名前付きディレクトリとして~{変数}で補完できるようにする。
# このオプションが設定されていないと、一回手動で~{変数}を参照しないと名前付きディレクトリにならない。
#setopt AUTO_NAME_DIRS

# AUTO_PARAM_KEYS <D>: 補完時自動でスペース等が追加されたとき、次の入力文字が名前の直後でないとダメな文字なら自動的に追加した文字を削除する。
#unsetopt AUTO_PARAM_KEYS

# AUTO_PARAM_SLASH <D>: 変数名補完時に、その値がディレクトリ名なら直後にスラッシュも補う。
#unsetopt AUTO_PARAM_SLASH

# AUTO_REMOVE_SLASH <D>: 補完の結果最後の文字が/で次の入力文字が単語区切り文字や/やコマンド終了文字の場合末尾の/を自動的に削除する。
#unsetopt AUTO_REMOVE_SLASH

# BASH_AUTO_LIST: AUTO_LISTと同じだが、二度続けて補完キーを押したときに補完候補一覧を表示する。
#setopt BASH_AUTO_LIST

# COMPLETE_ALIASES: 補完時にエイリアスを内部的に置き換えずに実行する。
#setopt COMPLETE_ALIASES

# COMPLETE_IN_WORD: 通常補完を行うときは単語末尾に移動して先頭マッチで補完するが、有効にするとカーソル位置に*を補ったかのような動作になる。
#setopt COMPLETE_IN_WORD

# GLOB_COMPLETE: カーソル位置の単語にグロッピングパターンが含まれていた場合、全てを展開するのではなくメニュー補完にする。
# もしマッチするものがない場合、末尾に*(COMPLETE_IN_WORD設定時はカーソル位置)があるものとして再度試みる。
#setopt GLOB_COMPLETE

# HASH_LIST_ALL <D>: コマンド補完時にコマンドハッシュを確認する。その分初回の補完が遅くなる。
#unsetopt HASH_LIST_ALL

# LIST_AMBIGUOUS <D>: AUTO_LISTで補完一覧を出す場合、補完キーを押す前後で単語が全く変わらない場合のみ自動一覧を出す。
#unsetopt LIST_AMBIGUOUS

# LIST_BEEP <D>: BEEPがONの時補完結果が一つに確定しないときにベルを鳴らす。(補完ウィジェットがステータス1を返す)
#unsetopt LIST_BEEP

# LIST_PACKED: 一覧をなるべく詰めて表示して行数をなるべく少なくする。(compsysのlist-packedも参照)
setopt LIST_PACKED

# LIST_ROWS_FIRST: 候補一覧を横進みにする。デフォルトはlsコマンドと同じ縦進み。(compsysのlist-rows-firstも参照)
#setopt LIST_ROWS_FIRST

# LIST_TYPES <D>: 候補一覧のファイル名の末尾にファイル種別を表す記号をつける。
#unsetopt LIST_TYPES

# MENU_COMPLETE: 候補が複数あるときの補完で直ちにメニュー補完に移行する。AUTO_MENUをオーバーライドする。
# メニュー補完利用時には直前の候補に戻るreverse-menu-completeをどれかのキーに割り当てておくと良い。
#setopt MENU_COMPLETE

# REC_EXACT: 現在の単語に完全一致するものがある場合に、別の候補があっても確定する。
#setopt REC_EXACT


##### Expansion and Globbing
### options
# BAD_PATTERN <CZ>: ファイル名生成のパターンがフォーマット違反の時、エラーメッセージを表示する
#unsetopt BAD_PATTERN

# BARE_GLOB_QUAL <Z>: 末尾の例えば(^x)などEXTENDED_GLOB有効時にファイル修飾子ともグロブパターンとも取れるときにファイル修飾子とみなす。
#unsetopt BARE_GLOB_QUAL

# BRACE_CCL: ブレース内の式が正しくない形式とき、個々の文字の辞書順リストとなる。hoge.{ab}がhoge.a hoge.bに展開される。
#setopt BRACE_CCL

# CASE_GLOB <D>: グロッビング(ファイル名生成)で大文字小文字を区別する。オフにすると(#I)などで区別することもできなくなる。
#unsetopt CASE_GLOB

# CASE_MATCH <D>: zsh/regexモジュールのマッチで大文字小文字を区別する。
#unsetopt CASE_MATCH

# CASE_PATHS: CASE_PATHS未設定時、CASE_GLOBは、任意のコンポーネントに特殊文字が現れるたびに、すべてのパス コンポーネントの解釈に影響を与える。
# CASE_PATHSが設定時は特殊なファイル名生成文字を含まないファイル パス コンポーネントは常に大文字と小文字を区別する。
# 設定時NO_CASE_GLOBはグロビング文字を含むコンポーネントに制限される。ファイルシステムが大文字と小文字を区別しない場合には設定しても効果がない。
#setopt CASE_PATHS

# CSH_NULL_GLOB <C>: グロブパターンを含む引数のみで構成された引数リストから無効なパターンを含む引数を削除して実行する。NOMATCHをオーバーライドする。
#setopt CSH_NULL_GLOB

# EQUALS <Z>: クォートされていない=の直後に単語を書いたものは、同名の外部コマンドのフルパスに展開される
#unsetopt EQUALS

# EXTENDED_GLOB: # ~ ^ 文字をファイル名生成などのパターンの一部として使えるようになる。逆に言うと通常文字として使いたければクォートしないといけない。
# ただし、クォートされていない最初の ~ は常に名前付きディレクトリに展開される。
setopt EXTENDED_GLOB

# FORCE_FLOAT: 算術評価の整数定数や算術式で使用される整数変数は小数点を使用しなくても自動的に小数に変換される。(zsh-autosuggestionsがバグる)
#setopt FORCE_FLOAT

# GLOB <D>: ファイル名の生成 (グロビング) を実行する。
#unsetopt GLOB

# GLOB_ASSIGN <C>: 代入式の右辺(パターン)でもグロッビングする。互換性のためにあるオプションで、代入した変数がスカラーになるのか配列になるのか不明。
# このオプションを有効化するより括弧で括って var=(hoge*) とした方が常に配列になることが明確なのでいいのかもしれない。
#setopt GLOB_ASSIGN

# GLOB_DOTS: . で開始するファイル名にマッチさせるとき、先頭に明示的に . を指定する必要がなくなる。
#setopt GLOB_DOTS

# GLOB_STAR_SHORT: zsh スタイルのグロビングが有効な場合 **/*　を **、***/*(シンボリックリンクをたどる) を *** に省略して記述できる。
setopt GLOB_STAR_SHORT

# GLOB_SUBST <CKS>: 変数の結果を置換して得られた文字を、ファイル拡張やファイル名生成として扱う。(ブレース展開は対象外?)
#setopt GLOB_SUBST

# HIST_SUBST_PATTERN: ヒストリ編集子の:sや:&での置換方法を文字列一致からグロブパターン一致にする。
#setopt HIST_SUBST_PATTERN

# IGNORE_BRACES <S>: ブレース展開を使用しない。歴史的な理由からIGNORE_CLOSE_BRACESオプションの効果も含まれる。
#setopt IGNORE_BRACES

# IGNORE_CLOSE_BRACES: 関数定義時に例えば arg() { echo $#; } みたいに } の前に;または改行が必要になる。
#setopt IGNORE_CLOSE_BRACES

# KSH_GLOB <K>: ()の前に @ * + ? ! をつけるkshに似たグロブ演算子を利用できる。パターンに一致/0-N/1-N/0-1/パターン以外に一致
#setopt KSH_GLOB

# MAGIC_EQUAL_SUBST: クォートされていない引数位置でのany=の後の~{dirnamevar}や={cmd}を展開する。(例 echo foo==ls)
setopt MAGIC_EQUAL_SUBST

# MARK_DIRS: ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加。
#setopt MARK_DIRS

# MULTIBYTE <D>: マルチバイト文字が見つかった場合現在のロケールに応じて位置文字を構成するバイト数が決定される。
# シェルがMULTIBYTE_SUPPORTでコンパイルされた場合デフォルトでオンになっているがそれ以外の場合オンにしても意味がない。
#unsetopt MULTIBYTE

# NOMATCH <CZ>: ファイル名生成のパターンにマッチするものがない場合、エラーを表示する。最初の ~ または = のファイル展開にも適用される。
#unsetopt NOMATCH

# NULL_GLOB: 不正なパターンを削除して実行。CSH_NULL_GLOBとは違い全ての引数がパターンを含んでいる必要はない。NOMATCHをオーバーライドする。
setopt NULL_GLOB

# NUMERIC_GLOB_SORT: 数値ファイル名がファイル名生成パターンと一致する場合、ファイル名を辞書順ではなく数値順に並べ替える。
setopt NUMERIC_GLOB_SORT

# RC_EXPAND_PARAM: 配列変数でブレース展開みたいなことができる。x=(1 2); a${x}bで a1 2b ではなく a1b a2b になる。
setopt RC_EXPAND_PARAM

# REMATCH_PCRE: =~にPCREライブラリのPerl互換の正規表現を使用する。デフォルトはシステムライブラリの拡張正規表現。zsh/pcreモジュールが必要。
#setopt REMATCH_PCRE

# SH_GLOB <KS>: グロッビングにおいて、( | ) < の特殊な意味を無効化する
#setopt SH_GLOB

# UNSET <KSZ>: 設定されていない変数を参照したときに空白や0として扱うようにする。(外すとzsh-autosuggestionsがバグる)
#unsetopt UNSET

# WARN_CREATE_GLOBAL: 関数内で代入などで暗黙的にグローバル変数が作成された場合に警告メッセージを表示する。
#setopt WARN_CREATE_GLOBAL

# WARN_NESTED_VAR: 囲んでいる関数スコープまたはグローバルからの既存のパラメーターが内スコープでさらに定義された場合警告メッセージを表示する。
#setopt WARN_NESTED_VAR


##### History
### options
# APPEND_HISTORY <D>: シェル終了時ヒストリファイルを上書きではなく追記する。複数シェル同時利用では必須。
#unsetopt APPEND_HISTORY

# BANG_HIST <CZ>: cshスタイルのヒストリ拡張を使う(`!' 文字を特別に扱う)
#unsetopt BANG_HIST

# EXTENDED_HISTORY <C>: ヒストリファイルを拡張フォーマットで保存する。コマンド入力時刻と実行時間が追加保存される。
setopt EXTENDED_HISTORY

# HIST_ALLOW_CLOBBER: リダイレクト > を >| にしてヒストリに保存する。
#setopt HIST_ALLOW_CLOBBER

# HIST_BEEP <D>: ヒストリに存在しないものを取り出そうとしたときにベルを鳴らす。
#setopt HIST_BEEP

# HIST_EXPIRE_DUPS_FIRST: ヒストリが上限(HISTSIZE)に達したときに古いものから消すのではなく重複している物を削除する。
#setopt HIST_EXPIRE_DUPS_FIRST

# HIST_FCNTL_LOCK: 履歴ファイルのロックにfcntlを用いる。一部osでのロックに関する既知の問題を回避する。
#setopt HIST_FCNTL_LOCK

# HIST_FIND_NO_DUPS: ラインエディタでヒストリ検索する際に一度見つかったものはさらに先に重複したものがあってもないものとみなす。
setopt HIST_FIND_NO_DUPS

# HIST_IGNORE_ALL_DUPS: 同じコマンドをヒストリに残さない。古い方を削除する。
setopt HIST_IGNORE_ALL_DUPS

# HIST_IGNORE_DUPS: 直前のコマンドと同じならヒストリに登録しない。
#setopt HIST_IGNORE_DUPS

# HIST_IGNORE_SPACE: 先頭にスペースを入れたコマンドラインをヒストリ登録しない。エイリアス展開後にも適応される。
setopt HIST_IGNORE_SPACE

# HIST_LEX_WORDS: 履歴ファイルから読み込むときに単純に空白で分割するのではなく、通常のシェルコマンドラインの処理と同様の方法で分割する。
#setopt HIST_LEX_WORDS

# HIST_NO_FUNCTIONS: 関数定義のためのコマンドラインはヒストリから削除する。
setopt HIST_NO_FUNCTIONS

# HIST_NO_STORE: ヒストリ参照のためのコマンド(history|fc -l)をヒストリから削除する。
setopt HIST_NO_STORE

# HIST_REDUCE_BLANKS: ヒストリ登録する際に余分なスペースを削除する。(teratermで履歴がおかしくなるらしい)
setopt HIST_REDUCE_BLANKS

# HIST_SAVE_BY_COPY <D>: ヒストリファイルを保存するときに別名ファイルに書き出してから名前を変更する。保存中にzshが終了し履歴が失われるのを防ぐ。
#unsetopt HIST_SAVE_BY_COPY

# HIST_SAVE_NO_DUPS: ヒストリファイルに保存するときに重複したコマンドラインは古い方を削除する。
#setopt HIST_SAVE_NO_DUPS

# HIST_VERIFY: ヒストリ展開時いきなり実行せずにマッチしたものをいったん提示する。
#setopt HIST_VERIFY

# INC_APPEND_HISTORY: 入力されたコマンドラインをヒストリリストに登録すると同時に直ちにヒストリファイルにも追記で書き込む。
# このオプションとEXTENDED_HISTORYの併用では経過時間が全て0で記録されてしまうのでその場合はINC_APPEND_HISTORY_TIMEを設定する。
# なお INC_APPEND_HISTORY|INC_APPEND_HISTORY_TIME|SHARE_HISTORYは排他的なオプション
#setopt INC_APPEND_HISTORY

# INC_APPEND_HISTORY_TIME: コマンド終了時にヒストリファイルに書き込むので経過時間が正しく記録される。
#setopt INC_APPEND_HISTORY_TIME

# SHARE_HISTORY <K>: 稼働中のこのオプションが有効のzsh同士でヒストリリストを共有する
setopt SHARE_HISTORY

### variables
# histchars: イベント呼び出しのための3つの文字を指定する
# 1文字目(デフォルト:!): イベント呼び出し
# 2文字目(デフォルト:^): 簡易ヒストリ置換(!:s///相当)
# 3文字目(デフォルト:#): コメント開始文字
#histchars='!^#'

# HISTFILE: 端末利用しているzshのヒストリの保存ファイル。デフォルトは~/.zsh_history
HISTFILE="$XDG_DATA_HOME/zsh/.zsh_history"

# HISTSIZE: シェルのメモリ内に記憶しておくヒストリの最大イベント数
HISTSIZE=10000

# SAVEHIST: ヒストリファイルに保存する最大数。HISTSIZEより大きい数は指定できない
SAVEHIST=10000


##### Initialisation
### options
# ALL_EXPORT: このオプションを有効化した後の変数は全てexportされる。
#setopt ALL_EXPORT

# GLOBAL_EXPORT <Z>: -x(環境変数化)が渡されたら-g(グローバル変数化)も渡されたことにする。互換性の為にこのオプションを変えるべきでない。
#unsetopt GLOBAL_EXPORT

# GLOBAL_RCS <D>: このオプションを切ると/etc/zshenv以外のグローバル設定ファイルが読み込まれなくなる。
#unsetopt GLOBAL_RCS

# RCS <D>: このオプションを切ると/etc/zshenv以外の設定ファイルが読み込まれなくなる。
#unsetopt RCS


##### Input/Output
### options
# ALIASES <D>: エイリアスを展開する。
#unsetopt ALIASES

# CLOBBER <D>: > リダイレクトでファイルを上書きできるようにする。設定していない場合 >| か >! を使う必要がある。
#unsetopt CLOBBER

# CLOBBER_EMPTY: CLOBBER未設定時に有効化できる。空のファイルの場合は上書きできるようにする。ファイルが非同期で書き込まれる可能性がある場合に注意。
#setopt CLOBBER_EMPTY

# CORRECT: スペルミスを報告する。シェル変数CORRECT_IGNOREにミスとしない単語のパターンを設定できる。
#setopt CORRECT

# CORRECT_ALL: コマンドライン全ての引数をチェックする。シェル変数CORRECT_IGNORE_FILEにスペルチェックを無視するファイル名のパターンを設定できる。
#setopt CORRECT_ALL

# DVORAK: スペルミス補完をDVORAK配列モードにする
#setopt DVORAK

# FLOW_CONTROL <D>: 無効にするとシェルのエディターでスタート/ストップ文字 (通常は ^S/^Q に割り当てられる) による出力フロー制御が無効になる。
#unsetopt FLOW_CONTROL

# IGNORE_EOF: EOF(^D)でシェルを終了しない。ただし10回連続してEOFが発生するとシェルを終了する。bindkeyで^Dに設定するときに警告が出なくなる。
setopt IGNORE_EOF

# INTERACTIVE_COMMENTS <KS>: コマンドラインでコメントを入力できるようになる。
#setopt INTERACTIVE_COMMENTS

# HASH_CMDS <D>: 各コマンドを初めて使用したときにパスをハッシュ化しそれ以降の呼び出しでPATH検索を回避する。
#unsetopt HASH_CMDS

# HASH_DIRS <D>: コマンド名をハッシュ化するときにそれを含むディレクトリとパスの前にある全てのディレクトリをハッシュする。
#unsetopt HASH_DIRS

# HASH_EXECUTABLES_ONLY: 実行可能ファイルのみをハッシュ化する。パスに多数のコマンドやリモートファイルが含まれていると時間がかかる。
#setopt HASH_EXECUTABLES_ONLY

# MAIL_WARNING: シェルが最後にチェックした後でメールファイルがアクセスされていると警告する。
#setopt MAIL_WARNING

# PATH_DIRS: foo/barのようにコマンド位置で入力するとPATH/foo/barが探されて実行される。/ ./ ../で始まるコマンドは対象外。
#setopt PATH_DIRS

# PATH_SCRIPT <KS>: 無効時シェルに渡されるスクリプトは絶対パスの必要がある。有効時はDirPath未指定の場合現在のディレクトリかコマンドパスで検索される。
#setopt PATH_SCRIPT

# PRINT_EIGHT_BIT: 補完リストなどで8ビット文字を文字どおりに出力する。システムが8bit文字を正しく返すならこのオプションは必要ない。
#setopt PRINT_EIGHT_BIT

# PRINT_EXIT_VALUE: ゼロ以外の終了ステータスを持つプログラムの終了値を出力する。対話型シェルのみで有効。
#setopt PRINT_EXIT_VALUE

# RC_QUOTES: シングルクォートの中で''と2回打つとシングルクォートをエスケープして表示できるようにする。
#setopt RC_QUOTES

# RM_STAR_SILENT <KS>: rm * などrmコマンドでグロブ記号を使った場合に確認せずに実行する。
#setopt RM_STAR_SILENT

# RM_STAR_WAIT: rm * などを実行したときに10秒待ってから確認メッセージを表示する。
#setopt RM_STAR_WAIT

# SHORT_LOOPS <CZ>: FOR, REPEAT, SELECT, IF, FUNCTION などで簡略文法が使えるようになる。
#unsetopt SHORT_LOOPS

# SHORT_REPEAT: REPEATの簡略文法は使えるようにするがそのほかの簡略文法は無効化する。
#setopt SHORT_REPEAT

# SUN_KEYBOARD_HACK: SUNキーボードでの頻出 typo ` をカバーする。(文末のバッククォートを奇数個の場合無視する)
#setopt SUN_KEYBOARD_HACK


##### Job Control
### options
# AUTO_CONTINUE: disown組み込みコマンドでジョブテーブルから削除された停止ジョブに自動的にCONTシグナルを送信する。
#setopt AUTO_CONTINUE

# AUTO_RESUME: リダイレクトのない単一の単語の単純なコマンドを既存のジョブの再開の候補として扱う。
setopt AUTO_RESUME

# BG_NICE <CZ>: すべてのバックグラウンドジョブを低い優先度で実行する。
#unsetopt BG_NICE

# CHECK_JOBS <Z>: ログアウト時にバックグランドジョブまたは中断されたジョブがあれば警告する。2回ログアウトしようとすれば終了する。
#unsetopt CHECK_JOBS

# CHECK_RUNNING_JOBS <Z>: CHECK_JOBS有効時、このオプションを無効化すると中断されたジョブのみをチェックする。bashデフォルト動作と同じになる。
#unsetopt CHECK_RUNNING_JOBS

# HUP <Z>: シェル終了時に実行中のジョブにHUPシグナルを送信する。
#unsetopt HUP

# LONG_LIST_JOBS: 組み込みコマンド jobs の出力をデフォルトで jobs -l にする。
setopt LONG_LIST_JOBS

# MONITOR: ジョブ制御を有効化する。インタラクティブシェルではデフォルトで設定される。
#setopt MONITOR

# NOTIFY <Z>: バックグラウンドジョブのステータスをプロンプトの表示を待たずにすぐに知らせる。
#unsetopt NOTIFY

# POSIX_JOBS <KS>: ジョブ制御がより POSIX 標準に準拠するようになる。詳しくは man zshoptions
#setopt POSIX_JOBS


##### Prompting
### options
# PROMPT_BANG <K>: !を次に保存されるヒストリ番号に置換する。!自体は!!で入力する。
#setopt PROMPT_BANG

# PROMPT_CR <D>: プロンプト出力前にキャリッジリターンを出力する。
#unsetopt PROMPT_CR

# PROMPT_SP <D>: 直前のコマンド出力が改行で終わらない場合に%記号(rootは#)と改行を出力してからプロンプトを表示する。
#unsetopt PROMPT_SP

# PROMPT_PERCENT <CZ>: %記号の展開を行う。
#unsetopt PROMPT_PERCENT

# PROMPT_SUBST <KS>: PROMPT変数に対して変数展開・コマンド置換・算術展開を行う。
setopt PROMPT_SUBST

# TRANSIENT_RPROMPT: コマンド実行時に右プロンプトを消去する。コマンド入力操作画面を後からコピー&ペーストするときなどに有用。
setopt TRANSIENT_RPROMPT


##### Scripts and Functions
### options
# ALIAS_FUNC_DEF <S>: エイリアスとして定義されている名前と同じ関数を許可する。
#setopt ALIAS_FUNC_DEF

# C_BASES: C言語の形式で16進数を出力する。例 16#FF -> 0xFF
setopt C_BASES

# C_PRECEDENCES: 算術演算子の優先順位をC言語に合わせる。
setopt C_PRECEDENCES

# DEBUG_BEFORE_CMD <D>: 各コマンドの前にDEBUGトラップを実行する(ksh 93相当)。無効にすると後に実行する(ksh 88相当)。
#unsetopt DEBUG_BEFORE_CMD

# ERR_EXIT: コマンドの終了ステータスが0以外の場合にZERRトラップを実行する。初期化スクリプトやDEBUGトラップ内では無効になる。
#setopt ERR_EXIT

# ERR_RETURN: コマンドの返り値が 0 でないとき、そのコマンドを呼び出した関数から脱出する
#setopt ERR_RETURN

# EVAL_LINENO <Z>: 組み込みコマンドevalを使用して評価された式の行番号($LINENO)を囲んでいる環境とは別に追跡する。
#unsetopt EVAL_LINENO

# EXEC <D>: コマンドを実行する。無効にすると構文エラーのチェックのみで実行されないが、対話型シェルでは起動時に-nを指定する以外無効にできない。
#unsetopt EXEC <-これは意味がない。

# FUNCTION_ARGZERO <CZ>: 関数やスクリプトの source 実行時に、 $0 を一時的にその関数／スクリプト名にセットする。
#unsetopt FUNCTION_ARGZERO

# LOCAL_LOOPS: このオプションを設定していないとbreakとcontinueコマンドが関数スコープを抜けて呼び出し元のループに影響を及ぼす可能性がある。
#setopt LOCAL_LOOPS

# LOCAL_OPTIONS <K>: シェル関数から戻る時点でその関数を呼び出したときに有効だったほとんどのオプションを復元する。
#setopt LOCAL_OPTIONS

# LOCAL_PATTERNS: シェル関数から戻る時点で disable -p で設定されたパターン無効化の状態を呼び出し時の状態に復元する。
#setopt LOCAL_PATTERNS

# LOCAL_TRAPS <K>: 関数内でこのオプションが設定されていると関数終了時にシグナルトラップの状態を関数呼び出し前の状態に復元する。
#setopt LOCAL_TRAPS

# MULTI_FUNC_DEF <Z>: fn1 fn2... () みたいに一度に複数の名前で関数を定義可能にする。なおfunctionを前置すれば無効にしてもエラーにならない。
#unsetopt MULTI_FUNC_DEF

# MULTIOS <Z>: 複数のリダイレクトを利用可能にする。
#unsetopt MULTIOS

# OCTAL_ZEROES <S>: 0で始まる整数定数を8進数として解釈する。先頭に0がある日付や時刻の文字列の解析などで問題が発生する為デフォルトで無効になっている。
#setopt OCTAL_ZEROES

# PIPE_FAIL: パイプライン時に$?の終了ステータスを0以外の一番右側の値か全て0なら0にセットする。デフォルトは0かそれ以外かにかかわらず一番右側の値。
setopt PIPE_FAIL

# SOURCE_TRACE: sourceでロードされる各ファイルの名前を通知するXTRACEオプションと同形式のメッセージを出力する。
#setopt SOURCE_TRACE

# TYPESET_SILENT: 無効時、foo=0; typeset foo みたいにtypesetに変数名のみ与えると foo=0 みたいに値が表示される。
#setopt TYPESET_SILENT

# TYPESET_TO_UNSET <KS>: typesetで変数を宣言するときに値を明示的に代入しなければ変数を未設定のままにする。デフォルトでは空文字になる。
#setopt TYPESET_TO_UNSET

# VERBOSE: 読み込まれた入力行もそのまま全て表示する。打ち込んだコマンドラインやsourceしたファイル内容など全て表示される。
#setopt VERBOSE

# XTRACE: コマンドラインがどのように展開され実行されたかを逐一表示する
#setopt XTRACE


##### Shell Emulation
### options
# APPEND_CREATE <KS>: NO_CLOBBER設定時のみ有効。存在しないファイルに対して>>が使用された場合にエラーを報告しない(POSIXの動作)
#setopt APPEND_CREATE

# BASH_REMATCH: =~演算子使用時にデフォルトのMATCH変数とmatch配列ではなくbash互換のBASH_REMATCH配列を使う。
#setopt BASH_REMATCH

# BSD_ECHO <S>: echoコマンドで-eが指定されなければバックスラッシュのエスケープシーケンスを展開しない。
#setopt BSD_ECHO

# CONTINUE_ON_ERROR: シェルスクリプト実行時、致命的なエラーが発生した場合次のステートメントで実行を再開する。対話型シェルの動作を模倣。
#setopt CONTINUE_ON_ERROR

# CSH_JUNKIE_HISTORY <C>: イベント指定子(!123などの数字部分)のない履歴参照が常に前のコマンドを参照するようになる。
#setopt CSH_JUNKIE_HISTORY

# CSH_JUNKIE_LOOPS <C>: ループの本体部分 do hoge; done の代わりに hoge; end　も使えるようにする。
#setopt CSH_JUNKIE_LOOPS

# CSH_JUNKIE_QUOTES <C>: シングルクォートとダブルクォートの動作をcsh互換にする。
#setopt CSH_JUNKIE_QUOTES

# CSH_NULLCMD <C>: コマンドなしでリダイレクトを実行するときにNULLCMDとREADNULLCMDの値を参照しないでエラーを表示する。
#setopt CSH_NULLCMD

# KSH_ARRAYS <KS>: 配列を可能な限りksh互換にする。添字が0から始まり添字なしの変数は最初の要素を参照する。
#setopt KSH_ARRAYS

# KSH_AUTOLOAD <KS>: autoloadをksh互換にする。読み込むファイル名と同名の関数をファイル内の一番外側で定義する必要がある。
#setopt KSH_AUTOLOAD

# KSH_OPTION_PRINT <K>: setoptとunsetoptで有効無効別でそれぞれリストを出すのではなく全てのオプションが on off と共に表示される。
#setopt KSH_OPTION_PRINT

# KSH_TYPESET: このオプションは旧式です。typeset系コマンドの引数の処理方法を変更する。
#setopt KSH_TYPESET

# KSH_ZERO_SUBSCRIPT: 配列の[0]を使用したときに[1]を使用したのと同じことにする。古いシェルの互換性の為のオプションで非推奨。
#setopt KSH_ZERO_SUBSCRIPT

# POSIX_ALIASES <KS>: 予約語と同名のエイリアスを展開しない。
#setopt POSIX_ALIASES

# POSIX_ARGZERO: FUNCTION_ARGZEROを一時的に無効化して$0の値をシェルの呼び出しに使用した名前に戻す。
#setopt POSIX_ARGZERO

# POSIX_BUILTINS <KS> : 設定することで様々なbuiltinコマンドの挙動がなるべくPOSIXに準拠するようになる。
#setopt POSIX_BUILTINS

# POSIX_IDENTIFIERS <KS>: 変数名とモジュール名に使える文字を英数とアンダーバーのみにする。中括弧を使用しない変数置換の効果も制限される。
#setopt POSIX_IDENTIFIERS

# POSIX_STRINGS <KS>: $''で囲まれた文字列にNULL文字が含まれている場合、NULL以降を切り捨てる。
#setopt POSIX_STRINGS

# POSIX_TRAPS <KS>: 関数終了時にEXITトラップが呼び出されなくなる。関数内でのEXITトラップの設定はシェル終了時のグローバルトラップの設定になる。
#setopt POSIX_TRAPS

# SH_FILE_EXPANSION <KS>: 変数展開、コマンド置換、算術展開、ブレース展開の前にファイル名展開(~展開)を実行する。
#setopt SH_FILE_EXPANSION

# SH_NULLCMD <KS>: コマンドなしリダイレクトを行うときにNULLCMD変数等を参照せずに:コマンドのリダイレクトとみなす。つまり何も起こらない。
#setopt SH_NULLCMD

# SH_OPTION_LETTERS <KS>: setやsetoptで使用される一文字オプションをksh互換にする。
#setopt SH_OPTION_LETTERS

# SH_WORD_SPLIT <KS>: クォートで囲まれていない変数展開でフィールド分割が実行されるようにする。
#setopt SH_WORD_SPLIT

# TRAPS_ASYNC: プログラムが終了するのを待たずにシグナルを処理しトラップをすぐに実行する。それ以外の場合、子プロセスが終了した後にトラップが実行される。
#setopt TRAPS_ASYNC


##### Shell State
### options
# INTERACTIVE: 対話型シェル。標準入力がTTYでコマンドが標準入力から読み取られる場合に初期化時に設定されます。zsh実行中は変更できない。

# LOGIN: ログインシェル。おのオプションが明示的に設定されていない場合、argv[0]の最初の文字が - の場合にログインシェルになる。

# PRIVILEGED: 特権モードをオンにします。通常、これはスクリプトが昇格された権限で実行される場合に使用されます。

# RESTRICTED: 制限モードを有効にする。unsetoptを使用して変更できない。関数内で設定しても常にグローバルに変更される。

# SHIN_STDIN: コマンドを標準入力から読み込む場合に設定する。zshの実行中は変更できない。

# SINGLE_COMMAND: シェルが標準入力から読み取っている場合単一のコマンドを実行してすぐにシェルを終了する。


##### Zle
### options
# BEEP <D>: ZLEのエラーでビープ音を鳴らす。
unsetopt BEEP

# COMBINING_CHARS: 端末がゼロ幅文字を正しく表示できると仮定する。このオプション無効時はゼロ幅文字はマークアップで個別に表示される。
#setopt COMBINING_CHARS

# EMACS: bindkey -e と同じ。互換性のために残されているオプションなので bindkey 推奨。
#setopt EMACS

# OVERSTRIKE: ZLEを上書きモードにする。デフォルトは挿入モード。
#setopt OVERSTRIKE

# SINGLE_LINE_ZLE <K>: kshとの表面的な互換性のためにある複数行のライン編集ができなくする設定。
#setopt SINGLE_LINE_ZLE

# VI: bindkey -v と同じ。互換性のために残されているオプションなので bindkey 推奨。
#setopt VI

# ZLE: ZLEを使用する。対話型シェルでデフォルトで設定される。
#setopt ZLE

