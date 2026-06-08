#!/usr/bin/env bash
# scripts/bump_version.sh — ручной бамп версии в pubspec.yaml.
#
# Использование:
#   ./scripts/bump_version.sh [patch|minor|major]
#
# По умолчанию: patch.
# Пример: ./scripts/bump_version.sh minor
#
# После бампа создайте git-тег, чтобы запустить CD:
#   git add pubspec.yaml
#   git commit -m "chore: bump version to $(grep '^version:' pubspec.yaml | cut -d' ' -f2)"
#   git tag v$(grep '^version:' pubspec.yaml | sed 's/version: //;s/+.*//')
#   git push origin main --tags
#
# В CI (GitHub Actions) build number (после '+') = GITHUB_RUN_NUMBER
# и выставляется автоматически (см. .github/workflows/cd.yml job bump-version).
# Здесь мы оставляем build number как 0 (будет перезаписан в CI).

set -euo pipefail

PUBSPEC="$(dirname "$0")/../pubspec.yaml"

if [ ! -f "$PUBSPEC" ]; then
  echo "Error: pubspec.yaml not found at $PUBSPEC" >&2
  exit 1
fi

# Читаем текущую версию
CURRENT=$(grep '^version:' "$PUBSPEC" | sed 's/version: //;s/+.*//')
if [ -z "$CURRENT" ]; then
  echo "Error: cannot parse version from pubspec.yaml" >&2
  exit 1
fi

MAJOR=$(echo "$CURRENT" | cut -d. -f1)
MINOR=$(echo "$CURRENT" | cut -d. -f2)
PATCH=$(echo "$CURRENT" | cut -d. -f3)

BUMP="${1:-patch}"

case "$BUMP" in
  patch)
    PATCH=$((PATCH + 1))
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  *)
    echo "Error: unknown bump type '$BUMP'. Use patch, minor, or major." >&2
    exit 1
    ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}+0"

# Заменяем строку version: в pubspec.yaml
if [[ "$(uname)" == "Darwin" ]]; then
  sed -i '' "s/^version: .*/version: ${NEW_VERSION}/" "$PUBSPEC"
else
  sed -i "s/^version: .*/version: ${NEW_VERSION}/" "$PUBSPEC"
fi

NEW_CLEAN="${MAJOR}.${MINOR}.${PATCH}"
echo "Version bumped: ${CURRENT} → ${NEW_CLEAN} (build number will be set by CI)"
echo ""
echo "Next steps:"
echo "  git add pubspec.yaml"
echo "  git commit -m \"chore: bump version to ${NEW_CLEAN}\""
echo "  git tag v${NEW_CLEAN}"
echo "  git push origin main --tags"
