# Sprint 1 (Flutter) · Bootstrap мобильного приложения

> Перевод `SPRINT-1.md` (написан под Expo / React Native) на реальный стек проекта —
> **Flutter** (см. `../FLUTTER.md`): Riverpod / go_router / dio / freezed / drift, Clean Architecture.
> Хэндофф (`README.md`, `api-contract.md`, `design/*.jsx`) используется как **дизайн- и API-референс**;
> его RN-специфичные инструкции здесь транслированы на Flutter-эквиваленты.

**Цель спринта (без изменений):** debug-build на iOS-симуляторе и Android-эмуляторе, где можно
открыть карточку растения, нажать «Полить», и реальный `POST /api/v1/care-events` уйдёт в backend `plants-care`.

---

## 0. Решения перед стартом

- **Auth: вариант А (dev-hack).** Заголовки `X-Chat-Id` / `X-User-Id` через `--dart-define`
  (а не `.env`, как в RN-версии). Экраны 07/08 — заглушки. Telegram magic-link (вариант Б) —
  отдельный issue на спринт 3.

## 0.5. Зафиксировать архитектуру (обязательный шаг, гейт из FLUTTER.md)

`FLUTTER.md` помечен `СТАТУС: СКЕЛЕТ`, значения — `[PROPOSED]`. Фича-агентов запускать нельзя,
пока `flutter-architect` не подтвердит решения и не зафиксирует их как ADR. На этом шаге закрыть:

- версии Flutter SDK / Dart и всех пакетов (проверить на pub.dev, не по памяти);
- **CI/CD:** Codemagic vs GitHub Actions;
- **локализация:** ru-only vs ru+en с первого дня;
- **способ генерации API-клиента** (см. шаг 3): кодген dart-dio из OpenAPI vs ручные DTO на freezed.

---

## 1. Инструменты

```bash
# Flutter SDK (текущий stable) + Dart
# Xcode из App Store — iOS-симулятор
# Android Studio + AVD — Android-эмулятор

flutter create plantcare_mobile --org <org> --platforms ios,android
cd plantcare_mobile
flutter run   # выбрать устройство
```

EAS CLI / `create-expo-app` не нужны.

---

## 2. Зависимости (перевод пакетов RN → Flutter)

