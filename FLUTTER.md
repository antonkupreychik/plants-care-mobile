# Plant Care — Mobile (Flutter)

> **СТАТУС: ГРУНТОВКА АКТИВНА.** Архитектурные решения приняты и задокументированы как
> MADR (см. `docs/adr/`). Ниже — рабочие конвенции для фича-агентов (аналог backend
> CLAUDE.md). Версии проверены на pub.dev **2026-05-27**; точные значения — в `pubspec.yaml`.
>
> Гейт остаётся: фича-агентов не запускать, пока **каркас не собран** (`flutter create`,
> pubspec, базовые классы, flavors, CI — см. «План каркаса» в конце). Три развилки SPRINT-1
> §0.5 решены владельцем 2026-05-27: **MADR-007 — кодген dart-dio из OpenAPI**, **MADR-012 —
> ru-only (но всё через AppLocalizations)**, **MADR-013 — GitHub Actions → Codemagic** —
> все **Accepted**. Остальные MADR (001–006, 008–011, 014) — **Proposed**.

Мобильный клиент к существующему Spring Boot бэкенду (`antonkupreychik/plants-care`).
Второй клиент рядом с Telegram-ботом. Backend, доменная модель, шедулер — переиспользуются
(см. backend CLAUDE.md и ADR-001…010). API-контракт: `design_handoff_plantcare/api-contract.md`.

---

## Стек (зафиксировано MADR-001)

| Назначение            | Решение                                                       |
|-----------------------|---------------------------------------------------------------|
| **Flutter SDK**       | **3.44.0** (stable) · **Dart 3.12.0**                         |
| **State / DI**        | Riverpod 3 (`flutter_riverpod` 3.3.1, `riverpod_annotation` 4.0.2) + codegen. Отдельный DI-контейнер не используется (MADR-004). |
| **Архитектура**       | Clean Architecture + MVVM: data → domain → presentation (MADR-002) |
| **Структура**         | feature-first (MADR-003)                                      |
| **Навигация**         | `go_router` 17.2.3, StatefulShellRoute для табов (MADR-005)   |
| **Сеть**              | `dio` 5.9.2 + `dio_smart_retry` 7.0.1; две «головы» заголовков, ApiError (MADR-006) |
| **API-клиент**        | **Кодген dart-dio из OpenAPI** (`swagger_parser`, bundle `$ref`) — MADR-007 |
| **Модели/DTO**        | DTO — **сгенерированные** из OpenAPI; маппинг DTO ↔ domain пишется руками (`freezed` 3.2.5 для domain-моделей) |
| **Auth**              | Dev-слот (X-Chat-Id/X-User-Id через --dart-define) → JWT позже (MADR-008) |
| **Хранилище/offline** | `drift` 2.33.0 на `sqlite3` 3.x (native assets; БЕЗ `sqlite3_flutter_libs` — EOL) — MADR-009 |
| **Secure storage**    | `flutter_secure_storage` 10.3.0                               |
| **SVG / шрифты**      | `flutter_svg` 2.3.0 · `google_fonts` 8.1.0 (или bundled .ttf) |
| **UUID**              | `uuid` 4.5.3                                                  |
| **Тема**              | Material 3, единый ThemeData light/dark из дизайн-токенов     |
| **Flavors**           | dev / prod, `--dart-define` (MADR-010)                        |
| **Error handling**    | Result/Either на freezed sealed (MADR-011)                    |
| **Локализация**       | ru-only (один ARB), но все UI-строки через `AppLocalizations` (MADR-012) |
| **CI/CD**             | GitHub Actions сейчас → Codemagic к релизу (MADR-013)         |
| **Codegen**           | `build_runner` 2.15.0 (riverpod, drift, freezed, json)        |
| **Тесты**             | `flutter_test`, `mocktail` 1.0.5, `integration_test` (MADR-014) |
| **Lints**             | `flutter_lints` 6.0.0 + `custom_lint`/`riverpod_lint`         |

Перед использованием API пакета сверяй его версию в `pubspec.yaml`, не полагайся на память.
Мажорные апгрейды пакетов — только отдельной задачей.

---

## Структура проекта (MADR-003)

Feature-first:

