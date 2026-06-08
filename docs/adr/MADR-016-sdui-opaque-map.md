# MADR-016 — Опаковый Map-контракт для SDUI + таблица композиции `ui_views`

**Статус:** Accepted (2026-06-08, владельцем) · **поправка к [MADR-015](MADR-015-sdui.md)**

> Сквозное решение (mobile + backend + оркестрация). Меняет ТОЛЬКО форму контракта SDUI,
> не саму идею. Гибридный block-SDUI, граница «read-heavy → сервер, интерактив → нативно»
> и forward-compatibility из MADR-015 — **остаются в силе**.

---

## Контекст

MADR-015 заложил гибридный block-SDUI с **типизированным** словарём блоков в OpenAPI-спеке
мобайла (`Block` через `oneOf`+discriminator, кодген DTO через `swagger_parser`). По итогам
пилота home владелец пересмотрел форму контракта в пользу максимальной свободы бэкенда:
композицию экранов хочется задавать **строкой в таблице БД**, без правок спеки и регенерации
клиента на каждое изменение.

Ключевое наблюдение, снимающее главный аргумент против опака: **узкое место «менять UI без
релиза» — это клиентский рендерер, а не типизация контракта.** Клиент рисует блок через
`BlockRegistry` (`type → нативный виджет`); пока блок ложится на конкретный виджет, новый
*тип* блока всё равно требует релиза клиента — типизация контракта этого не меняет. Значит
типизация в OpenAPI даёт валидацию/кодген, но не даёт релиз-фри новые блоки. Владелец выбрал
обменять типизацию на простоту авторинга на бэкенде.

## Решение

**Опаковый Map-контракт + таблица композиции `ui_views`.**

### Wire-формат (контракт)
- `GET /api/v1/ui/{screen}` возвращает **опаковый объект**: в OpenAPI-спеке мобайла
  (`api/openapi/resources/ui.yaml`) ответ — `ScreenLayout { screenId: string, version: int,
  blocks: array of object }`, где элемент `blocks` — свободный объект (`additionalProperties:
  true`). **Типизированных схем блоков в OpenAPI нет.** `swagger_parser` генерит тонкий клиент:
  `getUiScreen(screen, {xUiCatalogVersion}) → ScreenLayout` с `blocks: List<dynamic>`.
- Заголовок `X-UI-Catalog-Version` (int, optional, min 1) сохранён; фильтрация блоков по
  `minCatalogVersion` — на бэкенде, неизвестный `type` клиент скипает (graceful degradation).

### Backend
- Таблица **`ui_views (category, screen, layout_json JSONB, min_catalog_version)`** хранит
  **композицию** экрана (какие блоки, порядок, статичные пропсы) — НЕ живые данные.
- Контроллер `/ui/{screen}` тонкий: читает строку, **гидрирует** динамические блоки данными
  из существующих сервисов (`weather`, `today`, `locations`, `plants`) на лету, отдаёт опаковый
  JSON. Статичные блоки (будущие `banner`/`card`) — verbatim из `layout_json`.
- Менять состав/порядок/видимость блоков и катить статичный контент = **UPDATE строки**, без
  релиза и без правки кода.

### Словарь блоков — теперь ПРОЗА, не схема
- Форма каждого блок-типа (`weather_strip`, `today_tasks`, `today_summary`, `location_chips`,
  `plant_grid`, …) описывается **прозой** — в каталоге блоков этого ADR (ниже) и/или
  `FLUTTER.md`. OpenAPI её больше **не валидирует**.
- **`contract-keeper` сторожит документ-словарь, а не спеку.** Его роль сместилась с «спека ↔
  контроллеры (CI-валидация)» на «прозовый словарь блоков ↔ что реально шлёт backend и парсит
  client». Гарантия слабее (нет CI-диффа) — это осознанная цена.
- Направление неизменно: **новый блок-тип сперва в словаре (проза) → backend начинает слать →
  client учится парсить и рендерить.**

## Каталог блоков (источник правды формы — проза)

Все блоки — элементы `blocks[]`, дискриминатор — поле `type`. `minCatalogVersion` — опционален.

