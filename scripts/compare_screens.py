#!/usr/bin/env python3
"""
compare_screens.py — сравнивает захваченные скриншоты с дизайн-референсами.

Использование:
    python3 scripts/compare_screens.py [--create-issue] [--threshold 60]

Зависимости:
    pip3 install Pillow
"""

import argparse
import json
import os
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

# ── Конфигурация ──────────────────────────────────────────────────────────────

REPO_ROOT = Path(__file__).parent.parent
DESIGN_DIR = REPO_ROOT / 'design_handoff_plantcare' / 'screenshots' / 'light'
CAPTURED_DIR = REPO_ROOT / 'screenshots' / 'captured'
DIFF_DIR = REPO_ROOT / 'screenshots' / 'diff'
REPORT_PATH = REPO_ROOT / 'screenshots' / 'design_check_report.md'

# Полные имена экранов по slug'у файла
SCREEN_NAMES: dict[str, str] = {
    '01-home': 'Главная — Мой сад',
    '02-plant-card': 'Карточка растения',
    '03-today': 'Сегодня',
    '04-add-step3': 'Мастер добавления — итог',
    '04a-add-step1': 'Мастер добавления — шаг 1',
    '04b-add-step2': 'Мастер добавления — шаг 2',
    '04c-add-step4': 'Мастер добавления — шаг 4',
    '05-push-notification': 'Push-уведомление (системный)',
    '06-water-sheet': 'Sheet — Полив',
    '06a-spray-sheet': 'Sheet — Опрыскивание',
    '06b-fert-sheet': 'Sheet — Удобрение',
    '07-auth-welcome': 'Auth — Добро пожаловать',
    '08-auth-telegram': 'Auth — Telegram-код (legacy)',
    '09-welcome-back': 'Auth — Снова здесь',
    '10-home-empty': 'Главная — Пустой сад',
    '11-week-calendar': 'График недели',
    '12-catalog': 'Каталог видов',
    '13-profile': 'Профиль',
    '14-monthly-report': 'Месячный отчёт',
    '15-diagnosis': 'Диагноз растения',
    '16-ai-doctor': 'AI-доктор',
    '17-archive': 'Архив',
    '18-propagation': 'Родословная',
    '19-shopping': 'Список покупок',
    '20-species-detail': 'Карточка вида',
    '21-care-history': 'История ухода',
    '22-edit-schedule': 'Редактирование расписания',
    '23-quiet-hours': 'Тихие часы',
    '24-notifications-inbox': 'Лента уведомлений',
    '25-vacation': 'Режим отпуска',
    '26-sharing': 'Совместный уход',
    '27-push-permission': 'Разрешение на пуш',
    '28-loading': 'Загрузка (скелетон)',
    '29-offline': 'Офлайн / ошибка сети',
    '30-empty-search': 'Пустой поиск каталога',
    '31-empty-journal': 'Пустой дневник',
    '32-empty-inbox': 'Пустая лента уведомлений',
    '33-first-care-success': 'Успех первого ухода',
    '34-rooms-homes': 'Дома и комнаты',
    '35-seasonal': 'Сезонные интервалы',
    '36-time-picker': 'Пикер времени (sheet)',
    '37-timezone': 'Выбор таймзоны',
    '38-language': 'Язык приложения',
}

# ── Типы данных ───────────────────────────────────────────────────────────────

@dataclass
class ScreenResult:
    slug: str            # e.g. '01-home'
    name: str            # e.g. 'Главная — Мой сад'
    design_path: Path
    captured_path: Path | None
    diff_path: Path | None
    similarity: float | None   # 0–100, None если не захвачен
    status: str                # '✅' | '⚠️' | '❌' | '🚫'
    notes: str = ''


# ── Сравнение изображений ─────────────────────────────────────────────────────

def _require_pil():
    try:
        from PIL import Image, ImageChops  # noqa: F401
    except ImportError:
        sys.exit(
            'Ошибка: Pillow не установлен.\n'
            'Установи: pip3 install Pillow\n'
        )


