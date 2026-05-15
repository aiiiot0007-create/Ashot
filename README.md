# Ashot

Небольшой проект для генерации рекламного вертикального видео (формат **3:4**) с помощью `ffmpeg`.

Скрипт `make_video.sh` собирает ролик из однотонного фона и набора текстовых/графических слоёв (`drawbox`, `drawtext`):
- заголовок (по умолчанию `CHANCE EAU FRAICHE`);
- подпись под заголовком (по умолчанию `ЖЕНСКИЕ ДУХИ`);
- декоративные блоки;
- промо-тексты о запахе;
- отметка объёма `10ml`.

## Зависимости

Для запуска нужен:
- **bash** (скрипт использует `set -euo pipefail`);
- **ffmpeg** с поддержкой фильтров `drawtext` и `drawbox`;
- шрифты DejaVu, доступные по путям:
  - `/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf`
  - `/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf`
  - `/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf`

> Если `ffmpeg` не установлен или недоступен в `PATH`, скрипт завершится с понятной ошибкой.

## Параметры запуска

```bash
./make_video.sh [--title TEXT] [--subtitle TEXT] [--duration SEC] [--out PATH]
```

- `--title` — заголовок (строка);
- `--subtitle` — подзаголовок (строка);
- `--duration` — длительность в секундах (положительное число, можно дробное);
- `--out` — путь к выходному файлу.

Также доступно:

```bash
./make_video.sh --help
```

## Примеры

1. Запуск с параметрами по умолчанию:
   ```bash
   ./make_video.sh
   ```
   Результат: `output/chance_eau_fraiche_3x4.mpeg4`

2. Свой заголовок и подзаголовок:
   ```bash
   ./make_video.sh --title "SPRING BLOSSOM" --subtitle "ЖЕНСКИЕ ДУХИ"
   ```

3. Короткий ролик на 7.5 секунд:
   ```bash
   ./make_video.sh --duration 7.5
   ```

4. Свой путь выходного файла:
   ```bash
   ./make_video.sh --out output/my_ad.mpeg4
   ```

5. Полностью кастомный запуск:
   ```bash
   ./make_video.sh \
     --title "OCEAN BREEZE" \
     --subtitle "СВЕЖИЙ АРОМАТ" \
     --duration 12 \
     --out output/ocean_breeze_3x4.mpeg4
   ```

## Структура проекта

- `make_video.sh` — основной скрипт сборки видео.
- `README.md` — описание проекта и инструкции по запуску.