| Назначение        | RN (хэндофф)                  | Flutter                                                                 |
|-------------------|-------------------------------|-------------------------------------------------------------------------|
| Навигация         | expo-router                   | `go_router`                                                             |
| Server state      | TanStack Query                | `riverpod` + AsyncNotifier (прямого аналога нет — кеш/инвалидация на провайдерах) |
| UI state          | Zustand                       | `flutter_riverpod` (Notifier)                                          |
| HTTP              | axios                         | `dio`                                                                  |
| Модели / DTO      | —                             | `freezed` + `json_serializable`                                        |
| OpenAPI-клиент    | openapi-ts                    | `swagger_parser` или `openapi-generator` (dart-dio) — решить в 0.5     |
| SVG               | react-native-svg              | `flutter_svg`                                                          |
| Шрифты            | @expo-google-fonts/*          | `google_fonts` (оба шрифта есть) или bundled `.ttf` через `assets`     |
| Secure storage    | expo-secure-store             | `flutter_secure_storage`                                               |
| Bottom sheet      | @gorhom/bottom-sheet          | нативный `showModalBottomSheet` (Material 3)                           |
| UUID              | expo-crypto                   | `uuid`                                                                 |
| Offline           | (нет в Sprint 1 RN)           | `drift` — каркас, наполнение позже                                     |
| Codegen           | —                             | `build_runner` (riverpod, freezed, json_serializable, drift)          |

Точные версии — в `pubspec.yaml`, проверять на pub.dev перед использованием API пакета.

---

## 3. API-клиент из OpenAPI

Источник правды тот же: `openapi.yaml` из репозитория `antonkupreychik/plants-care`.

```bash
mkdir -p api
curl -o api/openapi.yaml \
  https://raw.githubusercontent.com/antonkupreychik/plants-care/main/src/main/resources/openapi/openapi.yaml
# OpenAPI разбит через $ref — при необходимости собрать в один файл (swagger-cli bundle).
```

Затем сгенерировать **dart-dio** клиент (вместо `npx openapi-ts`). Решение
«кодген vs ручные DTO на freezed» принимается на шаге 0.5 (`flutter-architect`).

---

## 4. Структура проекта (feature-first из FLUTTER.md, вместо `app/(tabs)/`)

```
lib/
├── core/
│   ├── network/      # dio instance + interceptor (X-Chat-Id / X-User-Id), ApiError
│   ├── router/       # go_router (роуты вместо файловой навигации expo-router)
│   ├── theme/        # tokens.dart (PC_THEMES) + ThemeData light/dark
│   ├── storage/      # drift database (каркас)
│   └── errors/
├── features/
│   ├── home/         # 01 Home        — data / domain / presentation
│   ├── plant_card/   # 02 Plant card
│   ├── care_event/   # 06 Water sheet (мутация POST /care-events)
│   └── auth/         # 07/09 заглушки
└── main_dev.dart / main_prod.dart   # entrypoints на flavor
```

Иллюстрации растений (Monstera / Fern / Succulent / Pothos / Cactus) и компонент `Icon`
из `design/screens.jsx` переносятся через `flutter_svg` (вместо react-native-svg),
имена иконок сохраняются (`drop`, `spray`, `fert`, `sun`, `bell`, `home`, …).

Фича не импортит из presentation другой фичи; общее — только через `core/`.

---

## 5. Design tokens

`PC_THEMES` из `README.md` (§6) / `design/screens.jsx` → `core/theme/tokens.dart` как
записи `light` / `dark`, поверх — два `ThemeData` (Material 3). Переключение по
`MediaQuery.platformBrightness`. Значения финальные:

```
light: bg #F1ECE0 · surface #FBF7EC · surfaceWarm #EDE5D2 · ink #1F2A1E ·
       primary #3F6B3A · terracotta #C77B5C · leaf #6F8A4F · pot #B9876B · …
dark:  симметрично (screens.jsx, строки 25–45)
```

Типографика: `Instrument Serif` (заголовки/voice line, italic), `Plus Jakarta Sans` (UI).

---

## 6. API-клиент — две «головы» и идемпотентность (ловушки переносятся 1:1)

`dio` interceptor подставляет заголовки из `--dart-define`:

- `X-Chat-Id` → `/today`, `/calendar`, `/care-events`, `/plants/{id}/history`, `/stats/streak`;
- `X-User-Id` → `/plants`, `/locations`;
- публичные `/species`, `/care-types`, `/health` — без заголовков.

Ловушки из api-contract.md:

- **`taskType` ≠ `type`:** в `/today` это `WATERING/MISTING/FERTILIZING`, в `/care-events` —
  `WATER/SPRAY/FERTILIZE`. Нужен явный маппинг (или справочник `/care-types`).
- **Идемпотентность:** `POST /care-events` всегда с `clientId = Uuid().v4()`, иначе двойной
  тап на flaky-сети создаст два полива.
- **`/calendar` ≤ 60 дней.**
- **Soft-delete:** `DELETE /plants/{id}` ставит `archivedAt`; растение исчезает из списков,
  просмотр архива пока недоступен (gap).

`--dart-define` (dev):

```
API_URL=https://plants-care.up.railway.app
CHAT_ID=9000001
USER_ID=1
```

---

## 7. Пять экранов (тот же порядок, что в RN-плане)

- **День 1 — 01 Home** (`features/home`): `GET /today` + `/plants` + `/locations` через
  Riverpod AsyncNotifier-провайдеры. Header, today-карточка, чипы комнат, сетка растений 2×N,
  FAB, BottomNav. DiagnosisAlert / WeatherStrip — заглушки (gap в API). Skeleton + error states.
- **День 2 — 02 Plant card** (`features/plant_card`): `GET /plants/{id}` + `/history?limit=10`
  + `/stats/streak`. Hero, speech bubble, дневник, бейджи. Schedules / health / toxicity —
  заглушки (gap).
- **День 3 — 06 Water sheet** (`features/care_event`): `showModalBottomSheet`, слайдер мл,
  quick-chips, «полил задним числом» (`performedAt`). Мутация `POST /care-events`; после успеха
  инвалидация провайдеров `today` / `plant(id)` / `history(id)` / `streak(id)`.
- **День 3.5 — 07/09 заглушки** (`features/auth`): «auth пропущен в debug», кнопка →
  `context.go('/home')`. Полная вёрстка 07/09 + реальный auth — спринт 3.

---

## 8. Перед концом спринта — checklist

- [ ] Запускается на iOS-симуляторе и Android-эмуляторе.
- [ ] Шрифты загружены (Plus Jakarta Sans, Instrument Serif).
- [ ] Тема переключается по системной (light / dark).
- [ ] `flutter analyze` чисто + `flutter test` зелёное (требование FLUTTER.md).
- [ ] `GET /today` отдаёт реальные данные (если в БД есть растения под `X-Chat-Id`).
- [ ] Экран 01 показывает реальный список растений.
- [ ] Экран 02 показывает реальную карточку.
- [ ] «Полить» → `POST /care-events` → запись появляется в дневнике.
- [ ] Идемпотентность: двойной тап не создаёт две записи (одинаковый `clientId`).
- [ ] Skeleton / loading / error states нарисованы хотя бы скелетно.

---

## 9. Дальше (Sprint 2+)

Сетка спринтов из оригинального `SPRINT-1.md` §11 остаётся валидной (экраны те же,
меняется только стек реализации):

| Спринт | Экраны                                              | Зависимости                          |
|--------|-----------------------------------------------------|--------------------------------------|
| 2      | 03 Today, 04a/04b/04/04c мастер, 10 Empty           | —                                    |
| 3      | 07/08 Auth (Telegram magic-link), 09 Welcome back   | Backend: `/auth/telegram/*`          |
| 4      | 11 Calendar, 13 Profile                             | Backend: `PATCH /me`, `/me/settings` |
| 5      | 05 Push, 06a/06b Spray/Fert sheets, snooze          | `flutter_local_notifications` + FCM/APNs |
| 6      | 12 Catalog, 14 Monthly report, 17 Archive           | Backend: `/reports/monthly`, archive |
| 7+     | 15 Diagnosis, 16 AI doctor, 18 Propagation, 19 Shopping | Backend-gaps из api-contract.md §12 |
