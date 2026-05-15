#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./make_video.sh [options]

Options:
  --title TEXT       Main title (default: CHANCE EAU FRAICHE)
  --subtitle TEXT    Subtitle under title (default: ЖЕНСКИЕ ДУХИ)
  --duration SEC     Video duration in seconds, positive number (default: 15)
  --out PATH         Output file path (default: output/chance_eau_fraiche_3x4.mpeg4)
  -h, --help         Show this help message
USAGE
}

fail() {
  echo "Error: $*" >&2
  exit 1
}

escape_drawtext() {
  local value="$1"
  value=${value//\\/\\\\}
  value=${value//:/\\:}
  value=${value//\'/\\\'}
  value=${value//,/\\,}
  printf '%s' "$value"
}

TITLE="CHANCE EAU FRAICHE"
SUBTITLE="ЖЕНСКИЕ ДУХИ"
DURATION="15"
OUT="output/chance_eau_fraiche_3x4.mpeg4"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title)
      [[ $# -ge 2 ]] || fail "option --title requires a value"
      TITLE="$2"
      shift 2
      ;;
    --subtitle)
      [[ $# -ge 2 ]] || fail "option --subtitle requires a value"
      SUBTITLE="$2"
      shift 2
      ;;
    --duration)
      [[ $# -ge 2 ]] || fail "option --duration requires a value"
      DURATION="$2"
      shift 2
      ;;
    --out)
      [[ $# -ge 2 ]] || fail "option --out requires a value"
      OUT="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown option: $1 (use --help)"
      ;;
  esac
done

[[ -n "$TITLE" ]] || fail "--title cannot be empty"
[[ -n "$SUBTITLE" ]] || fail "--subtitle cannot be empty"
[[ "$DURATION" =~ ^([0-9]+([.][0-9]+)?|[.][0-9]+)$ ]] || fail "--duration must be a positive number"
awk "BEGIN { exit !($DURATION > 0) }" || fail "--duration must be greater than 0"
[[ -n "$OUT" ]] || fail "--out cannot be empty"

command -v ffmpeg >/dev/null 2>&1 || fail "ffmpeg is not installed or not in PATH"

out_dir=$(dirname "$OUT")
mkdir -p "$out_dir"

TITLE_ESCAPED=$(escape_drawtext "$TITLE")
SUBTITLE_ESCAPED=$(escape_drawtext "$SUBTITLE")

if ! ffmpeg -y -f lavfi -i "color=c=#d9cfb4:s=1080x1440:d=$DURATION" \
  -vf "drawbox=x=0:y=0:w=1080:h=1440:color=#d9cfb4:t=fill, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf:text='$TITLE_ESCAPED':x=70:y=90:fontsize=84:fontcolor=black, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf:text='$SUBTITLE_ESCAPED':x=350:y=210:fontsize=56:fontcolor=black, \
 drawbox=x=360:y=380:w=360:h=520:color=#b5cb77:t=fill, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='CHANCE':x=470:y=620:fontsize=54:fontcolor=white, \
 drawbox=x=180:y=420:w=120:h=500:color=white:t=fill, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='10ml':x=830:y=690:fontsize=78:fontcolor=white, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf:text='СВЕЖЕСТЬ ЦИТРУСОВ':x=70:y=1010:fontsize=50:fontcolor=white, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf:text='НЕЖНОСТЬ ЦВЕТОВ':x=70:y=1090:fontsize=50:fontcolor=white, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf:text='ЛЕГКОСТЬ И ЭЛЕГАНТНОСТЬ':x=70:y=1170:fontsize=50:fontcolor=white" \
  -c:v mpeg4 -q:v 4 -r 30 "$OUT"; then
  fail "ffmpeg failed to render the video"
fi

echo "$OUT"