def compare_images(ref_path: Path, cap_path: Path, diff_path: Path) -> float:
    """
    Сравнивает два PNG. Возвращает similarity 0–100.
    Сохраняет side-by-side diff в diff_path.
    """
    from PIL import Image, ImageChops, ImageDraw, ImageFont

    ref = Image.open(ref_path).convert('RGB')
    cap = Image.open(cap_path).convert('RGB')

    # Нормализуем к размеру дизайн-референса
    if ref.size != cap.size:
        cap_cmp = cap.resize(ref.size, Image.LANCZOS)
    else:
        cap_cmp = cap

    # Пиксельная разница
    diff = ImageChops.difference(ref, cap_cmp)
    diff_data = list(diff.getdata())
    total = len(diff_data)
    # Пиксели, где хотя бы один канал отличается > 40 (значимое расхождение)
    significant = sum(1 for r, g, b in diff_data if max(r, g, b) > 40)
    diff_pct = significant / total * 100

    # Similarity: инвертируем diff_pct, масштабируем (коэф. 1.3 — дизайн/реальность
    # всегда расходятся по данным, поэтому смягчаем штраф)
    similarity = max(0.0, min(100.0, 100.0 - diff_pct * 1.3))

    # Генерируем side-by-side изображение: [дизайн | захвачено | разница]
    _save_comparison(ref, cap, diff, diff_path)

    return round(similarity, 1)


def _save_comparison(ref, cap, diff, out_path: Path):
    """Сохраняет тройное side-by-side изображение."""
    from PIL import Image, ImageDraw

    TARGET_H = 900
    GAP = 4
    HEADER_H = 30

    def _resize(img):
        w = int(img.width * TARGET_H / img.height)
        return img.resize((w, TARGET_H), Image.LANCZOS)

    ref_r = _resize(ref)
    cap_r = _resize(cap.resize(ref.size, Image.LANCZOS) if ref.size != cap.size else cap)
    diff_r = _resize(diff.resize(ref.size, Image.LANCZOS) if ref.size != diff.size else diff)

    total_w = ref_r.width + cap_r.width + diff_r.width + GAP * 2
    total_h = TARGET_H + HEADER_H

    canvas = Image.new('RGB', (total_w, total_h), (30, 30, 30))

    # Заголовки секций
    draw = ImageDraw.Draw(canvas)
    labels = [('Дизайн', 0), ('Захвачено', ref_r.width + GAP), ('Разница', ref_r.width + cap_r.width + GAP * 2)]
    for text, x in labels:
        draw.text((x + 6, 6), text, fill=(200, 200, 200))

    # Вставляем изображения под заголовками
    canvas.paste(ref_r, (0, HEADER_H))
    canvas.paste(cap_r, (ref_r.width + GAP, HEADER_H))
    # Усиливаем diff для видимости
    from PIL import ImageEnhance
    diff_bright = ImageEnhance.Brightness(diff_r).enhance(4)
    canvas.paste(diff_bright, (ref_r.width + cap_r.width + GAP * 2, HEADER_H))

    canvas.save(out_path)


def _status(similarity: float | None, threshold: float) -> str:
    if similarity is None:
        return '🚫'
    if similarity >= threshold:
        return '✅'
    if similarity >= threshold - 20:
        return '⚠️'
    return '❌'


# ── Генерация отчёта ──────────────────────────────────────────────────────────

