# Скриншоты экранов — эталон для сверки

Рендеры всех 38 экранов (43 файла с учётом под-шагов мастера и sheet'ов ухода) в **light** и **dark** темах. Сняты из `design/PlantCate.html` в нативном размере (412 CSS‑px ширина, полная высота экрана).

**Назначение:** визуальный эталон для агента/разработчика. После реализации экрана сверяй результат с соответствующим файлом — композиция, иерархия, отступы, цвета, состояние.

## Структура

```
screenshots/
├── light/   ← 43 PNG, светлая тема
└── dark/    ← 43 PNG, тёмная тема
```

Имена файлов: `<номер экрана>-<slug>.png`. Один и тот же номер есть в обеих папках.

## Карта файлов → компонент → README

| Файл | Экран | Компонент (`design/`) |
|---|---|---|
| `01-home` | 01 Главная | `screens.jsx → HomeScreen` |
| `02-plant-card` | 02 Карточка растения | `screens.jsx → PlantCardScreen` |
| `03-today` | 03 Сегодня | `screens-v2.jsx → TodayScreen` |
| `04-add-step3` | 04 Мастер · шаг 3 (расписание) | `screens-v2.jsx → AddPlantScreen` |
| `04a-add-step1` | 04a Мастер · шаг 1 (вид) | `screens-v3.jsx → AddPlantStep1Screen` |
| `04b-add-step2` | 04b Мастер · шаг 2 (имя/комната) | `screens-v3.jsx → AddPlantStep2Screen` |
| `04c-add-step4` | 04c Мастер · шаг 4 (фото/окно) | `screens-v3.jsx → AddPlantStep4Screen` |
| `05-push-notification` | 05 Push (lock screen) | `screens-v2.jsx → NotificationScreen` |
| `06-water-sheet` | 06 Полить (sheet) | `screens-v2.jsx → WaterActionScreen` |
| `06a-spray-sheet` | 06a Опрыскать (sheet) | `screens-v3.jsx → SprayActionScreen` |
| `06b-fert-sheet` | 06b Подкормить (sheet) | `screens-v3.jsx → FertActionScreen` |
| `07-auth-welcome` | 07 Вход | `screens-auth.jsx → AuthWelcomeScreen` |
| `08-auth-telegram` | 08 Код Telegram | `screens-auth.jsx → AuthTelegramScreen` |
| `09-welcome-back` | 09 Привет (welcome back) | `screens-auth.jsx → AuthWelcomeBackScreen` |
| `10-home-empty` | 10 Пустой сад | `screens-v3.jsx → HomeEmptyScreen` |
| `11-week-calendar` | 11 График недели | `screens-v4.jsx → WeekCalendarScreen` |
| `12-catalog` | 12 Каталог видов | `screens-v4.jsx → CatalogScreen` |
| `13-profile` | 13 Профиль | `screens-v4.jsx → ProfileScreen` |
| `14-monthly-report` | 14 Месячный отчёт | `screens-v4.jsx → MonthlyReportScreen` |
| `15-diagnosis` | 15 Диагноз | `screens-v4.jsx → PlantDiagnosisScreen` |
| `16-ai-doctor` | 16 AI‑доктор | `screens-v4.jsx → AIDoctorScreen` |
| `17-archive` | 17 Архив (memorial) | `screens-v4.jsx → ArchiveScreen` |
| `18-propagation` | 18 Родословная | `screens-v4.jsx → PropagationScreen` |
| `19-shopping` | 19 Список покупок | `screens-v4.jsx → ShoppingListScreen` |
| `20-species-detail` | 20 Карточка вида | `screens-v5.jsx → SpeciesDetailScreen` |
| `21-care-history` | 21 История ухода | `screens-v5.jsx → CareHistoryScreen` |
| `22-edit-schedule` | 22 Редактирование расписания | `screens-v5.jsx → EditScheduleScreen` |
| `23-quiet-hours` | 23 Тихие часы | `screens-v6.jsx → QuietHoursScreen` |
| `24-notifications-inbox` | 24 Лента уведомлений | `screens-v6.jsx → NotificationsInboxScreen` |
| `25-vacation` | 25 Режим отпуска | `screens-v7.jsx → VacationScreen` |
| `26-sharing` | 26 Совместный уход | `screens-v7.jsx → SharingScreen` |
| `27-push-permission` | 27 Онбординг пушей | `screens-v7.jsx → PushPermissionScreen` |
| `28-loading` | 28 Загрузка (skeleton) | `screens-v8.jsx → LoadingScreen` |
| `29-offline` | 29 Офлайн / ошибка | `screens-v8.jsx → OfflineScreen` |
| `30-empty-search` | 30 Пустой поиск | `screens-v8.jsx → EmptySearchScreen` |
| `31-empty-journal` | 31 Пустой дневник | `screens-v9.jsx → EmptyJournalScreen` |
| `32-empty-inbox` | 32 Пустая лента | `screens-v9.jsx → EmptyInboxScreen` |
| `33-first-care-success` | 33 Успех первого ухода | `screens-v9.jsx → FirstWaterSuccessScreen` |
| `34-rooms-homes` | 34 Дома и места | `screens-v10.jsx → RoomsHomesScreen` |
| `35-seasonal` | 35 Сезонные интервалы | `screens-v10.jsx → SeasonalIntervalsScreen` |
| `36-time-picker` | 36 Пикер времени | `screens-v10.jsx → TimePickerSheet` |
| `37-timezone` | 37 Выбор таймзоны | `screens-v10.jsx → TimezonePickerScreen` |
| `38-language` | 38 Язык приложения | `screens-v10.jsx → LanguageScreen` |

> Детальное описание каждого экрана (layout, компоненты, API) — в `../README.md`, раздел 4.
