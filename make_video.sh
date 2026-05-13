#!/usr/bin/env bash
set -euo pipefail
mkdir -p output
OUT="output/chance_eau_fraiche_3x4.mpeg4"
ffmpeg -y -f lavfi -i "color=c=#d9cfb4:s=1080x1440:d=15" \
-vf "drawbox=x=0:y=0:w=1080:h=1440:color=#d9cfb4:t=fill, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf:text='CHANCE EAU FRAICHE':x=70:y=90:fontsize=84:fontcolor=black, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf:text='ЖЕНСКИЕ ДУХИ':x=350:y=210:fontsize=56:fontcolor=black, \
 drawbox=x=360:y=380:w=360:h=520:color=#b5cb77:t=fill, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='CHANCE':x=470:y=620:fontsize=54:fontcolor=white, \
 drawbox=x=180:y=420:w=120:h=500:color=white:t=fill, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='10ml':x=830:y=690:fontsize=78:fontcolor=white, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf:text='СВЕЖЕСТЬ ЦИТРУСОВ':x=70:y=1010:fontsize=50:fontcolor=white, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf:text='НЕЖНОСТЬ ЦВЕТОВ':x=70:y=1090:fontsize=50:fontcolor=white, \
 drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf:text='ЛЕГКОСТЬ И ЭЛЕГАНТНОСТЬ':x=70:y=1170:fontsize=50:fontcolor=white" \
-c:v mpeg4 -q:v 4 -r 30 "$OUT"
echo "$OUT"
