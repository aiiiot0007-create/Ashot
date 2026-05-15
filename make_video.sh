#!/usr/bin/env bash
set -euo pipefail

TITLE="CHANCE EAU FRAICHE"
SUBTITLE="ЖЕНСКИЕ ДУХИ"
DURATION="15"
OUT="output/chance_eau_fraiche_3x4.mpeg4"
WIDTH=1080
HEIGHT=1440

FONT_SERIF_BOLD="${FONT_SERIF_BOLD:-/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf}"
FONT_SERIF="${FONT_SERIF:-/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf}"
FONT_SANS="${FONT_SANS:-/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf}"

usage() {
  cat <<'USAGE'
Usage:
  ./make_video.sh [options]

Options:
  --title TEXT       Main title text. Default: CHANCE EAU FRAICHE
  --subtitle TEXT    Subtitle text. Default: ЖЕНСКИЕ ДУХИ
  --duration SECS    Video duration in seconds. Default: 15
  --out PATH         Output file path. Default: output/chance_eau_fraiche_3x4.mpeg4
  -h, --help         Show this help message.

Examples:
  ./make_video.sh
  ./make_video.sh --title "CHANCE" --subtitle "ПРОМО 10ML" --duration 8 --out output/promo.mp4
USAGE
}

fail() {
  echo "Ошибка: $*" >&2
  exit 1
}

need_value() {
  local option="$1"
  local value="${2:-}"
  [[ -n "$value" ]] || fail "Для параметра ${option} нужно указать значение."
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title)
      need_value "$1" "${2:-}"
      TITLE="$2"
      shift 2
      ;;
    --subtitle)
      need_value "$1" "${2:-}"
      SUBTITLE="$2"
      shift 2
      ;;
    --duration)
      need_value "$1" "${2:-}"
      DURATION="$2"
      shift 2
      ;;
    --out)
      need_value "$1" "${2:-}"
      OUT="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Неизвестный параметр: $1. Запустите ./make_video.sh --help."
      ;;
  esac
done

command -v ffmpeg >/dev/null 2>&1 || fail "ffmpeg не найден. Установите ffmpeg и повторите запуск."
[[ "$DURATION" =~ ^[0-9]+([.][0-9]+)?$ ]] || fail "--duration должен быть числом секунд, например 15 или 7.5."
[[ -n "$OUT" ]] || fail "--out не может быть пустым."

for font in "$FONT_SERIF_BOLD" "$FONT_SERIF" "$FONT_SANS"; do
  [[ -f "$font" ]] || fail "Шрифт не найден: $font. Установите DejaVu или передайте путь через FONT_SERIF_BOLD, FONT_SERIF, FONT_SANS."
done

escape_drawtext() {
  local value="$1"
  value=${value//\\/\\\\}
  value=${value//:/\\:}
  value=${value//\'/\\\'}
  value=${value//%/\\%}
  printf '%s' "$value"
}

TITLE_ESC="$(escape_drawtext "$TITLE")"
SUBTITLE_ESC="$(escape_drawtext "$SUBTITLE")"
OUT_DIR="$(dirname "$OUT")"
mkdir -p "$OUT_DIR"

ffmpeg -y -f lavfi -i "color=c=#d9cfb4:s=${WIDTH}x${HEIGHT}:d=${DURATION}" \
-vf "drawbox=x=0:y=0:w=${WIDTH}:h=${HEIGHT}:color=#d9cfb4:t=fill, \
 drawtext=fontfile=${FONT_SERIF_BOLD}:text='${TITLE_ESC}':x=70:y=90:fontsize=84:fontcolor=black, \
 drawtext=fontfile=${FONT_SERIF}:text='${SUBTITLE_ESC}':x=350:y=210:fontsize=56:fontcolor=black, \
 drawbox=x=360:y=380:w=360:h=520:color=#b5cb77:t=fill, \
 drawtext=fontfile=${FONT_SANS}:text='CHANCE':x=470:y=620:fontsize=54:fontcolor=white, \
 drawbox=x=180:y=420:w=120:h=500:color=white:t=fill, \
 drawtext=fontfile=${FONT_SANS}:text='10ml':x=830:y=690:fontsize=78:fontcolor=white, \
 drawtext=fontfile=${FONT_SERIF}:text='СВЕЖЕСТЬ ЦИТРУСОВ':x=70:y=1010:fontsize=50:fontcolor=white, \
 drawtext=fontfile=${FONT_SERIF}:text='НЕЖНОСТЬ ЦВЕТОВ':x=70:y=1090:fontsize=50:fontcolor=white, \
 drawtext=fontfile=${FONT_SERIF}:text='ЛЕГКОСТЬ И ЭЛЕГАНТНОСТЬ':x=70:y=1170:fontsize=50:fontcolor=white" \
-t "$DURATION" -c:v mpeg4 -q:v 4 -r 30 "$OUT"

echo "$OUT"
