# PlantCate — Backend API Contract

> Версия: **1.0** · сверено с `openapi.yaml` в репозитории `plants-care@main` на 27 мая 2026.

Документ состоит из двух частей:

1. **§§ 1–11 · Реальный контракт** — что уже реализовано на бэкенде (`/api/v1/*`). Поля, имена, заголовки, коды ошибок — как в коде.
2. **§ 12 · Gaps** — что просит мобильный дизайн, но в API пока нет. Это backlog для бэкенда: предлагаемые новые эндпоинты, со ссылками на issues roadmap.

Источник правды: `src/main/resources/openapi/openapi.yaml` и подпапка `resources/*.yaml`.

Базовый URL prod: `https://plants-care.up.railway.app`
Локалка: `http://localhost:8080`

---

## 1. Аутентификация (PoC)

В текущей версии (issues #85/#86) **нет JWT**. Идентификация пользователя — через числовой заголовок, два варианта в зависимости от эндпоинта:

| Заголовок | Что | Используется в |
|---|---|---|
| `X-User-Id` | Внутренний `users.id` | `/plants`, `/locations` |
| `X-Chat-Id` | Telegram `chat_id` (резолвится на сервере) | `/care-events`, `/today`, `/calendar`, `/stats/streak`, `/plants/{id}/history` |

Публичные справочники (`/species`, `/care-types`, `/health`) аутентификацию **не требуют**.

> **Важно для мобилки.** Это PoC‑схема. Перед публикацией нужно решить с auth provider — Apple/Google sign‑in + связка с `users.id`. См. Roadmap → Admin Phase 2 (Account management).

---

## 2. Соглашения

- **JSON, UTF‑8.** Все имена полей — `camelCase`.
- **Время** — ISO‑8601, UTC. Поля называются `*At` (`createdAt`, `performedAt`, `nextDueAt`, `archivedAt`).
- **Даты без времени** — `YYYY-MM-DD`.
- **Пагинация** — `offset` / `limit`. `limit` обрезается в [1, 100], `offset` < 0 → 0.
- **Soft‑delete** для растений — флаг `archived`/`archivedAt`. В обычные выборки не попадают.
- **Идемпотентность** — `POST /care-events` принимает `clientId` (UUID). Повтор с тем же `clientId` возвращает существующую запись, не создаёт дубль.

---

## 3. Health

### `GET /api/v1/health`
Liveness probe для оркестратора. Не проверяет зависимости.

**Response 200**
```json
{ "status": "UP" }
```

---

## 4. Plants — CRUD

Заголовок: **`X-User-Id`**.

### `GET /api/v1/plants?locationId=&offset=0&limit=20`

Список растений пользователя. Архивированные не возвращаются.

**Response 200 — `PageResponsePlantDto`**
```json
{
  "items": [
    {
      "id": 1,
      "name": "Monstera",
      "notes": "Стоит у окна, любит свет",
      "photoFileId": "AgACAgIAAxk...",
      "locationId": 2,
      "locationName": "Подоконник",
      "speciesId": 5,
      "speciesName": "Monstera deliciosa",
      "archived": false,
      "createdAt": "2026-05-24T10:15:30Z"
    }
  ],
  "total": 42,
  "offset": 0,
  "limit": 20
}
```

### `POST /api/v1/plants`
Создать растение.

**Request — `PlantCreateRequest`**
```json
{
  "name": "Monstera",           // required, 1..100
  "notes": "Стоит у окна",      // optional, max 2000
  "locationId": 2               // optional; если null — дефолтная локация
}
```
**Response 201** — `PlantDto`.

### `GET /api/v1/plants/{id}`
**200** — `PlantDto` · **403** чужое · **404** нет.

### `PUT /api/v1/plants/{id}` (PATCH‑семантика!)
Несмотря на метод PUT — обновляет **только переданные поля**. `null` = не менять.

**Request — `PlantUpdateRequest`**
```json
{ "name": "Monstera deliciosa", "notes": "Раз в неделю", "locationId": 5 }
```

### `DELETE /api/v1/plants/{id}`
Soft‑delete (`archivedAt = now()`).
**204** · **403** · **404**

---

## 5. Plants — History

Заголовок: **`X-Chat-Id`**.

### `GET /api/v1/plants/{id}/history?limit=20&offset=0`

Страница событий ухода. `SOIL_CHECK` в выдачу **не попадает** (служебный тип).

**Response 200 — `PlantHistoryResponse`**
```json
{
  "items": [
    {
      "id": 100,
      "plantId": 1,
      "plantName": "Monstera",
      "type": "WATER",
      "performedAt": "2026-05-22T10:00:00Z",
      "note": "Полил из лейки",
      "clientId": "9b1c4a36-...",
      "onTime": true
    }
  ],
  "total": 17,
  "limit": 20,
  "offset": 0
}
```

`onTime` используется для расчёта стрика.

---

## 6. Locations — CRUD

Заголовок: **`X-User-Id`**. Без пагинации.

### `GET /api/v1/locations`
**Response 200**
```json
[
  { "id": 1, "name": "Гостиная", "emoji": "🛋", "defaultLocation": true,  "createdAt": "..." },
  { "id": 2, "name": "Подоконник", "emoji": "🪟", "defaultLocation": false, "createdAt": "..." }
]
```

### `POST /api/v1/locations`
```json
{ "name": "Подоконник", "emoji": "🪟" }
```
`name` уникален в рамках пользователя.

### `GET /api/v1/locations/{id}` · `PUT /api/v1/locations/{id}` · `DELETE /api/v1/locations/{id}?targetLocationId=…`

**Удаление непустой локации:** обязательно `targetLocationId` для переноса растений. Иначе — `400` с `code=LOCATION_NOT_EMPTY`.

---

## 7. Care Events

Заголовок: **`X-Chat-Id`**.

### `POST /api/v1/care-events` — зарегистрировать действие ухода

**Request — `CreateCareEventRequest`**
```json
{
  "plantId": 10,
  "type": "WATER",                        // WATER | SPRAY | FERTILIZE (SOIL_CHECK недоступен)
  "performedAt": "2026-05-22T10:00:00Z",
  "note": "Грунт был сухой",
  "clientId": "9b1c4a36-3f6f-4a92-..."   // UUID для идемпотентности
}
```

Если `clientId` уже встречался — вернётся существующая запись, без вставки.

**Response 201 — `CareEventResponse`** — см. формат в § 5.

### `DELETE /api/v1/care-events/{id}` — отменить (компенсация)
Физически запись не удаляется — создаётся компенсирующая, в исходной проставляется FK `cancelled_by`.
**204** · повторная отмена → **409**.

---

## 8. Today / Calendar

Заголовок: **`X-Chat-Id`**.

### `GET /api/v1/today`

Задачи, дедлайн которых до конца сегодняшнего дня в TZ пользователя.

**Response 200 — `TodayResponse`**
```json
{
  "tasks": [
    {
      "scheduleId": 50,
      "plantId": 1,
      "plantName": "Моника",
      "taskType": "WATERING",       // WATERING | MISTING | FERTILIZING | SOIL_CHECK
      "locationName": "Гостиная",
      "nextDueAt": "2026-05-13T09:00:00Z"
    }
  ],
  "count": 1
}
```

> **Заметка.** `taskType` в today/calendar — это **внутреннее** имя (`WATERING`, не `WATER`). При выполнении ухода через `/care-events` нужно отправлять публичное (`WATER`).

### `GET /api/v1/calendar?from=2026-05-24&to=2026-06-22`

Диапазон не более **60 дней**, иначе 400.

**Response 200 — `CalendarResponse`** (`Map<YYYY-MM-DD, TaskDto[]>`):
```json
{
  "2026-05-24": [ { "scheduleId": 50, "plantId": 1, "plantName": "Моника", "taskType": "WATERING", "nextDueAt": "..." } ],
  "2026-05-27": [ /* … */ ]
}
```

Дни без задач в ответе **не появляются**.

---

## 9. Stats

Заголовок: **`X-Chat-Id`**.

### `GET /api/v1/stats/streak?plantId=10`
```json
{ "plantId": 10, "streak": 7 }
```
`streak` — количество подряд выполненных уходов с `onTime = true`.

---

## 10. Species (публично, без auth)

### `GET /api/v1/species?q=монстера&offset=0&limit=20`

**Response 200 — `PageResponseSpeciesSummaryDto`**
```json
{
  "items": [
    {
      "id": 5,
      "name": "Монстера",
      "latinName": "Monstera deliciosa",
      "wateringDays": 7,
      "mistingDays": 3,
      "fertilizingDays": 30,
      "soilCheckDays": 14,
      "careDifficulty": "EASY",          // CareDifficulty enum: EASY | MEDIUM | HARD
      "lightPreference": "BRIGHT_INDIRECT"
    }
  ],
  "total": 30,
  "offset": 0,
  "limit": 20
}
```

### `GET /api/v1/species/{id}`
То же плюс поле `description` (длинный текст).

### `GET /api/v1/care-types`
```json
[
  { "code": "WATERING",    "displayName": "Полив" },
  { "code": "MISTING",     "displayName": "Опрыскивание" },
  { "code": "FERTILIZING", "displayName": "Подкормка" },
  { "code": "SOIL_CHECK",  "displayName": "Проверка грунта" }
]
```

---

## 11. Errors

Единый формат:
```json
{ "error": { "code": "VALIDATION_ERROR", "message": "Validation failed", "details": [ { "field": "name", "message": "must not be blank" } ] } }
```

| HTTP | code                  | Когда |
|------|------------------------|--------|
| 400  | `VALIDATION_ERROR`     | Невалидное тело/параметры |
| 400  | `BAD_REQUEST`          | Прочие плохие запросы |
| 400  | `LOCATION_NOT_EMPTY`   | `DELETE /locations/{id}` без `targetLocationId` |
| 403  | `ACCESS_DENIED`        | Ресурс есть, но принадлежит другому юзеру |
| 404  | `NOT_FOUND`            | Ресурса нет |
| 409  | `CONFLICT`             | Повторная отмена и подобное |
| 500  | `INTERNAL_ERROR`       | Прочее |

---

# 12. Gaps — что нужно дополнить для мобилки

Дизайн iOS/Android требует данных/действий, которых в текущем API **нет**. Ниже — список с указанием, какому экрану соответствует и в каком роадмап‑issue эта фича уже значится (если есть).

> Это не сразу строить — это **бэклог для нового маленького роадмапа Mobile Phase 1**, который пойдёт после готовности Phase 0 (`#84/#86/#87`, уже сделано).

### 12.1 Auth & User
Текущая модель `X-User-Id` / `X-Chat-Id` — нерабочая для App Store: нужно настоящее JWT‑auth + связка с мобильным аккаунтом.

| Эндпоинт | Назначение | Issue |
|---|---|---|
| `POST /api/v1/auth/telegram/start` → `{session_id, deep_link, code_length, resend_after_sec}` | Старт входа через бота. Экран 07 → 08. | — |
| `POST /api/v1/auth/telegram/verify` → `{token, refresh_token, user}` | Проверка 6‑значного кода. Экран 08. | — |
| `POST /api/v1/auth/apple` | Sign in with Apple (требование App Store). Экран 07. | — |
| `POST /api/v1/auth/google` | Google sign‑in. Экран 07. | — |
| `POST /api/v1/auth/refresh` | Освежение JWT. | — |
| `GET /api/v1/me` → `{user, stats: {plantsTotal, tasksToday, notificationsUnread}}` | Текущий пользователь + счётчики. Экран 01/13. | — |
| `PATCH /api/v1/me` `{timezone, quietHoursStart, quietHoursEnd, locale}` | Настройки. Экран 13. | #116 |
| `POST /api/v1/devices` `{pushToken, platform}` | Регистрация push‑токена (FCM/APNs). | — |

После появления auth нужно решить судьбу заголовков `X-User-Id`/`X-Chat-Id` — либо оставить как параллельный механизм для бота, либо депрекейтить (см. Admin Phase 2 → Merge users).

### 12.2 Care Schedules (явные расписания)

Сейчас расписания живут как `CareSchedule` внутри сервиса, но **наружу не выставлены** — есть только агрегаты в `/today` и `/calendar`. Карточке растения (экран 02) и шагу 3 мастера (экран 04) этого мало.

| Эндпоинт | Назначение | Issue |
|---|---|---|
| `GET /api/v1/plants/{id}/schedules` → `CareSchedule[]` (со всеми типами: `WATERING/MISTING/FERTILIZING/SOIL_CHECK`, `every`, `unit`, `nextDueAt`, `enabled`, `amountMl`) | Карточка растения, расписание ухода. | — |
| `PUT /api/v1/plants/{id}/schedules/{type}` `{every, unit, amountMl?, enabled}` | Изменить расписание ухода. | — |
| `GET /api/v1/species/{id}/care-defaults` → массив дефолтных интервалов в виде `CareSchedule` | Дефолты под Шаг 3 мастера. Сейчас нужно вычислять из `wateringDays/mistingDays/...` на клиенте. | — |

### 12.3 Voice lines / mood (бренд‑фича)

В дизайне ключевая фишка — растения «говорят» от первого лица. Сейчас весь текст реплик — на клиенте/в шаблонах. Стоит решить, где он живёт.

| Эндпоинт | Назначение | Issue |
|---|---|---|
| `voiceLine` поле в `TaskDto` и `PlantDto` | Чтобы клиент не подбирал реплики по локали и контексту. | — (новая) |
| `moodLabel`, `status` (`happy`/`thirsty`/`sick`) в `PlantDto` | Точка под именем + капля‑бейдж. Рассчитывается из истории и расписания. | — |

Альтернатива — оставить генерацию на клиенте по `taskType` + `overdue`.

### 12.4 Health Score, диагностика, AI‑доктор

Экраны 14 (отчёт), 15 (диагноз), 16 (AI).

| Эндпоинт | Назначение | Issue |
|---|---|---|
| `GET /api/v1/plants/{id}/health` → `{score, factors[], recommendation?}` | Health Score 0–100 на карточке. | #138 («✅ реализовано» в roadmap — нужно сверить, есть ли API) |
| `GET /api/v1/plants/{id}/diagnosis` → `{summary, analysis, suggestion: {currentEvery, suggestedEvery, unit}}` | Авто‑диагностика проблемного растения. Экран 15. | #73 |
| `POST /api/v1/plants/{id}/diagnosis/accept` | Применить предложенное расписание. | #73 |
| `POST /api/v1/ai/diagnose` (multipart с фото) → `{candidates: [{name, probability, treatment[]}]}` | AI‑доктор по фото. Экран 16. | бэклог — топ‑1 кандидат |
| `GET /api/v1/reports/monthly?month=2026-05` → ` { headline, stats[], topPlants[], record }` | Месячный отчёт. Экран 14. | #137 |

### 12.5 Vacation / Sharing / Multi‑home

| Эндпоинт | Назначение | Issue |
|---|---|---|
| `POST /api/v1/vacation` `{from, to}` · `DELETE /api/v1/vacation` | Отпуск‑режим. Экран 13. | #53 |
| `POST /api/v1/sharing/invites` `{plantIds[], inviteeContact}` · `GET /api/v1/sharing` | Совместный уход. Экран 13. | #77 |
| `GET/POST/DELETE /api/v1/houses` | Дача + квартира. | #70 |

### 12.6 Memorial / Propagation

| Эндпоинт | Назначение | Issue |
|---|---|---|
| `GET /api/v1/plants?status=archived` или `GET /api/v1/archive` | Архив погибших растений. Экран 17. Сейчас архив создаётся через soft‑delete, но просмотреть его нечем. | #117 |
| `POST /api/v1/plants/{id}/restore` | Восстановление из архива. | #117 |
| `PlantCreateRequest.parentPlantId` + `GET /api/v1/plants/{id}/family` | Родословная черенков. Экран 18. | #139 |

### 12.7 Toxicity / Light

| Эндпоинт / Поле | Назначение | Issue |
|---|---|---|
| `SpeciesSummaryDto.toxic: {cats: bool, dogs: bool, children: bool}` | Бейдж «токсично 🐈». Экраны 02, 12. | #128 («✅ реализовано» — нужно проверить, что поле выводится в API) |
| `SpeciesSummaryDto.lightPreference` (уже есть) + локализованное `lightDescription` | Для экранов мастера и каталога. | #135 |

### 12.8 Shopping list, Weather, ICS

| Эндпоинт | Назначение | Issue |
|---|---|---|
| `GET/POST/PATCH /api/v1/shopping` | Список покупок. Экран 19. | #136, #141 |
| `GET /api/v1/weather/snapshot` → `{temp, humidity, advice}` | Микровиджет погоды на главной. | #69 |
| `GET /api/v1/calendar.ics` | Подписка в Google/Apple Calendar. Экран 11. | #79 |

### 12.9 Notifications inbox

| Эндпоинт | Назначение | Issue |
|---|---|---|
| `GET /api/v1/notifications` · `POST /api/v1/notifications/{id}/read` | Лента уведомлений в приложении (тап по 🔔). | — |

### 12.10 Snooze / back‑dated edits (UX‑фиксы)

Это **частично уже есть** через `performedAt` в `CareEvent` (можно отправить вчерашнюю дату → запись задним числом). А вот snooze — отдельный кейс.

| Эндпоинт | Назначение | Issue |
|---|---|---|
| `POST /api/v1/schedules/{id}/snooze` `{snoozeUntil?, preset: "hour"\|"evening"\|"tomorrow"}` | Кнопки snooze в push. Экран 05. | #118 |

---

## Приложение A · Маппинг экранов → реальные API

| Экран | Реально вызывает |
|---|---|
| **01 Главная** | `GET /api/v1/today` · `GET /api/v1/plants?limit=…` · `GET /api/v1/locations` |
| **02 Карточка** | `GET /api/v1/plants/{id}` · `GET /api/v1/plants/{id}/history?limit=10` · `GET /api/v1/stats/streak` · **(нет)** `/plants/{id}/schedules`, `/health`, `/diagnosis` |
| **03 Сегодня** | `GET /api/v1/today` |
| **04a Шаг 1** | `GET /api/v1/species?q=…` |
| **04b Шаг 2** | `GET /api/v1/locations` |
| **04 Шаг 3** | `GET /api/v1/species/{id}` (берём `wateringDays/mistingDays/fertilizingDays`) |
| **04c Шаг 4** | `POST /api/v1/plants` |
| **05 Уведомление** | push payload + `POST /api/v1/care-events` или `POST /schedules/{id}/snooze` **(нет)** |
| **06/06a/06b Sheet ухода** | `POST /api/v1/care-events` |
| **07/08/09 Auth** | **(нет)** — нужен `/auth/*` |
| **10 Пустая главная** | `GET /api/v1/plants` пустой |
| **11 График** | `GET /api/v1/calendar?from=…&to=…` |
| **12 Каталог** | `GET /api/v1/species` · **(нет)** поля `toxic` |
| **13 Я** | `GET /api/v1/me` **(нет)** · `PATCH /me` **(нет)** · vacation, sharing **(нет)** |
| **14 Отчёт** | **(нет)** `/reports/monthly` |
| **15 Диагноз** | **(нет)** `/plants/{id}/diagnosis` |
| **16 AI‑доктор** | **(нет)** `/ai/diagnose` |
| **17 Архив** | **(нет)** `?status=archived` |
| **18 Размножение** | **(нет)** `parentPlantId` + `/family` |
| **19 Покупки** | **(нет)** `/shopping` |

---

## Приложение B · Чего нет в дизайне, но есть в API

- `GET /api/v1/care-types` — справочник типов ухода. Можно использовать для локализации меток на клиенте.
- `SOIL_CHECK` — тип ухода, скрытый от REST (выкидывается из `/history`, недоступен в `CareEventType`). На мобилке игнорируем.
- `Location.emoji` — может пойти в UI комнат на главной/мастере.

---

## Приложение C · Что осталось доделать на бэке (из roadmap)

- 🟠 **#116** — настройки тихих часов / таймзоны (UI и сами эндпоинты на user).
- 🟠 **#67** — сезонные интервалы.
- 🟠 **#70** — мультидомность.
- 🟠 **#77** — шеринг ухода.
- 🟠 **#135** — освещение в справочнике (поле есть как `lightPreference`, но без текстов).

Мобильный дизайн полагается на все эти фичи, поэтому план релизов имеет смысл синхронизировать.
