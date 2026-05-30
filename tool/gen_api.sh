#!/usr/bin/env bash
# Пайплайн кодгена API-клиента из OpenAPI (MADR-007).
#
#   bundle  : api/openapi/*.yaml (многофайловая спека) → api/openapi.bundled.json
#   client  : swagger_parser → lib/core/api/generated/ (Retrofit + json_serializable)
#   .g.dart : build_runner → реализации Retrofit/json
#
# Источник правды — статическая курированная спека из репозитория plants-care
# (api/openapi/, закоммичена). Рантайм /v3/api-docs (springdoc) НЕ годится как
# вход: он не документирует заголовки X-User-Id/X-Chat-Id и query-параметры
# (PoC резолвит их мимо OpenAPI-аннотаций) и отдаёт пустую схему для /calendar.
#
# Обновить статическую спеку из GitHub:
#   ./tool/gen_api.sh --fetch                 # из ветки main (по умолчанию)
#   ./tool/gen_api.sh --fetch --branch develop # из произвольной ветки
# Ветку также можно задать через PC_BRANCH. Бэкенд ведёт разработку в develop и
# мёржит в main пачками, поэтому свежие эндпоинты часто доступны только в develop.
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="$HOME/development/flutter/bin:$PATH"

BRANCH="${PC_BRANCH:-main}"
args=("$@")
for ((i=0; i<${#args[@]}; i++)); do
  if [[ "${args[$i]}" == "--branch" ]]; then BRANCH="${args[$((i+1))]:-}"; fi
done

if [[ " ${args[*]:-} " == *" --fetch "* ]]; then
  echo "==> fetch OpenAPI files from plants-care@${BRANCH}"
  BASE="https://raw.githubusercontent.com/antonkupreychik/plants-care/${BRANCH}"
  PREFIX="src/main/resources/openapi"
  curl -sS --max-time 30 "https://api.github.com/repos/antonkupreychik/plants-care/git/trees/${BRANCH}?recursive=1" -o /tmp/pc_tree.json
  python3 - "$PREFIX" <<'PY' > /tmp/pc_paths.txt
import json,sys
t=json.load(open('/tmp/pc_tree.json')); pre=sys.argv[1]
print('\n'.join(i['path'] for i in t['tree']
      if i['path'].startswith(pre) and i['path'].endswith(('.yaml','.yml'))))
PY
  while IFS= read -r p; do
    [ -z "$p" ] && continue
    dest="api/openapi/${p#$PREFIX/}"; mkdir -p "$(dirname "$dest")"
    curl -sS --max-time 30 -o "$dest" "$BASE/$p"
  done < /tmp/pc_paths.txt
fi

echo "==> bundle"
dart run tool/bundle_openapi.dart

echo "==> swagger_parser"
dart run swagger_parser

echo "==> build_runner"
dart run build_runner build --delete-conflicting-outputs

echo "==> done. Generated → lib/core/api/generated/"
