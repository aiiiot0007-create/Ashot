#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./make_video.sh path/to/photo.jpg
# Output:
#   output/gaba_crooked_3x4_iphone.mp4

IN_FILE="${1:-}"
if [[ -z "$IN_FILE" || ! -f "$IN_FILE" ]]; then
  echo "Укажи путь к фото: ./make_video.sh path/to/photo.jpg" >&2
  exit 1
fi

mkdir -p output
OUT="output/gaba_crooked_3x4_iphone.mp4"

ffmpeg -y -loop 1 -i "$IN_FILE" -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -t 15 \
-vf "scale=1200:1600:force_original_aspect_ratio=increase, \
     crop=1080:1440:(iw-1080)/2:(ih-1440)/2, \
     rotate='0.03*sin(2*PI*t/2.4)':ow=1080:oh=1440:c=black, \
     crop=1040:1380:20+10*sin(2*PI*t/1.3):30+8*cos(2*PI*t/1.7), \
     scale=1080:1440, \
     eq=saturation=1.15:contrast=1.08:brightness=0.02, \
     unsharp=5:5:0.8, \
     drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='GABA':x=(w-text_w)/2:y=80:fontsize=92:fontcolor=white@0.85:shadowx=2:shadowy=2, \
     drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='кривое видео':x=(w-text_w)/2:y=h-120:fontsize=46:fontcolor=white@0.9:shadowx=2:shadowy=2" \
-c:v libx264 -profile:v high -level 4.0 -pix_fmt yuv420p -r 30 \
-c:a aac -b:a 128k -shortest -movflags +faststart "$OUT"

echo "$OUT"
