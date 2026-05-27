# Handoff: PlantCate — мобильное приложение

> Пакет для разработки на **Expo / React Native** (iOS + Android из одной кодовой базы).
> Бэкенд: Java / Spring Boot, репозиторий [`antonkupreychik/plants-care`](https://github.com/antonkupreychik/plants-care).
> Дизайн актуален на 27 мая 2026.

---

## 0. TL;DR для разработчика

1. Прочти **`SPRINT-1.md`** — там пошаговый план первой недели: какие пакеты ставить, какие экраны делать в первую очередь, какой auth использовать.
2. Прочти **`api-contract.md`** — это не моё предположение, а сверка с реальным `openapi.yaml` репозитория `plants-care`. § 1–11 — что есть, § 12 — что просит дизайн и чего пока нет.
3. Открой `design/PlantCate.html` в браузере — это интерактивный прототип всех 24 экранов в светлой и тёмной теме.

---

## 1. Overview

**PlantCate** — мобильное приложение‑напоминалка по уходу за домашними растениями. Уникальная особенность: каждое растение «говорит» голосом от первого лица.

Эстетика — ботаническая, тёплая, органическая. Поддерживает светлую и тёмную тему.

**24 экрана в 6 секциях:**

| Секция | Экраны | Назначение |
|---|---|---|
| **Авторизация** | 07, 08, 09 | Welcome · Telegram code · Welcome back |
| **Главный продукт** | 01, 02 | Главная (сад) · карточка растения |
| **Глубже в продукт** | 03, 04, 05, 06 | Сегодня · мастер шаг 3 · push уведомление · sheet полива |
| **Мастер добавления** | 04a, 04b, 04c | Шаги 1, 2, 4 (вид → имя/комната → фото/окно) |
| **Состояния** | 10 | Пустой сад |
| **Навигация** | 11, 12, 13, 19 | График · каталог видов · профиль · список покупок |
| **Sheets ухода** | 06a, 06b | Опрыскать · подкормить |
| **Здоровье** | 15, 16 | Диагностика проблемного растения · AI‑доктор |
| **Истории и связи** | 14, 17, 18 | Месячный отчёт · архив (memorial) · родословная |

---

## 2. About the Design Files

Файлы в папке `design/` — это **дизайн‑референс, сделанный на HTML + React (через Babel inline)**. Это не продакшен‑код для копирования — это интерактивный прототип, демонстрирующий желаемый внешний вид и поведение.

**Задача разработки** — пересоздать эти экраны в **Expo / React Native**, используя:
- `expo-router` для навигации
- `react-native-svg` для иллюстраций (переносятся 1‑в‑1)
- `expo-font` для шрифтов
- TanStack Query для серверного состояния
- TypeScript

Что переносится из HTML‑прототипа 1‑в‑1:
- Цветовые токены `PC_THEMES` (см. `design/screens.jsx`, строки 1–45) → `theme/tokens.ts`.
- SVG‑иллюстрации растений (Monstera, Fern, Succulent, Pothos, Cactus).
- Шрифты `Plus Jakarta Sans` (UI) + `Instrument Serif` (заголовки‑акценты).

Что **не** переносится напрямую и требует адаптации:
- `display: grid`, `gridTemplateColumns`, `aspect-ratio` → flex (`flexBasis`, `width: '50%'`).
- `overflow: auto` → `<ScrollView>` / `<FlatList>`.
- `<button>` → `<Pressable>`.
- `boxShadow` → `shadow*` (iOS) + `elevation` (Android).

---

## 3. Fidelity

**Высокая (hi‑fi)**. Все цвета, типографика, скругления, отступы и иллюстрации — финальные. Шрифты лицензированы (OFL). Воссоздавайте пиксель‑в‑пиксель, насколько это разумно в нативной среде.

---

## 4. Screens / Views

Каждый экран — компонент в одном из `.jsx` файлов в `design/`. Я перечислю ключевые экраны и где их искать.

### 01 · Главная — Мой сад (`design/screens.jsx → HomeScreen`)
Header + приветствие · сегодняшние задачи в карточке · алерт «проблемное растение» · виджет погоды · «Мой сад» с чипами комнат · сетка растений 2×N с мини‑кольцом Health Score · FAB · BottomNav.

**API:** `GET /api/v1/today` + `GET /api/v1/plants` + `GET /api/v1/locations`. Текстовые подписи (`mood_label`, `voice_line`) — клиент генерит сам, в API нет.

### 02 · Карточка растения (`design/screens.jsx → PlantCardScreen`)
Hero с иллюстрацией · speech bubble (текст реплики) · расписание ухода с кольцами прогресса · условия (свет/температура/влажность) · дневник · бейджи Health Score + Toxicity + Родословная.

**API:** `GET /api/v1/plants/{id}` (header `X-User-Id`) + `GET /api/v1/plants/{id}/history` (header `X-Chat-Id`!) + `GET /api/v1/stats/streak?plantId=…`.
**Чего нет в API:** `GET /plants/{id}/schedules`, `/health`, поле `toxic` в Species.

### 03 · Сегодня (`design/screens-v2.jsx → TodayScreen`)
Заголовок «Сегодня 5 забот», прогресс‑карточка, фильтр‑чипы (Полив/Опрыск/Подкормка/Просрочено), секции «Утром»/«Вечером», коллапс «выполнено».

**API:** `GET /api/v1/today` — даёт плоский список `tasks`. Группировку по «утро/вечер» делает клиент по `nextDueAt`.

### 04 · Мастер добавления растения

- **04a Шаг 1** (`screens-v3.jsx → AddPlantStep1Screen`) — поиск вида, категории, фото‑распознавание (placeholder). **API:** `GET /api/v1/species?q=…`.
- **04b Шаг 2** (`screens-v3.jsx → AddPlantStep2Screen`) — имя, комната. **API:** `GET /api/v1/locations`.
- **04 Шаг 3** (`screens-v2.jsx → AddPlantScreen`) — расписание ухода. **API:** `GET /api/v1/species/{id}` для дефолтов (`wateringDays`, `mistingDays`, `fertilizingDays`).
- **04c Шаг 4** (`screens-v3.jsx → AddPlantStep4Screen`) — фото, сторона окна. **API:** `POST /api/v1/plants`.

### 05 · Lock‑screen уведомление (`screens-v2.jsx → NotificationScreen`)
Тёмный мшистый фон, glassmorphism notification card, 4 quick actions: «Опрыскано / Через час / Вечером / Завтра».

> Это макет push‑payload, не наш экран. В коде — конфигурация `expo-notifications` + категории действий.
> **API:** quick actions триггерят `POST /api/v1/care-events` или будущий snooze endpoint (gap #118).

### 06 · Полить — bottom sheet (`screens-v2.jsx → WaterActionScreen`)
Слайдер мл, quick‑chips 100/200/300/500, toggle «сухая земля», поле «полил задним числом», CTA.

**API:** `POST /api/v1/care-events` с `clientId` (UUID для идемпотентности), `performedAt` (UTC), `note`.

### 06a/06b · Опрыскать / Подкормить (`screens-v3.jsx`)
Аналогичные sheet с разной палитрой. Тип `SPRAY` / `FERTILIZE` в `care-events`.

### 07 · Welcome (`screens-auth.jsx → AuthWelcomeScreen`)
Google / Telegram / Гость. **API:** см. § 12.1 в `api-contract.md` — auth flow нужно добавлять.

### 08 · Telegram код (`screens-auth.jsx → AuthTelegramScreen`)
6‑значный код, таймер ресенда. **API gap.**

### 09 · Welcome back (`screens-auth.jsx → AuthWelcomeBackScreen`)
Аватар, имя, CTA «Добавить первое растение».

### 10 · Пустой сад (`screens-v3.jsx → HomeEmptyScreen`)
Что видит юзер, если `GET /api/v1/plants` вернул пусто.

### 11 · График (`screens-v4.jsx → WeekCalendarScreen`)
Календарь на неделю с матрицей задач.
**API:** `GET /api/v1/calendar?from=…&to=…` — возвращает `Map<YYYY‑MM‑DD, TaskDto[]>`, максимум 60 дней.

### 12 · Каталог видов (`screens-v4.jsx → CatalogScreen`)
Справочник 30 видов с фильтрами и бейджами токсичности 🐈.
**API:** `GET /api/v1/species`. **Gap:** поле `toxic` (issue #128 — нужно проверить, реально ли уже в API).

### 13 · Профиль (`screens-v4.jsx → ProfileScreen`)
Статистика, тихие часы, таймзона, отпуск‑режим, шеринг, ещё.
**API gap:** `/me`, `/me/settings`, `/vacation`, `/sharing` — всё это roadmap, но в OpenAPI ещё нет.

### 14 · Месячный отчёт (`screens-v4.jsx → MonthlyReportScreen`)
**API gap:** `GET /api/v1/reports/monthly?month=2026-05` (roadmap #137).

### 15 · Диагноз проблемного (`screens-v4.jsx → PlantDiagnosisScreen`)
**API gap:** `GET /plants/{id}/diagnosis` (roadmap #73).

### 16 · AI‑доктор (`screens-v4.jsx → AIDoctorScreen`)
**API gap:** `POST /ai/diagnose` (бэклог — top‑1 кандидат).

### 17 · Архив / Memorial (`screens-v4.jsx → ArchiveScreen`)
**API gap:** `GET /plants?status=archived` или отдельный `/archive` (roadmap #117).

### 18 · Родословная (`screens-v4.jsx → PropagationScreen`)
**API gap:** `parentPlantId` в `PlantCreateRequest` + `/plants/{id}/family` (roadmap #139).

### 19 · Список покупок (`screens-v4.jsx → ShoppingListScreen`)
**API gap:** `/shopping` (roadmap #136).

---

## 5. State Management

**Серверное состояние** — TanStack Query (React Query). Ключи кеша по эндпоинту:

```ts
['today']                              // GET /api/v1/today
['plants', { locationId, offset }]     // GET /api/v1/plants
['plant', plantId]                     // GET /api/v1/plants/{id}
['plant', plantId, 'history']          // GET /api/v1/plants/{id}/history
['plant', plantId, 'streak']           // GET /api/v1/stats/streak
['locations']                          // GET /api/v1/locations
['calendar', { from, to }]             // GET /api/v1/calendar
['species', { q, offset }]             // GET /api/v1/species
['species', speciesId]                 // GET /api/v1/species/{id}
['care-types']                         // GET /api/v1/care-types
```

**Инвалидация после `POST /api/v1/care-events`:**
- `['today']`
- `['plant', plantId]` (изменился `nextDueAt`)
- `['plant', plantId, 'history']`
- `['plant', plantId, 'streak']`
- `['calendar', ...]`

**UI‑состояние** — Zustand (тема, фильтры, активная локация). Не Redux — слишком жирно для этого.

**Auth токен / chat_id** — `expo-secure-store`.

---

## 6. Design Tokens

### Цвета — light
| Токен          | Значение                       | Назначение                          |
|----------------|--------------------------------|-------------------------------------|
| `bg`           | `#F1ECE0`                      | Фон экрана                          |
| `surface`      | `#FBF7EC`                      | Карточки                            |
| `surfaceWarm`  | `#EDE5D2`                      | Аватары растений, тёплые фоны       |
| `ink`          | `#1F2A1E`                      | Основной текст                      |
| `inkSoft`      | `#5C6650`                      | Вторичный текст                     |
| `inkMute`      | `#8C9180`                      | Третичный текст / placeholder       |
| `line`         | `rgba(31,42,30,0.10)`          | Границы                              |
| `primary`      | `#3F6B3A`                      | Бренд‑зелёный                       |
| `primarySoft`  | `#DCE7C9`                      | Светлый бренд‑фон                   |
| `leaf`         | `#6F8A4F`                      | Иллюстрации (основной лист)         |
| `leafDark`     | `#3F5A2E`                      | Иллюстрации (задний лист)           |
| `leafLight`    | `#A8C081`                      | Иллюстрации (highlight)             |
| `terracotta`   | `#C77B5C`                      | Акцент: жажда / просрочка / ❤︎      |
| `pot`          | `#B9876B`                      | Горшок                               |
| `potShadow`    | `#8A5E48`                      | Горшок (тень)                       |
| `chipBg`       | `#E7E0CE`                      | Фон чипов                           |
| `fab`          | `#1F2A1E`                      | FAB                                  |
| `fabInk`       | `#FBF7EC`                      | Иконка FAB                          |

### Цвета — dark
Все токены продублированы для тёмной темы. См. `design/screens.jsx` строки 25–45.

### Внешние бренд‑цвета
- Telegram blue: `#229ED9`
- Google: `#4285F4 / #34A853 / #FBBC05 / #EA4335`

### Типографика
| Стиль                     | Шрифт                         | Размер  | Вес |
|---------------------------|-------------------------------|---------|-----|
| H1 / hero                 | Instrument Serif              | 38–44   | 400 |
| H2                        | Instrument Serif              | 28–36   | 400 |
| H3                        | Instrument Serif              | 20–24   | 400 |
| Body                      | Plus Jakarta Sans             | 14–15   | 400 |
| Body bold                 | Plus Jakarta Sans             | 14–15   | 600 |
| Caption (uppercase)       | Plus Jakarta Sans             | 11–13   | 600 |
| Voice line                | Instrument Serif italic       | 13–17   | 400 |
| Numeric big               | Instrument Serif              | 80–96   | 400 |

### Скругления
- Чипы / pill: `999px` или `18–20px`
- Карточки: `22–28px`
- Sheet top: `32px`
- Аватары растений: `16–20px`

### Тени
- FAB: `0 12px 30px rgba(0,0,0,0.25)`
- Bottom nav: `0 18px 40px rgba(0,0,0,0.10)`
- Кнопка‑действие: `0 4px 12px <tint>40`
- Sheet: `0 -20px 60px rgba(0,0,0,0.20)`

---

## 7. Assets

- **Шрифты:** Plus Jakarta Sans + Instrument Serif (OFL) — кладём `.ttf` в репо, грузим через `expo-font`.
- **Иллюстрации:** 5 SVG в `design/screens.jsx` (Monstera, Fern, Succulent, Pothos, Cactus).
- **Иконки:** инлайн в функции `Icon` (`design/screens.jsx`). Альтернатива — `lucide-react-native`.
- **Google G, Telegram paper plane:** инлайн SVG в `design/screens-auth.jsx`.
- **App icon / splash:** отсутствуют в прототипе, нужно дорисовать. Идея — лист на фоне `primary`.

---

## 8. Files

В этом пакете:

```
design_handoff_plantcate/
├── README.md                ← этот файл
├── SPRINT-1.md              ← пошаговый план первой недели
├── api-contract.md          ← REST контракт + список gaps
└── design/
    ├── PlantCate.html       ← открыть в браузере, увидеть все 24 экрана
    ├── screens.jsx          ← 01 Home, 02 Plant card
    ├── screens-v2.jsx       ← 03 Today, 04 Add step 3, 05 Notification, 06 Water
    ├── screens-v3.jsx       ← 04a/04b/04c мастер, 06a/06b sheets, 10 empty
    ├── screens-v4.jsx       ← 11 Calendar, 12 Catalog, 13 Profile, 14 Report, 15 Diagnosis, 16 AI doctor, 17 Archive, 18 Propagation, 19 Shopping
    ├── screens-auth.jsx     ← 07 Welcome, 08 Telegram, 09 Welcome back
    ├── design-canvas.jsx    ← каркас прототипа (не переносить)
    ├── android-frame.jsx    ← каркас прототипа (не переносить)
    └── tweaks-panel.jsx     ← каркас прототипа (не переносить)
```

---

## 9. Open Questions перед стартом

Эти решения лучше зафиксировать в начале:

1. **Auth:** Telegram magic‑link (через бота) или Apple/Google sign‑in или гибрид? См. `SPRINT-1.md` § «Auth Strategy».
2. **Voice lines:** реплики растений генерим на клиенте по `taskType` + контексту, или бэк отдаёт `voiceLine` поле? Сейчас в API нет.
3. **Push‑уведомления:** Expo Push Service или прямо FCM + APNs?
4. **MVP scope:** 5 экранов (Home/Plant/Water/Auth Welcome/Welcome back) или сразу больше?
5. **Repo:** новый `plantcate-mobile` или монорепо с бэкендом?

---

## 10. Suggested Issues for Claude Code

Готовая нарезка работы на спринты — см. `SPRINT-1.md` для первой недели. После — спринты 2–5 в roadmap проекта.