```
lib/
├── core/                 # общее: network, router, theme, storage, errors, l10n, env, widgets, care, locations
│   ├── network/          # dio instance + AuthHeader/Error interceptors, ApiError, AuthScope
│   ├── care/             # общий care-task домен (CareTask, CareTaskType, мапперы) — делят home/schedule
│   ├── locations/        # общий location-домен (GardenLocation, LocationDtoMapper) — делят home/add_plant/rooms
│   ├── router/           # go_router (роуты, StatefulShellRoute-табы Сад/График/Каталог/Профиль, guards)
│   ├── theme/            # tokens.dart (PC_THEMES) + ThemeData light/dark
│   ├── storage/          # drift AppDatabase (каркас)
│   ├── errors/           # ApiError (sealed), Result
│   ├── l10n/             # arb + сгенерированный AppLocalizations
│   ├── env/              # AppConfig из --dart-define (API_URL, CHAT_ID, USER_ID)
│   └── widgets/          # общие атомы (skeleton, error view, chips)
├── features/
│   └── <feature>/
│       ├── data/         # *Dto, *RepositoryImpl, remote/local data sources, mappers
│       ├── domain/       # модели (freezed), интерфейсы репозиториев, use cases
│       └── presentation/ # Notifiers (state), экраны, виджеты
└── main_dev.dart / main_prod.dart   # entrypoints на flavor
```

Фича **не** импортит из `presentation/` другой фичи. Если фиче нужны данные другой —
зависит от её domain-интерфейса, не от экранов. Общее — только через `core/`.
Sprint 1 фичи: `home` (01), `plant_card` (02), `add_plant` (04 — мастер из 4 шагов,
полноэкранно поверх shell через root navigator `/home/add`; выбор вида и план ухода —
read-only превью, `speciesId`/расписания backend не сохраняет, G13/G14), `care_event`
(06 sheet), `schedule` (11), `rooms` (управление комнатами — CRUD локаций
`/api/v1/locations`, push `/profile/rooms`), `profile` (минимальный экран настроек,
branch 3 `/profile` — таб «Профиль» активен, не coming-soon), `auth` (07/09 заглушки).
Общий care-task домен (`CareTask`/`CareTaskType`, мапперы) — в `core/care/`, т.к. его
делят `home` и `schedule`; общий location-домен (`GardenLocation`, `LocationDtoMapper`) —
в `core/locations/`, т.к. его делят `home`, `add_plant` и `rooms`.

---

## Конвенции слоёв (MADR-002)

### Data
- Репозиторий реализует интерфейс из domain; возвращает `Future<Result<T>>` (НЕ бросает наружу).
- `*Dto` **генерятся из OpenAPI** (`swagger_parser`) и отдельны от domain-моделей. Маппинг
  DTO ↔ domain — явный, **пишется руками** в `mappers/` (MADR-007). Сгенерированный код не правим.
- Тестами покрываем **мапперы** (DTO ↔ domain), а не сгенерированные DTO.
- Каждый запрос помечает `AuthScope` (user / chat / none) — интерсептор подставит заголовок (MADR-006).
- **Ловушка:** маппер `taskType (WATERING/MISTING/FERTILIZING) → type (WATER/SPRAY/FERTILIZE)`
  живёт здесь и покрыт тестом.
- Offline (позже): запись с client-generated UUID + updated_at, sync last-write-wins (MADR-009).

### Domain
- **Чистый Dart**: ни одного `import 'package:flutter/...'`, ни Riverpod. Нарушение = отказ ревью.
- Модели — freezed, иммутабельные.
- Use case — один публичный метод, одна ответственность; возвращает `Result<T>`.

### Presentation
- State через Riverpod Notifier/AsyncNotifier (роль ViewModel).
- Виджет не лезет в репозиторий напрямую — только через провайдер.
- Никакой бизнес-логики в виджетах.
- Доменные ошибки (`ApiError`) маппятся в текст через `AppLocalizations`.

---

## Правила state (Riverpod — MADR-004)