def generate_report(results: list[ScreenResult], threshold: float) -> str:
    total = len(results)
    captured = sum(1 for r in results if r.captured_path is not None)
    ok = sum(1 for r in results if r.status == '✅')
    warn = sum(1 for r in results if r.status == '⚠️')
    fail = sum(1 for r in results if r.status == '❌')
    missing = sum(1 for r in results if r.status == '🚫')

    lines = [
        '# Design Check Report',
        '',
        f'> Порог схожести: **{threshold}%**  |  '
        f'Дизайн-референс: `design_handoff_plantcare/screenshots/light/`',
        '',
        '## Итог',
        '',
        f'| Экранов всего | Захвачено | ✅ Совпадает | ⚠️ Частично | ❌ Расходится | 🚫 Не захвачен |',
        f'|:---:|:---:|:---:|:---:|:---:|:---:|',
        f'| {total} | {captured} | {ok} | {warn} | {fail} | {missing} |',
        '',
        '## Результаты по экранам',
        '',
        '| # | Экран | Схожесть | Статус | Diff |',
        '|---|-------|---------|--------|------|',
    ]

    for r in results:
        sim_str = f'{r.similarity:.1f}%' if r.similarity is not None else '—'
        diff_link = ''
        if r.diff_path and r.diff_path.exists():
            rel = r.diff_path.relative_to(REPO_ROOT)
            diff_link = f'[diff]({rel})'
        slug_num = r.slug.split('-')[0]
        lines.append(
            f'| {slug_num} | {r.name} | {sim_str} | {r.status} | {diff_link} |'
        )

    lines += [
        '',
        '---',
        '',
        '### Обозначения',
        f'- ✅ схожесть ≥ {threshold}%',
        f'- ⚠️ схожесть {threshold - 20}–{threshold}%',
        f'- ❌ схожесть < {threshold - 20}%',
        '- 🚫 экран не захвачен (маршрут заблокирован бэком, требует данных, или пропущен)',
        '',
        '> **Важно:** пиксельная схожесть всегда занижена из-за разных данных',
        '> (реальные растения vs мокап-данные дизайна). Смотри diff-изображения.',
    ]

    return '\n'.join(lines)


# ── Создание GitHub Issue ─────────────────────────────────────────────────────

def create_github_issue(results: list[ScreenResult], threshold: float, report_path: Path):
    ok = sum(1 for r in results if r.status == '✅')
    warn = sum(1 for r in results if r.status == '⚠️')
    fail = sum(1 for r in results if r.status == '❌')
    missing = sum(1 for r in results if r.status == '🚫')
    total = len(results)

    # Таблица результатов для issue
    table_rows = []
    for r in results:
        sim_str = f'{r.similarity:.1f}%' if r.similarity is not None else '—'
        table_rows.append(f'| {r.slug} | {r.name} | {sim_str} | {r.status} |')

    # Список экранов, требующих проверки
    attention = [r for r in results if r.status in ('⚠️', '❌')]
    attention_list = '\n'.join(
        f'- [ ] **{r.slug}** — {r.name} ({r.similarity:.1f}%)'
        for r in attention
    ) or '_нет расхождений_'

    body = f"""## Результаты дизайн-ревью

| Всего | Захвачено | ✅ | ⚠️ | ❌ | 🚫 |
|:---:|:---:|:---:|:---:|:---:|:---:|
| {total} | {total - missing} | {ok} | {warn} | {fail} | {missing} |

> Порог схожести: **{threshold}%**
> Дизайн-референс: `design_handoff_plantcare/screenshots/light/`
> Полный отчёт: `{report_path.relative_to(REPO_ROOT)}`

### Все экраны

| Slug | Экран | Схожесть | Статус |
|------|-------|---------|--------|
{chr(10).join(table_rows)}

### Требуют проверки (⚠️ / ❌)

{attention_list}

### Как смотреть diff

```
open screenshots/diff/   # side-by-side: Дизайн | Захвачено | Разница
```

### Экраны без захвата (🚫)

Не захвачены по одной из причин:
- маршрут заблокирован бэком (см. `docs/SCREENS-PLAN.md`)
- требует реального ID растения/вида и данных в тест-аккаунте
- системный экран (push-пермишн, нотификация ОС)

Для повторного захвата: `./scripts/design_check.sh --skip-compare`

---
_Создано автоматически: `scripts/design_check.sh`_
"""

    cmd = [
        'gh', 'issue', 'create',
        '--title', f'[Design Review] Дизайн-чек: {ok}/{total} экранов совпадают',
        '--label', 'design-review',
        '--body', body,
    ]

    print('\n[compare] Создаю GitHub issue...')
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        print(f'[compare] Issue создан: {result.stdout.strip()}')
    except subprocess.CalledProcessError as e:
        # Label может отсутствовать — создаём его и повторяем
        if 'label' in e.stderr.lower() or 'not found' in e.stderr.lower():
            print('[compare] Метка design-review не найдена, создаю...')
            subprocess.run(
                ['gh', 'label', 'create', 'design-review',
                 '--color', '0075ca', '--description', 'UI/UX design review'],
                check=False,
            )
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            print(f'[compare] Issue создан: {result.stdout.strip()}')
        else:
            print(f'[compare] Ошибка gh: {e.stderr}', file=sys.stderr)
            raise


