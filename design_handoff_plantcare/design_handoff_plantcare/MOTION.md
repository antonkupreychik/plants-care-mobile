# MOTION.md — спецификация микровзаимодействий

> Точные значения движения для реализации в Expo / React Native.
> Визуальный референс (зацикленные демо) — `design/Motion.html`. Открой рядом при разработке.
> Библиотеки: **react-native-reanimated** (v3) для пружин/таймингов, **expo-haptics** для тактильного отклика, **react-native-gesture-handler** для pull-to-refresh.

---

## Базовые кривые

| Имя | Значение | Где применять |
|---|---|---|
| `spring.bouncy` | Reanimated `withSpring({ damping: 9, stiffness: 180, mass: 0.7 })` ≈ `cubic-bezier(.34,1.56,.64,1)` | Появления, морфинг, празднования (лёгкий overshoot) |
| `spring.gentle` | `withSpring({ damping: 18, stiffness: 200 })` | Сдвиги контента, sheets (без видимого overshoot) |
| `ease.standard` | `Easing.bezier(.4,0,.2,1)`, 250мс | Перемещения, тосты на выходе |
| `ease.in` | `Easing.in(Easing.quad)` | Падение капель, исчезновение |

**Длительности:** микро 200–300мс · стандарт 300–450мс · празднование 500–600мс. Никогда > 600мс для интерактива.

---

## 1 · Отметка ухода (морфинг кнопки)

Кнопка действия («Полить»/«Опрыскать»/«Подкормить») не уводит на новый экран — она сама становится подтверждением.

| Фаза | Что происходит | Тайминг | Кривая |
|---|---|---|---|
| press | scale → 0.94 | 100мс | ease.standard |
| ripple | бордюр `primary` расходится scale 1→1.5, opacity .7→0 | 200мс | ease-out |
| morph | bg `ink`→`primary`, scale 0.94→1.04→1 | 300мс | spring.bouncy |
| label→check | текст fade-out (80мс), чек fade+scale .4→1 | 220мс | spring.bouncy |

**Haptic:** `Haptics.impactAsync(Medium)` в момент press.
**Триггер:** `onPress` → оптимистично показываем успех, параллельно `POST /care-events`.
**Откат при ошибке:** если запрос упал — чек обратно в label, кнопка краснеет (`terracotta`) на 1.5с, тост ошибки (см. экран 39).

---

## 2 · Галочка успеха (после сохранения)

Полноэкранный/в-карточке успех первого ухода (экран 33) и завершения задачи.

| Слой | Анимация | Тайминг | Кривая |
|---|---|---|---|
| circle | scale 0→1.12→1 | 600мс | spring.bouncy |
| check | stroke-dashoffset 60→0 (прорисовка) | старт +180мс, 300мс | ease.standard |
| листья ×5 | разлёт от центра, opacity 0→1→0, translate 40–58px | старт +180мс, 400мс | ease-out |

**Haptic:** `Haptics.notificationAsync(Success)` одновременно с circle.
**Reanimated:** `withSequence` для circle; `withDelay` для check и листьев. SVG path — `useAnimatedProps` на `strokeDashoffset`.

---

## 3 · Реакция растения на полив

Иллюстрация растения «оживает» после полива — ключевой эмоциональный момент.

| Слой | Анимация | Тайминг | Кривая |
|---|---|---|---|
| капли ×3 | падают сверху, opacity 0→1→0, translateY 0→86px, со сдвигом по фазе | 220мс каждая, шаг 60мс | ease.in |
| растение | scale .96→1.04→1, rotate −1°→1°→0, brightness/saturate растут | 900мс | spring.bouncy |
| ✨ | появляется после, scale .4→1.1→1, opacity 0→.9→0 | старт +400мс, 400мс | ease |

**Haptic:** нет (визуальный момент). **Где:** в sheet полива (06) и в карточке растения после отметки.
**Реализация:** капли — `Animated` спрайты; «оживание» — `transform` + `filter` (на RN использовать `tintColor`/яркость через слой или Skia, либо ограничиться scale+rotate).

---

## 4 · Инкремент стрика (+1)

Маленькое празднование при росте стрика на главной/в успехе.

| Слой | Анимация | Тайминг | Кривая |
|---|---|---|---|
| число | roll 46→47 (translateY −56px в маске overflow:hidden) | 500мс | spring.bouncy |
| 🌱 | scale 1→1.3→1, rotate 0→−8°→0 | 500мс | spring.bouncy |

**Haptic:** `Haptics.impactAsync(Light)`. **Цвет:** старое число `inkSoft`, новое `primary`.
**Реализация:** две цифры в столбик, контейнер `overflow: hidden`, `translateY` через `withSpring`.

---

## 5 · Pull-to-refresh

Вместо системного спиннера — прорастающий росток (характер бренда).

| Фаза | Что происходит | Тайминг |
|---|---|---|
| pull | росток масштабируется scale 0→1 пропорционально оттягиванию | follows drag (interpolate) |
| trigger | при достижении порога росток крутится 360°, листья раскрываются | 600мс, ease |
| loading | росток мягко покачивается, пока идёт запрос | loop |
| release | контент возвращается на место | 300мс, ease.standard |

**Haptic:** `Haptics.impactAsync(Light)` в момент достижения порога (trigger).
**Реализация:** `react-native-gesture-handler` PanGesture + `interpolate(dragY, [0, threshold], [0, 1])` на scale. Не использовать стандартный `RefreshControl` — кастомный индикатор.

---

## 6 · Тост

Неблокирующее подтверждение действия с возможностью отмены.

| Фаза | Анимация | Тайминг | Кривая |
|---|---|---|---|
| in | translateY 90→0, opacity 0→1 | 300мс | spring.bouncy |
| hold | держится (с кнопкой «Отменить») | ~4000мс | — |
| out | translateY 0→90, opacity 1→0 | 250мс | ease.standard |

**Где:** после полива/опрыскивания (быстрый undo), сохранения настроек. **Позиция:** над таб-баром, отступ снизу 14px.
**Реализация:** глобальный toast-провайдер; `withSequence(withSpring(in), withDelay(4000, withTiming(out)))`. Свайп вниз — досрочно закрыть.

---

## Глобальные правила

- **prefers-reduced-motion:** `AccessibilityInfo.isReduceMotionEnabled()` → отключить spring/overshoot, оставить мгновенную смену состояния. Функциональность не зависит от анимаций.
- **Оптимистичный UI:** успех показываем сразу по тапу, сетевой запрос — параллельно. Откат при ошибке (см. экраны 39–41).
- **Haptics — только осмысленно:** успех (Success), важное действие (Medium), мелкое подтверждение (Light). Не на каждый тап.
- **60fps:** все transform/opacity на нативном потоке (Reanimated worklets). Не анимировать layout-свойства (width/height/top) в интерактиве.
- **Переходы между экранами** — отдельно от микровзаимодействий: стандартный stack-навигатор (`@react-navigation`), sheets через `@gorhom/bottom-sheet`.
