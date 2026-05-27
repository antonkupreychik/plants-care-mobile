# План каркаса PlantCate Mobile (Sprint 1, шаг 0 «bootstrap»)

> **СТАТУС (2026-05-27): каркас собран + базовый слой core/ + l10n, release APK собирается.**
> Сделано: `flutter create` в корне; стек MADR-001 (riverpod+codegen, go_router, dio+retry,
> freezed/json, secure_storage, uuid, google_fonts, flutter_svg, flutter_localizations); тема
> light/dark из токенов; `AppConfig` из `--dart-define`; go_router `/home`; flavor-entrypoints;
> первый экран (`features/home`). **Базовый слой core/** (этот заход): `error/` (ApiError,
> Result — freezed sealed), `network/` (dio-провайдер, AuthInterceptor по AuthScope,
> ErrorInterceptor→ApiError), `auth/` (AuthSession + DevAuthSession-слот), `clock/`. **l10n**
> ru-only (`AppLocalizations`, все строки Home через него). build_runner + gen-l10n проходят,
> `flutter analyze` чисто, `flutter test` зелёный (13 тестов, вкл. core), APK собран.
> Окружение: Flutter в `~/development/flutter`, Maven Central недоступен → зеркало (`DEV-ENV.md`).
> **API-кодген** (этот заход, MADR-007): свой бандлер `tool/bundle_openapi.dart` собирает
> многофайловую спеку (`api/openapi/`) в `api/openapi.bundled.json`; `swagger_parser` →
> `lib/core/api/generated/` (10 Retrofit-клиентов на dio + 24 json_serializable DTO);
> `plantsCareApiProvider` поверх `dioProvider`; auth-scope через `@Extras`. Пайплайн —
> `tool/gen_api.sh`. Источник — статическая спека (рантайм `/v3/api-docs` непригоден: нет
> заголовков/параметров, пустой `/calendar`). dev API_URL по умолчанию → dev-хост.
> **Ещё не сделано:** drift/storage, Android/iOS productFlavors+schemes (`--flavor`), CI workflow.
> Примечание: `custom_lint`/`riverpod_lint` отложены (конфликт analyzer-версий с
> riverpod_generator 4.0.3); сгенерированный код (`*.g.dart`/`*.freezed.dart`,
> `app_localizations*.dart`, `lib/core/api/generated/**`) коммитится (сборка не зависит от
> codegen на свежем checkout; swagger-дир исключён из analyzer).


> Делается **вместе с владельцем, не автономно** (фича-агенты — после). Цель шага: пустой,
> но собирающийся каркас под решения MADR-001…014. Сами экраны — следующие дни Sprint 1.
> Предусловия: ✅ MADR-007/012/013 подтверждены владельцем 2026-05-27 (кодген dart-dio из
> OpenAPI; ru-only через AppLocalizations; GitHub Actions → Codemagic). Остальные MADR — Proposed.

## 0. Предпроверка
- `flutter --version` → должно быть **3.44.0 / Dart 3.12.0** (MADR-001). Если новее — обновить таблицу версий, не «пинить» молча.
- Xcode + iOS-симулятор; (Android — Phase 3, но `--platforms ios,android` ставим сразу).

## 1. flutter create
```bash
flutter create plantcate_mobile --org com.<org> --platforms ios,android
```
- Перенести/слить с существующим репозиторием (FLUTTER.md, docs/, design_handoff/ уже в корне — решить: проект в корне или в подпапке).
- iOS deployment target → **15.0** (Podfile + project.pbxproj) — требование dio/secure_storage 10.x.

## 2. Структура папок (MADR-003)
Создать пустые: `lib/core/{network,router,theme,storage,errors,l10n,env,widgets}` и
`lib/features/{home,plant_card,care_event,auth}/{data,domain,presentation}`.

## 3. pubspec.yaml (версии MADR-001)
- dependencies: flutter_riverpod 3.3.1, riverpod_annotation 4.0.2, go_router 17.2.3,
  dio 5.9.2, dio_smart_retry 7.0.1, freezed_annotation 3.1.0, json_annotation 4.12.0,
  drift 2.33.0, sqlite3 3.3.2, flutter_secure_storage 10.3.0, flutter_svg 2.3.0,
  google_fonts 8.1.0, uuid 4.5.3, intl 0.20.2, path_provider 2.1.5, path 1.9.1,
  flutter_localizations (sdk).
- dev_dependencies: build_runner 2.15.0, riverpod_generator 4.0.3, freezed 3.2.5,
  json_serializable 6.14.0, drift_dev 2.33.0, custom_lint 0.8.1, riverpod_lint 3.1.3,
  flutter_lints 6.0.0, mocktail 1.0.5, integration_test (sdk), **swagger_parser** (для
  кодгена API-клиента из OpenAPI — версию сверить на pub.dev при сборке, MADR-007).
- **НЕ добавлять** `sqlite3_flutter_libs` (EOL — MADR-009).
- assets: шрифты (Plus Jakarta Sans, Instrument Serif .ttf) или через google_fonts; SVG-иллюстрации.
- `flutter pub get` + `analysis_options.yaml` подключает flutter_lints + custom_lint(riverpod_lint).

## 3.5. API-клиент из OpenAPI (кодген, MADR-007)
- Скачать `api/openapi.yaml` из `antonkupreychik/plants-care`; собрать `$ref` в один файл
  (`swagger-cli`/`redocly bundle`) → `api/openapi.bundled.yaml`.
- `swagger_parser` конфиг → генерит dio-клиент + DTO в `core/api/generated/` (сгенерированный
  код не правим руками; коммитим для воспроизводимости).
- Скрипт `tool/gen_api.sh` (bundle + генерация) — гоняется руками и в CI.
- Сгенерированный dio должен использовать общий `Dio`-инстанс с интерсепторами (см. §4),
  а не свой — или интерсепторы навешиваются на инстанс, который ему передаётся.

## 4. Базовые классы (только каркас, без фич)
- `core/env/app_config.dart` — чтение `API_URL`, `CHAT_ID`, `USER_ID` из `String.fromEnvironment`.
- `core/errors/api_error.dart` — freezed sealed (validation/accessDenied/notFound/conflict/locationNotEmpty/network/unknown).
- `core/errors/result.dart` — freezed `Result<T>` (success/failure).
- `core/network/auth_scope.dart` — enum (user/chat/none) + `AuthSession` интерфейс.
- `core/network/dio_client.dart` — Dio + AuthHeaderInterceptor (по AuthScope) + ErrorInterceptor + dio_smart_retry; провайдер.
- `core/network/dev_auth_session.dart` — DevAuthSession из app_config (MADR-008).
- `core/theme/tokens.dart` + `core/theme/app_theme.dart` — light/dark из дизайн-токенов (README §6).
- `core/router/app_router.dart` — GoRouter: StatefulShellRoute (home/calendar/catalog/profile) + /plant/:id + /auth/*; провайдер.
- `core/storage/app_database.dart` — drift AppDatabase (пустой/минимальный), провайдер.
- `core/utils/clock.dart` — Clock + провайдер (инжект времени).

## 5. Локализация (MADR-012)
- `l10n.yaml` + `lib/core/l10n/arb/app_ru.arb` (единственный ARB; en НЕ заводим).
- В MaterialApp.router — `localizationsDelegates` + `supportedLocales` = **[ru]**.
- Правило: UI-строки только через `AppLocalizations`, литералы в виджетах запрещены (чтобы
  добавление en позже было созданием `app_en.arb`, а не переписыванием экранов).

## 6. Flavors (MADR-010)
- `lib/main_dev.dart` / `lib/main_prod.dart` (общий `app.dart` с MaterialApp.router).
- iOS: схемы dev/prod + xcconfig (разный bundle id, имя). Android — productFlavors (Phase 3).
- `run-dev.sh` (в .gitignore) с `--flavor dev -t lib/main_dev.dart --dart-define=...`.

## 7. CI (MADR-013)
- `.github/workflows/flutter-ci.yml`: на PR — setup-flutter@3.44.0, `flutter pub get`,
  `dart run build_runner build`, `flutter analyze`, `flutter test`.

## 8. Hello-world проверка
- `main_dev.dart` → MaterialApp.router с одним экраном `/home` (заглушка «PlantCate dev»),
  применённой темой, загруженными шрифтами, переключением light/dark по системе.
- Прогон: `flutter run --flavor dev -t lib/main_dev.dart --dart-define=API_URL=...` на iOS-симуляторе.
- `dart run build_runner build --delete-conflicting-outputs` проходит (даже если генерить пока нечего).
- `flutter analyze` чисто, `flutter test` (хотя бы один smoke-тест) зелёное.

## Definition of done каркаса
- [ ] Собирается и запускается на iOS-симуляторе (flavor dev).
- [ ] Тема light/dark из токенов, шрифты загружены.
- [ ] go_router отдаёт /home заглушку.
- [ ] Dio-клиент + интерсепторы скомпонованы (без реальных вызовов).
- [ ] `tool/gen_api.sh` генерит клиент из OpenAPI, сгенерированный код компилируется.
- [ ] build_runner проходит, analyze чисто, test зелёный.
- [ ] CI workflow зелёный на первом PR.
- → После этого снимается гейт «каркас не собран», запускаются фича-агенты Sprint 1.
