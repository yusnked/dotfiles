alias has-bframe='ffprobe -v error -select_streams v:0 -show_entries stream=has_b_frames -of default=noprint_wrappers=1:nokey=1'

ffdesc() {
    ffmpeg -i "$1" -c copy -metadata description="$2" "${1%.*}_desc.${1##*.}"
}

retag_hvc1() {
    local input tmp dir base head ext

    input=$1
    if [ -z "$input" ]; then
        printf 'usage: retag_hvc1 <file>\n' >&2
        return 1
    fi

    if [ ! -f "$input" ]; then
        printf 'file not found: %s\n' "$input" >&2
        return 1
    fi

    dir=$(dirname -- "$input")
    base=$(basename -- "$input")
    head=${base%.*}
    ext=${base##*.}

    tmp="${dir}/.tmp.${head}.$$.${ext}"

    ffmpeg -y -i "$input" -c copy -tag:v hvc1 "$tmp" &&
    mv -f -- "$tmp" "$input"

    local status=$?
    if [ $status -ne 0 ]; then
        rm -f -- "$tmp"
    fi
    return $status
}

audelay () {
        # bash / zsh 両対応。配列不使用。長いオプション対応。
        _audelay_usage () {
                cat <<'USAGE'
Usage:
  adelay <video_file> <audio_file> --delay <seconds> [--mode shortest|longest] [--norm] [--help]

Options:
  --delay, -d   音声を映像に対してずらす秒数（+で遅らせる、-で前倒し）
  --mode,  -m   長さ合わせ: shortest（既定）| longest（映像に合わせて末尾を無音で埋める）
  --norm        シフト後の音声にラウドネス正規化を適用（I=-16, TP=-1.5, LRA=11）
  --help,  -h   このヘルプを表示

Notes:
  - mp4/mov/m4v の出力では -movflags +faststart を付与
  - webm は libopus、その他は aac を使用
  - longest時のパディングは「正規化の後」に入れる（無音がI値を薄めないように）
  - 旧式の位置引数（video audio offset [mode]）も一応受け付けるが、そのうち切り捨てる予定
Examples:
  adelay in.mp4 voice.wav --delay 0.230 --mode shortest --norm
  adelay in.mov mic.m4a  --delay -1.5   --mode longest  --norm
USAGE
        }

        # 依存コマンド
        for cmd in ffmpeg ffprobe bc; do
                command -v "$cmd" >/dev/null 2>&1 || { echo "Error: '$cmd' not found." >&2; return 1; }
        done

        # デフォルト
        local video="" audio="" offset="" mode="shortest" norm=0

        # オプションパース（配列なし）
        local extras=""
        while [ "$#" -gt 0 ]; do
                case "$1" in
                        --help|-h) _audelay_usage; return 0 ;;
                        --norm)    norm=1 ;;
                        --delay|-d)
                                shift || { echo "Error: --delay requires a value." >&2; return 1; }
                                offset="$1"
                                ;;
                        --mode|-m)
                                shift || { echo "Error: --mode requires a value." >&2; return 1; }
                                case "$1" in shortest|longest) mode="$1" ;; *)
                                        echo "Error: --mode must be 'shortest' or 'longest'." >&2; return 1 ;;
                                esac
                                ;;
                        --) shift; break ;;
                        -*)
                                echo "Error: unknown option: $1" >&2; return 1 ;;
                        *)
                                if [ -z "$video" ]; then video="$1"
                                elif [ -z "$audio" ]; then audio="$1"
                                else extras="${extras} $1"
                                fi
                                ;;
                esac
                shift
        done

        # 旧式呼び出し互換: 余り引数を offset / mode に解釈
        # 例: adelay video audio 0.2 longest
        if [ -z "$offset" ] && [ -n "$extras" ]; then
                # 先頭トークンが数値なら offset
                # shellcheck disable=SC2086
                set -- $extras
                if [ -n "$1" ]; then
                        case "$1" in
                                ''|*[!0-9.-]*) : ;;  # 非数
                                *) offset="$1" ;;
                        esac
                        shift
                fi
                if [ -n "$1" ]; then
                        case "$1" in shortest|longest) mode="$1" ;; esac
                fi
        fi

        # 必須チェック
        if [ -z "$video" ] || [ -z "$audio" ] || [ -z "$offset" ]; then
                echo "Error: missing arguments." >&2
                _audelay_usage
                return 1
        fi

        # オフセットの符号でシフトフィルタを決定
        local shift_filter delay_ms abs_offset
        if [ "$(echo "$offset >= 0" | bc -l)" -eq 1 ]; then
                delay_ms=$(printf '%.0f\n' "$(echo "$offset * 1000" | bc -l)")
                shift_filter="adelay=${delay_ms}:all=1"
        else
                abs_offset=$(printf '%.3f\n' "$(echo "0 - ($offset)" | bc -l)")
                shift_filter="atrim=start=${abs_offset},asetpts=PTS-STARTPTS"
        fi

        # 長さ取得
        local vdur adur
        vdur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 -- "$video")
        adur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 -- "$audio")
        if [ -z "$vdur" ] || [ -z "$adur" ]; then
                echo 'Error: Could not determine duration via ffprobe.' >&2
                return 1
        fi

        # 実効音声長（負を0にクリップ）
        local eff_audio
        eff_audio=$(echo "$adur + ($offset)" | bc -l)
        if [ "$(echo "$eff_audio < 0" | bc -l)" -eq 1 ]; then
                eff_audio="0"
        fi

        # サンプルレート（apad pad_len算出用）
        local sr
        sr=$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate \
             -of default=noprint_wrappers=1:nokey=1 -- "$audio")
        [ -z "$sr" ] && sr=48000

        # 出力コーデック選定
        local ext ext_lc audio_codec
        ext="${video##*.}"
        ext_lc=$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')
        case "$ext_lc" in
                mp4|m4v|mov) audio_codec='aac' ;;
                webm)        audio_codec='libopus' ;;
                mkv|flv|*)   audio_codec='aac' ;;
        esac

        local output="${video%.*}_sync.${ext}"
        if [ -f "$output" ]; then
                printf "Output file '%s' already exists. Overwrite? [y/N] " "$output"
                read -r ans
                case "$ans" in [yY]*) ;; *) echo "Aborted."; return 1 ;; esac
        fi

        # フィルタグラフ
        local loudnorm filtergraph use_shortest pad_dur pad_len
        [ "$norm" -eq 1 ] && loudnorm="loudnorm=I=-16:TP=-1.5:LRA=11"

        use_shortest=1
        if [ "$mode" = "longest" ] && [ "$(echo "$vdur > $eff_audio" | bc -l)" -eq 1 ]; then
                pad_dur=$(echo "$vdur - $eff_audio" | bc -l)
                pad_len=$(printf '%.0f\n' "$(echo "$pad_dur * $sr" | bc -l)")
                if [ -n "$loudnorm" ]; then
                        filtergraph="[1:a]${shift_filter},${loudnorm}[anorm];[anorm]apad=pad_len=${pad_len}[aout]"
                else
                        filtergraph="[1:a]${shift_filter},apad=pad_len=${pad_len}[aout]"
                fi
                use_shortest=0
        else
                if [ -n "$loudnorm" ]; then
                        filtergraph="[1:a]${shift_filter},${loudnorm}[aout]"
                else
                        filtergraph="[1:a]${shift_filter}[aout]"
                fi
                use_shortest=1
        fi

        # ffmpegコマンドを安全に構築（配列なしで積む）
        set -- ffmpeg -y -i "$video" -i "$audio" \
               -filter_complex "$filtergraph" \
               -map 0:v:0 -map "[aout]" \
               -c:v copy -c:a "$audio_codec" -b:a 192k

        # mp4系は -movflags +faststart を2トークンで
        case "$ext_lc" in
                mp4|m4v|mov) set -- "$@" -movflags +faststart ;;
        esac

        # pad_len基準と一致させるためにサンプルレート固定
        [ -n "$sr" ] && set -- "$@" -ar "$sr"

        [ "$use_shortest" -eq 1 ] && set -- "$@" -shortest

        set -- "$@" "$output"

        # 実行
        "$@"
}