- `AsyncNotifier`/функциональные `@riverpod`-провайдеры для асинхронных данных (API/БД).
- UI-состояние (тема, фильтры, активная локация) — `Notifier`.
- Никакого глобального мутабельного состояния вне провайдеров.
- `ref.watch` — в build, `ref.read` — в колбэках.
- Провайдеры с codegen (`@riverpod`), не ручные StateProvider где можно.
- **Инвалидация после `POST /care-events`**: `ref.invalidate` для `today`, `plant(id)`,
  `plantHistory(id)`, `streak(id)`, `calendar` (см. README §5).
- DI — это и есть граф провайдеров; get_it не вводим.

---

## Правила виджетов

- Декомпозиция: экран → секции → атомарные виджеты. Виджет > ~80 строк — дроби.
- `const`-конструкторы везде, где можно (Impeller + меньше rebuild'ов).
- Стили из темы и токенов, НЕ хардкод цветов/размеров по месту (см. `core/theme/tokens.dart`).
- Списки — ленивые (`ListView.builder`), не `Column` в `SingleChildScrollView` для длинных.
- Все UI-строки — через `AppLocalizations` (MADR-012), не строковые литералы в виджетах.
- Sheet'ы ухода (water/spray/fert) — `showModalBottomSheet`, не роуты go_router (MADR-005).

---

## Сеть и auth-слот (MADR-006, MADR-008)

- Один `Dio` в `core/network/`, base URL из `--dart-define API_URL`.
- **Две «головы» заголовков** по `AuthScope` per-request (не по URL-регулярке):
  - `X-User-Id` → `/plants`, `/locations`;
  - `X-Chat-Id` → `/today`, `/calendar`, `/care-events`, `/plants/{id}/history`, `/stats/streak`;
  - `none` → `/species`, `/care-types`, `/health`.
  Дефолт scope — `none` (безопасно: забыл указать → backend ответит 401/403, чужой заголовок не утечёт).
- `AuthSession` (domain) прячет источник идентичности: Sprint 1 — `DevAuthSession`
  (CHAT_ID/USER_ID из --dart-define); Phase 3 — `JwtAuthSession` (Bearer из secure storage).
  Переход на JWT = вторая реализация + одна ветка интерсептора, экраны не трогаем.
- **Идемпотентность:** `POST /care-events` всегда с `clientId = Uuid().v4()`, сгенерированным
  ОДИН раз на действие (хранить в state, не на каждый build). Двойной тап / ретрай не дублирует.
- `/calendar` — клиент не запрашивает > 60 дней (валидация перед запросом).
- Ошибки backend `{error:{code,...}}` → `ApiError` (sealed) в ErrorInterceptor.

---

## Хранилище / offline (MADR-009)

- `drift` 2.33 на `sqlite3` 3.x через **native assets**. **НЕ добавлять `sqlite3_flutter_libs`**
  — пакет EOL (`0.6.0+eol`, «update to sqlite3 3.x»).
- Sprint 1 кеширует **минимум**: создаём каркас `AppDatabase` в `core/storage/`, но фичи
  Sprint 1 ходят в сеть через Riverpod-кеш. Полноценный offline — отдельная задача после Sprint 2.
- Sync (когда дойдём): локальная care-event с `clientId (PK)` + `updatedAt` + `synced`;
  офлайн → пишем локально, при сети → `POST` с тем же `clientId` (backend дедуплицирует),
  конфликты — last-write-wins по `updatedAt`.

---

## Тема / дизайн-система

- Material 3, два `ThemeData` (light/dark) из токенов `PC_THEMES` (README §6 / `design/screens.jsx`).
- Токены → `core/theme/tokens.dart` (`light`/`dark` записи), цвета/типографика/скругления/тени.
- Шрифты: `Instrument Serif` (заголовки/voice line, italic), `Plus Jakarta Sans` (UI).
- Переключение по `MediaQuery.platformBrightness`.
- SVG-иллюстрации (Monstera/Fern/Succulent/Pothos/Cactus) и иконки — `flutter_svg`,
  имена сохраняем (`drop`, `spray`, `fert`, `sun`, `bell`, `home`…).

---

## Flavors / окружения (MADR-010)

- dev / prod, entrypoint'ы `main_dev.dart` / `main_prod.dart`.
- Конфиг через `--dart-define` (НЕ `.env` в репозитории): `API_URL`, dev-only `CHAT_ID`/`USER_ID`.
- bundle id: `com.<org>.plantcare.dev` / `com.<org>.plantcare`.
- Локальные dart-define — в `run-dev.sh` / launch.json (`.gitignore`); в CI — из секретов.

---

## Время и таймзоны (КРИТИЧНО, как на backend)

- Сервер хранит UTC. Клиент показывает в таймзоне юзера.
- Не использовать `DateTime.now()` напрямую в логике — инжектить через провайдер Clock (тестируемость).
- Напоминания/расписания приходят с backend уже посчитанными — клиент не пересчитывает интервалы сам.
- Группировку today «утро/вечер» клиент делает по `nextDueAt` (README §03).

---

## Error handling (MADR-011)

- domain/data возвращают `Result<T>` (freezed sealed: `success` / `failure(ApiError)`), НЕ бросают наружу.
- Внутри data исключения dio ловит ErrorInterceptor → `ApiError`.
- UI: `AsyncValue` Riverpod даёт loading/error; доменные ошибки Notifier кладёт в state,
  экран рисует баннер/тост по типу `ApiError` (тексты — через l10n).
- Отдельный пакет под Either (dartz/fpdart) не тянем — freezed sealed + Dart 3 pattern matching.

---

## Тестирование (MADR-014)

- **Domain** (use cases, мапперы) — unit, без Flutter.
- **Data** (репозитории на моках dio, мапперы DTO↔domain, drift in-memory) — unit.
- **Presentation** (Notifiers) — unit через `ProviderContainer` с overrides.
- **Экраны** — widget-тесты (Home / Plant card / Water sheet).
- **Флоу** (открыть карточку → Полить → дневник; онбординг) — integration_test.
- Clock инжектится провайдером → детерминированное время в тестах.
- Перед «готово»: `flutter analyze` чисто + `flutter test` зелёное.

---

## Локализация (MADR-012)

- `flutter_localizations` + **один ARB** (`app_ru.arb`), `supportedLocales` = только `ru`.
- Все UI-строки — через `AppLocalizations`, **не литералы в виджетах** (хардкод = отказ ревью,
  даже при одном локале — иначе добавление `en` потом потребует переписывать экраны).
- Контент с backend (`displayName`, `description`) — показываем как пришло (backend — источник),
  через l10n идут только UI-обвязка и тексты ошибок.
- Добавление `en` — отдельная задача (создать `app_en.arb` + расширить `supportedLocales`).

---

## Git / PR

- Ветка: `feature/<issue>-<kebab>` (как на backend).
- 1 issue = 1 PR, `Closes #N`.
- CI зелёный (analyze + test) до ревью. Мержит человек.
- Mobile-issues/PR лейблятся `mobile`.

---

## Чего НЕ делать

- Не запускать фича-агентов, пока каркас не собран (см. «План каркаса»).
- Не хардкодить API URL — через flavor + dart-define.
- Не добавлять `sqlite3_flutter_libs` (EOL) — drift на `sqlite3` 3.x native assets.
- Не коммитить ключи/идентификаторы (CHAT_ID/USER_ID, позже APNs, RevenueCat, OAuth) — dart-define/secure storage.
- Не матчить заголовки по URL-регулярке — только через `AuthScope` per-request.
- Не генерить care-event `clientId` на каждый build — один на действие.
- Не тащить пакеты без обоснования; проверять, что пакет живой и поддерживает текущий SDK.
- Не смешивать слои (Flutter-импорт в domain = отказ ревью); domain/data не бросают исключения наружу.
- Не апать мажорные версии пакетов без отдельной задачи.
- Не использовать deprecated-виджеты и Skia-специфичные хаки (Impeller дефолтный).

---

## Источники правды

- `docs/adr/` — MADR-001…014 (архитектурные решения мобилки).
- `design_handoff_plantcare/api-contract.md` — REST-контракт backend (§1–11) + gaps (§12).
- `design_handoff_plantcare/README.md` — продукт, 24 экрана, дизайн-токены.
- `design_handoff_plantcare/SPRINT-1-flutter.md` — план первого спринта.
- backend CLAUDE.md + ADR-001…010 (репозиторий `plants-care`) — доменная модель, шедулер.
