#!/usr/bin/env bash
# scripts/design_check.sh
#
# Полный дизайн-чек: захват скриншотов с эмулятора → сравнение с дизайном
# → отчёт + GitHub issue.
#
# Использование:
#   ./scripts/design_check.sh                  # полный прогон
#   ./scripts/design_check.sh --skip-capture   # только сравнение (уже есть скриншоты)
#   ./scripts/design_check.sh --create-issue   # создать GitHub issue после сравнения
#   ./scripts/design_check.sh --threshold 50   # другой порог схожести (default: 60)
#   ./scripts/design_check.sh --help
set -euo pipefail

# ── Флаги ────────────────────────────────────────────────────────────────────
SKIP_CAPTURE=false
CREATE_ISSUE=false
THRESHOLD=60

for arg in "$@"; do
  case "$arg" in
    --skip-capture)  SKIP_CAPTURE=true ;;
    --create-issue)  CREATE_ISSUE=true ;;
    --threshold=*)   THRESHOLD="${arg#*=}" ;;
    --help|-h)
      grep '^#' "$0" | sed 's/^# //' | sed 's/^#//'
      exit 0
      ;;
    *) echo "Неизвестный аргумент: $arg" >&2; exit 1 ;;
  esac
done

# ── Пути ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

export PATH="$HOME/development/flutter/bin:$PATH"
FLUTTER="$HOME/development/flutter/bin/flutter"

CAPTURED_DIR="$PROJECT_ROOT/screenshots/captured"
DIFF_DIR="$PROJECT_ROOT/screenshots/diff"
REPORT="$PROJECT_ROOT/screenshots/design_check_report.md"

# ── Dev-токены (из run-dev.sh) ────────────────────────────────────────────────
API_URL="${API_URL:-https://plants-care-development.up.railway.app}"
ACCESS_TOKEN="${ACCESS_TOKEN:-eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3BsYW50cy1jYXJlLWRldmVsb3BtZW50LnVwLnJhaWx3YXkuYXBwIiwic3ViIjoiMTEyOCIsInR5cCI6ImFjY2VzcyIsImV4cCI6MTc4MDQ0NjEyOCwiaWF0IjoxNzgwNDQyNTI4fQ.rk5lhQ-O_NqpIJ3tQFA8YOO5crqp_AwLgwjmqfafZq4}"
REFRESH_TOKEN="${REFRESH_TOKEN:-eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3BsYW50cy1jYXJlLWRldmVsb3BtZW50LnVwLnJhaWx3YXkuYXBwIiwic3ViIjoiMTEyOCIsInR5cCI6InJlZnJlc2giLCJleHAiOjE3ODMwMzQ1MjgsImlhdCI6MTc4MDQ0MjUyOCwianRpIjoiNWQyNjM0ODgtZWVlMy00OTI2LTk1OWQtZGFkMTMxZTczM2E3In0.4dt_ZA7uUF3Ko2zyl_BfpPav2KpFqh7REZXL78LkjC0}"

# ── Утилиты ───────────────────────────────────────────────────────────────────
log()  { echo ""; echo "▶ $*"; }
step() { echo "  $*"; }
ok()   { echo "  ✓ $*"; }
err()  { echo "  ✗ $*" >&2; }

# ── Предпроверки ──────────────────────────────────────────────────────────────
log "Проверка зависимостей"

if ! command -v "$FLUTTER" &>/dev/null; then
  err "Flutter не найден: $FLUTTER"
  err "Убедись, что Flutter 3.44+ установлен в ~/development/flutter"
  exit 1
fi
ok "Flutter: $("$FLUTTER" --version --machine 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('frameworkVersion','?'))" 2>/dev/null || echo '?')"

# Проверяем доступность устройства
DEVICES=$("$FLUTTER" devices --machine 2>/dev/null | python3 -c "
import sys, json
devs = json.load(sys.stdin)
avail = [d for d in devs if d.get('isSupported') and d.get('id','') not in ('macos','windows','linux','chrome')]
print(len(avail))
" 2>/dev/null || echo "0")

if [[ "$DEVICES" == "0" ]] && [[ "$SKIP_CAPTURE" == "false" ]]; then
  log "Нет подключённых устройств/эмуляторов"
  step "Запусти iOS-симулятор: open -a Simulator"
  step "Или Android AVD: Android Studio → Device Manager"
  step "Или пропусти захват: --skip-capture"
  err "Подключи устройство и повтори запуск"
  exit 1
fi

# Pillow
if ! python3 -c "from PIL import Image" &>/dev/null 2>&1; then
  log "Установка Pillow"
  pip3 install Pillow --quiet --break-system-packages 2>/dev/null || pip3 install Pillow --quiet --user 2>/dev/null || true
  ok "Pillow установлен"
fi

# ── Создаём директории ────────────────────────────────────────────────────────
mkdir -p "$CAPTURED_DIR" "$DIFF_DIR"

# ── Шаг 1: Захват скриншотов ─────────────────────────────────────────────────
if [[ "$SKIP_CAPTURE" == "false" ]]; then
  log "Шаг 1/3: Захват скриншотов (flutter drive)"
  step "Маршрут: integration_test/design_check_test.dart"
  step "Выход:   $CAPTURED_DIR/"
  step "Ожидаемое время: ~5–8 минут"
  echo ""

  cd "$PROJECT_ROOT"
  "$FLUTTER" drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/design_check_test.dart \
    --dart-define=API_URL="$API_URL" \
    --dart-define=ACCESS_TOKEN="$ACCESS_TOKEN" \
    --dart-define=REFRESH_TOKEN="$REFRESH_TOKEN"

  CAPTURED_COUNT=$(find "$CAPTURED_DIR" -name '*.png' | wc -l | tr -d ' ')
  ok "Захвачено скриншотов: $CAPTURED_COUNT"
else
  log "Шаг 1/3: Захват пропущен (--skip-capture)"
  CAPTURED_COUNT=$(find "$CAPTURED_DIR" -name '*.png' 2>/dev/null | wc -l | tr -d ' ')
  step "Используем уже захваченные: $CAPTURED_COUNT скриншотов"
fi

# ── Шаг 2: Сравнение с дизайном ──────────────────────────────────────────────
log "Шаг 2/3: Сравнение с дизайн-референсами"
step "Дизайн: design_handoff_plantcare/screenshots/light/"
step "Diff:   $DIFF_DIR/"

cd "$PROJECT_ROOT"
ISSUE_FLAG=""
[[ "$CREATE_ISSUE" == "true" ]] && ISSUE_FLAG="--create-issue"

python3 scripts/compare_screens.py \
  --threshold "$THRESHOLD" \
  $ISSUE_FLAG

# ── Шаг 3: Отчёт ─────────────────────────────────────────────────────────────
log "Шаг 3/3: Итоги"
step "Отчёт: $REPORT"

if [[ -f "$REPORT" ]]; then
  # Краткая сводка из отчёта
  grep -A1 "Итог" "$REPORT" | head -5 | sed 's/^/  /'
fi

echo ""
echo "Следующие шаги:"
echo "  1. Открой diff-изображения:  open $DIFF_DIR"
echo "  2. Прочитай отчёт:           open $REPORT"
if [[ "$CREATE_ISSUE" == "false" ]]; then
  echo "  3. Создай issue:             $0 --skip-capture --create-issue"
fi
echo ""