| `type` | Поля | Рендер на клиенте | Гидрация (backend) |
|---|---|---|---|
| `weather_strip` | `available`, `humidityPercent`, `recommendation`, `fetchedAt`, `fromCache` | `WeatherStripContent` | `WeatherService` |
| `today_tasks` | `completedCount`, `totalCount`, `tasks[]{scheduleId,plantId,plantName,type,dueAt}` | `TodayCard` (тапабельный список; тап → нативный sheet ухода, preset по `type`) | `TodayApiService` |
| `today_summary` | `total`, `done`, `remaining`, `overdue` | `TodayCard` (только счётчики) | `TodayApiService` |
| `location_chips` | `locations[]{id,name,emoji}` | `LocationChips` | `LocationService` |
| `plant_grid` | `plants[]{id,name,locationName,action,waterAction}` | `PlantCard` (сетка); тап тела → `action` (navigate), кнопка → `waterAction` (log_care) | `PlantService` |
| `guest_banner` ⁽MADR-017⁾ | `titleKey`, `bodyKey`, `ctaAction` | `GuestBannerCard` | инъектируется сервисом **только гостю** |
| `empty_state` ⁽MADR-017⁾ | `iconKey`, `titleKey`, `bodyKey`, `ctaAction` | core-визуал пустого сада + CTA | инъектируется **вместо `plant_grid`** при пустом саде |

- `tasks[].type` / `payloadTemplate.type` — **нормализованный** care-словарь:
  `WATER`/`SPRAY`/`FERTILIZE`/`SOIL_CHECK` (backend маппит из доменного `WATERING/…`).
- **Действие** (`action`/`waterAction`/`ctaAction`) — декларативный
  `{ kind, [method, path, payloadTemplate], [target], [invalidates] }`, исполняется `ActionRunner`
  (MADR-017):
  - `kind: "log_care"` — мутация (`method`/`path`/`payloadTemplate`); `kind: "navigate"` —
    переход (`target`, относительный путь).
  - `invalidates: [...]` — логические ключи обновления после мутации (`home`/`today`/`plant`).
  - `titleKey`/`bodyKey`/`iconKey` — **ключи l10n**, не готовый текст (текст-обвязка клиентская,
    MADR-012); клиент резолвит через `resolveSduiTextKey`/`resolveSduiIconKey`.
- Интерактив с локальным состоянием (sheet `today_tasks`) — **нативный**, не через action.
  `navigate.target` карточек — витринный (`/plants/{id}`); CTA блоков видимости ведут в нативные
  флоу (`/home/add`, `/home/register`) — навигация декларативна, флоу нативный.

## Причины

- Максимальная свобода авторинга на бэкенде: композиция/порядок/видимость/статичный контент —
  строкой в `ui_views`, без релиза и без регенерации клиента.
- Опак не теряет того, что давала бы типизация для «релиз-фри блоков» (узкое место — рендерер).
- Гибридная модель и нативный фил интерактива из MADR-015 сохранены.

## Последствия

- В OpenAPI мобайла блок-схемы **удалены**; `ui.yaml` декларирует опаковый `ScreenLayout`.
  Клиент — `List<dynamic>` блоков; **маппер `Map → domain` пишется и тестируется руками**
  (`lib/core/sdui/data/sdui_block_mapper.dart`), он же — точка graceful-degradation (неизвестный
  `type → null`, пропускается).
- Домен `SduiBlock`/`SduiScreenLayout`/`SduiAction` и presentation (`BlockRegistry`,
  `ScreenLayoutView`, `ActionRunner`, провайдеры) — **развязаны от формата провода**, остаются
  типизированными внутри клиента. Меняется только слой парсинга.
- **`contract-keeper`** теперь сверяет прозовый каталог блоков (этот ADR / `FLUTTER.md`) с тем,
  что шлёт backend и парсит client. Расхождение ловится тестами/ревью, не CI-схемой.
- Backend: миграция `ui_views` + сид композиции экрана; новые экраны = новые строки.
- Цена, принятая осознанно: нет compile-time валидации формы блоков и кодгена DTO под блоки;
  «грязный» блок ловится только тестом маппера, а не диффом спеки.

> **Отвергнутая альтернатива: оставить типизированный контракт MADR-015** (generic-блоки со
> схемами в OpenAPI + таблица `ui_views` под капотом). Сохранял бы кодген, валидацию и
> `contract-keeper` на CI, давая бэкенду ту же свободу композиции. Владелец выбрал опак ради
> простоты авторинга и свободы менять пропсы блоков без правки спеки; возврат к типизации
> остаётся возможным (схема описывает уже существующую опаковую форму).
