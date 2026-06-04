#!/usr/bin/env python3
"""Генератор иконки приложения PlantCare.

Источник правды для launcher-иконки: рисует один брендовый лист на
тёмно-зелёном фоне в стиле иллюстраций проекта (assets/illustrations/*.svg) и
раскладывает PNG-и по платформам.

Палитра — из lib/core/theme/tokens.dart (светлая тема):
  primary    #3F6B3A   фон
  leaf       #6F8A4F   стебель / задний лист
  leafLight  #A8C081   основной лист
  bg/cream   #F1ECE0   прожилки/блик

Запуск (нужен только Pillow):
    python3 tool/generate_app_icon.py

Перегенерация платформенных иконок «как у всех» — через flutter_launcher_icons
(см. секцию flutter_launcher_icons в pubspec.yaml), он читает assets/branding/app_icon.png.
"""

from __future__ import annotations

import math
import os
from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# --- палитра бренда ---------------------------------------------------------
PRIMARY = (0x3F, 0x6B, 0x3A)
HALO = (0x4A, 0x79, 0x42)      # чуть светлее фона, мягкий круг за листом
LEAF = (0x6F, 0x8A, 0x4F)
LEAF_LIGHT = (0xA8, 0xC0, 0x81)
LEAF_DARK = (0x3F, 0x5A, 0x2E)
CREAM = (0xF1, 0xEC, 0xE0)

SS = 4  # суперсэмплинг


def _leaf_outline(cx: float, cy: float, half_h: float, half_w: float, n: int = 220):
    """Точки контура «листа-линзы» (пересечение двух окружностей)."""
    h, w = half_h, half_w
    e = (h * h - w * w) / (2 * w) if w else 0.0  # смещение центров
    r = w + e                                     # радиус (r^2 = e^2 + h^2)
    alpha = math.atan2(h, e)
    pts = []
    # правый край: дуга левой окружности, сверху вниз
    for i in range(n + 1):
        th = -alpha + (2 * alpha) * i / n
        pts.append((cx - e + r * math.cos(th), cy + r * math.sin(th)))
    # левый край: дуга правой окружности, снизу вверх
    for i in range(n + 1):
        th = (math.pi - alpha) + (2 * alpha) * i / n
        pts.append((cx + e + r * math.cos(th), cy + r * math.sin(th)))
    return pts


def _draw_leaf(size: int) -> Image.Image:
    """Прозрачный слой с листом и стеблем (вертикально, по центру)."""
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    cx = size / 2
    cy = size * 0.46
    half_h = size * 0.32
    half_w = size * 0.155

    # стебель — мягко изогнутая сужающаяся «капля» вниз от основания листа
    base_y = cy + half_h
    stem_top = base_y - size * 0.02
    stem_bot = base_y + size * 0.16
    d.line(
        [(cx, stem_top), (cx - size * 0.006, (stem_top + stem_bot) / 2), (cx, stem_bot)],
        fill=LEAF, width=int(size * 0.022), joint="curve",
    )

    # сам лист
    outline = _leaf_outline(cx, cy, half_h, half_w)
    d.polygon(outline, fill=LEAF_LIGHT)

    # центральная прожилка
    d.line(
        [(cx, cy + half_h * 0.86), (cx, cy - half_h * 0.92)],
        fill=LEAF_DARK, width=max(2, int(size * 0.012)),
    )
    # боковые прожилки
    vein_w = max(1, int(size * 0.0075))
    for frac, reach in ((0.42, 0.66), (0.16, 0.74), (-0.12, 0.66), (-0.4, 0.5)):
        vy = cy - half_h * frac
        spread = half_w * reach
        drop = half_h * 0.16
        d.line([(cx, vy), (cx - spread, vy + drop)], fill=LEAF_DARK, width=vein_w)
        d.line([(cx, vy), (cx + spread, vy + drop)], fill=LEAF_DARK, width=vein_w)

    return layer.rotate(-10, resample=Image.BICUBIC, center=(cx, cy))


def render_master(px: int) -> Image.Image:
    """Полноразмерная квадратная иконка (без скруглений — маску даёт ОС)."""
    work = px * SS
    img = Image.new("RGBA", (work, work), PRIMARY + (255,))
    d = ImageDraw.Draw(img)

    # мягкий круг-ореол за листом для глубины
    r = work * 0.40
    cx = cy = work / 2
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=HALO + (255,))

    img.alpha_composite(_draw_leaf(work))
    return img.resize((px, px), Image.LANCZOS)


# --- раскладка по платформам ------------------------------------------------
ANDROID = {  # res-папка -> размер
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

IOS = {  # имя файла -> размер
    "Icon-App-20x20@1x.png": 20,
    "Icon-App-20x20@2x.png": 40,
    "Icon-App-20x20@3x.png": 60,
    "Icon-App-29x29@1x.png": 29,
    "Icon-App-29x29@2x.png": 58,
    "Icon-App-29x29@3x.png": 87,
    "Icon-App-40x40@1x.png": 40,
    "Icon-App-40x40@2x.png": 80,
    "Icon-App-40x40@3x.png": 120,
    "Icon-App-60x60@2x.png": 120,
    "Icon-App-60x60@3x.png": 180,
    "Icon-App-76x76@1x.png": 76,
    "Icon-App-76x76@2x.png": 152,
    "Icon-App-83.5x83.5@2x.png": 167,
    "Icon-App-1024x1024@1x.png": 1024,
}


def main() -> None:
    master = render_master(1024)
    branding = os.path.join(ROOT, "assets", "branding")
    os.makedirs(branding, exist_ok=True)
    master.convert("RGB").save(os.path.join(branding, "app_icon.png"))

    android_res = os.path.join(ROOT, "android", "app", "src", "main", "res")
    for folder, sz in ANDROID.items():
        out = os.path.join(android_res, folder, "ic_launcher.png")
        master.resize((sz, sz), Image.LANCZOS).save(out)

    ios_dir = os.path.join(
        ROOT, "ios", "Runner", "Assets.xcassets", "AppIcon.appiconset"
    )
    for name, sz in IOS.items():
        # iOS не допускает альфу в иконках
        master.resize((sz, sz), Image.LANCZOS).convert("RGB").save(
            os.path.join(ios_dir, name)
        )

    print("app icon generated: master + %d android + %d ios" % (len(ANDROID), len(IOS)))


if __name__ == "__main__":
    main()