# ── Основная логика ───────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description='Design check: compare screenshots')
    parser.add_argument('--threshold', type=float, default=60.0,
                        help='Порог схожести для ✅ (default: 60)')
    parser.add_argument('--create-issue', action='store_true',
                        help='Создать GitHub issue с результатами')
    parser.add_argument('--no-diff', action='store_true',
                        help='Не генерировать diff-изображения')
    args = parser.parse_args()

    has_pil = True
    try:
        _require_pil()
    except SystemExit:
        has_pil = False
        print('WARNING: Pillow не установлен — сравнение изображений пропущено.')
        print('         Установи: pip3 install Pillow')

    DIFF_DIR.mkdir(parents=True, exist_ok=True)
    CAPTURED_DIR.mkdir(parents=True, exist_ok=True)

    # Собираем список дизайн-референсов
    design_pngs = sorted(DESIGN_DIR.glob('*.png'))
    if not design_pngs:
        sys.exit(f'Дизайн-референсы не найдены в {DESIGN_DIR}')

    results: list[ScreenResult] = []

    for design_path in design_pngs:
        slug = design_path.stem
        name = SCREEN_NAMES.get(slug, slug)
        captured_path = CAPTURED_DIR / design_path.name
        diff_path = DIFF_DIR / design_path.name

        if not captured_path.exists():
            results.append(ScreenResult(
                slug=slug, name=name,
                design_path=design_path,
                captured_path=None,
                diff_path=None,
                similarity=None,
                status='🚫',
                notes='не захвачен',
            ))
            continue

        similarity = None
        if has_pil and not args.no_diff:
            try:
                similarity = compare_images(design_path, captured_path, diff_path)
            except Exception as e:
                print(f'[compare] Ошибка сравнения {slug}: {e}')
                similarity = None

        status = _status(similarity, args.threshold)
        results.append(ScreenResult(
            slug=slug, name=name,
            design_path=design_path,
            captured_path=captured_path,
            diff_path=diff_path if not args.no_diff else None,
            similarity=similarity,
            status=status,
        ))

    # Сортируем: сначала пойманные с расхождениями, потом остальные
    results.sort(key=lambda r: (
        {'❌': 0, '⚠️': 1, '✅': 2, '🚫': 3}[r.status],
        r.slug,
    ))

    # Пересортировка: выводим в порядке slug для читаемости
    results.sort(key=lambda r: r.slug)

    # Отчёт
    report_md = generate_report(results, args.threshold)
    REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
    REPORT_PATH.write_text(report_md, encoding='utf-8')
    print(f'\n[compare] Отчёт → {REPORT_PATH}')

    # Консольный итог
    ok = sum(1 for r in results if r.status == '✅')
    warn = sum(1 for r in results if r.status == '⚠️')
    fail = sum(1 for r in results if r.status == '❌')
    miss = sum(1 for r in results if r.status == '🚫')
    print(f'\n✅ {ok}  ⚠️ {warn}  ❌ {fail}  🚫 {miss} из {len(results)} экранов')

    if args.create_issue:
        create_github_issue(results, args.threshold, REPORT_PATH)

    # Открыть diff-папку (macOS)
    if has_pil and not args.no_diff and sys.platform == 'darwin':
        subprocess.run(['open', str(DIFF_DIR)], check=False)


if __name__ == '__main__':
    main()
