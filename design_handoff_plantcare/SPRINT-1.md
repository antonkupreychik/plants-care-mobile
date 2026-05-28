# Sprint 1 · Bootstrap мобильного приложения (5–7 рабочих дней)

> Этот файл — пошаговый план первой недели. Адресован разработчику (или Claude Code, который будет ему помогать).
>
> **Цель спринта:** работающий debug‑build на iOS симуляторе и Android эмуляторе, в котором можно открыть карточку Моники, нажать «Полить», и реальный запрос уйдёт в бэкенд `plants-care`.

---

## 0. Перед стартом — решения

### Auth Strategy

Выбери один из трёх вариантов **до первого коммита**:

**А. Dev‑hack — `X-Chat-Id` в .env** (0 дней работы)
- Экраны 07/08 — заглушки, не реализуются в первом спринте.
- В `.env`: `EXPO_PUBLIC_CHAT_ID=9000001`.
- API‑клиент шлёт этот хедер на каждый запрос.
- Подходит для **внутренней разработки** и **закрытой беты на TestFlight**.

**Б. Telegram magic‑link** (2–3 дня бэка + 1 день мобилки)
- Юзер шлёт `/start` боту → бот выдаёт 6‑значный код.
- Экраны 07 «Войти через Telegram» → 08 «Введите код» → 09 «Welcome».
- Бэк отдаёт JWT, мобилка хранит в `expo-secure-store`.
- **Рекомендую для MVP.** Не блокирует магазины, простой бэкенд.

**В. Apple Sign‑In + Google Sign‑In** (1 неделя бэка + 3 дня мобилки)
- Полноценно для публикации в App Store / Google Play.
- Требует Apple Developer аккаунта ($99/год) и Google OAuth client.
- **Делать перед публикацией**, не в первом спринте.

**Рекомендация:** для первого спринта взять вариант **А**, чтобы быстро собрать что‑то работающее. Параллельно стартовать issue на бэке для варианта **Б**.

---

## 1. Установить инструменты (полдня)

```bash
# 1. Node 20+
brew install node

# 2. EAS CLI
npm install -g eas-cli

# 3. (macOS) Xcode из App Store — для iOS симулятора
# 4. Android Studio + создать AVD — для Android эмулятора

# 5. Создать проект
npx create-expo-app@latest plantcate-mobile --template default
cd plantcate-mobile

# 6. Запустить
npx expo start
# нажми 'i' для iOS, 'a' для Android
```

---

## 2. Поставить зависимости (15 мин)

```bash
# Навигация
npx expo install expo-router react-native-screens react-native-safe-area-context

# Шрифты и SVG
npx expo install expo-font @expo-google-fonts/plus-jakarta-sans @expo-google-fonts/instrument-serif
npx expo install react-native-svg

# API и состояние
npm install @tanstack/react-query zustand axios
npm install -D @hey-api/openapi-ts typescript

# Безопасное хранилище
npx expo install expo-secure-store

# UI helpers
npx expo install react-native-reanimated react-native-gesture-handler
npx expo install @gorhom/bottom-sheet
```

---

## 3. Сгенерировать TypeScript клиент (1 час)

```bash
# Положи openapi.yaml из репозитория plants-care в проект:
mkdir -p api
curl -o api/openapi.yaml https://raw.githubusercontent.com/antonkupreychik/plants-care/main/src/main/resources/openapi/openapi.yaml

# Сгенерируй клиент:
npx openapi-ts -i api/openapi.yaml -o src/api/generated --client axios
```

**Внимание:** OpenAPI разбит на несколько файлов через `$ref`. Возможно понадобится сначала собрать единый файл:
```bash
npx @apidevtools/swagger-cli bundle src/main/resources/openapi/openapi.yaml -o api/openapi.bundled.yaml
```

После генерации в `src/api/generated/` появятся типизированные функции:
- `getToday({ headers: { 'X-Chat-Id': '...' } })`
- `listPlants(...)`, `createPlant({ requestBody, headers })`
- `createCareEvent(...)`

---

## 4. Структура проекта (1 час)

```
plantcate-mobile/
├── app/                          ← expo-router
│   ├── _layout.tsx               ← root layout, QueryProvider, fonts
│   ├── (tabs)/
│   │   ├── _layout.tsx           ← bottom nav (Сад/График/Каталог/Я)
│   │   ├── index.tsx             ← 01 Home
│   │   ├── calendar.tsx          ← 11 Week calendar (Sprint 2)
│   │   ├── catalog.tsx           ← 12 Catalog (Sprint 3)
│   │   └── profile.tsx           ← 13 Profile (Sprint 3)
│   ├── plants/
│   │   ├── [id].tsx              ← 02 Plant card
│   │   └── new/                  ← 04a/04b/04/04c (Sprint 2)
│   └── auth/
│       ├── welcome.tsx           ← 07 (заглушка в Sprint 1)
│       └── welcome-back.tsx      ← 09
├── src/
│   ├── api/
│   │   ├── client.ts             ← axios instance + auth interceptor
│   │   └── generated/            ← из openapi-ts
│   ├── components/
│   │   ├── plants/
│   │   │   ├── Monstera.tsx
│   │   │   ├── Fern.tsx
│   │   │   └── … (5 illustrations)
│   │   ├── ui/
│   │   │   ├── Icon.tsx          ← из design/screens.jsx
│   │   │   ├── Card.tsx
│   │   │   ├── Chip.tsx
│   │   │   ├── BottomNav.tsx
│   │   │   └── …
│   │   └── PhoneShell.tsx        ← не нужен в RN
│   ├── theme/
│   │   ├── tokens.ts             ← PC_THEMES → light + dark
│   │   └── ThemeProvider.tsx
│   ├── hooks/
│   │   ├── useToday.ts           ← обёртка над getToday()
│   │   ├── usePlants.ts
│   │   ├── usePlant.ts
│   │   └── useCareEvent.ts       ← mutation для POST /care-events
│   └── store/
│       └── ui.ts                 ← zustand: theme, filters
├── assets/
│   ├── fonts/                    ← .ttf файлы
│   └── icon.png                  ← app icon (TODO)
├── api/
│   └── openapi.yaml              ← source of truth
├── eas.json                      ← billable build config
└── app.json
```

---

## 5. Перенести design tokens (1 час)

`src/theme/tokens.ts`:

```ts
// Скопировать PC_THEMES из design/screens.jsx строки 8–45
// Это уже валидный TS-объект, никаких переделок не нужно.
export const tokens = {
  light: {
    bg: '#F1ECE0',
    surface: '#FBF7EC',
    surfaceWarm: '#EDE5D2',
    ink: '#1F2A1E',
    inkSoft: '#5C6650',
    inkMute: '#8C9180',
    line: 'rgba(31,42,30,0.10)',
    primary: '#3F6B3A',
    primarySoft: '#DCE7C9',
    leaf: '#6F8A4F',
    leafDark: '#3F5A2E',
    leafLight: '#A8C081',
    terracotta: '#C77B5C',
    pot: '#B9876B',
    potShadow: '#8A5E48',
    chipBg: '#E7E0CE',
    fab: '#1F2A1E',
    fabInk: '#FBF7EC',
  },
  dark: { /* … симметрично */ },
};

export type Theme = typeof tokens.light;
```

`src/theme/ThemeProvider.tsx`:

```tsx
import { createContext, useContext } from 'react';
import { useColorScheme } from 'react-native';
import { tokens, Theme } from './tokens';

const ThemeContext = createContext<Theme>(tokens.light);

export function ThemeProvider({ children }) {
  const scheme = useColorScheme();
  return (
    <ThemeContext.Provider value={scheme === 'dark' ? tokens.dark : tokens.light}>
      {children}
    </ThemeContext.Provider>
  );
}

export const useTheme = () => useContext(ThemeContext);
```

---

## 6. Перенести SVG иллюстрации (2 часа)

В `src/components/plants/Monstera.tsx`:

```tsx
import Svg, { G, Path, Circle, Ellipse } from 'react-native-svg';
import { useTheme } from '@/theme/ThemeProvider';

export function Monstera({ size = 100 }: { size?: number }) {
  const t = useTheme();
  return (
    <Svg width={size} height={size} viewBox="0 0 120 120" fill="none">
      <G transform="translate(60 60) rotate(-25)">
        <Path d="..." fill={t.leafDark} />
        {/* всё, что было в SVG в design/screens.jsx — переносится 1‑в‑1 */}
      </G>
      {/* … */}
    </Svg>
  );
}
```

**Что важно:** в RN `<svg>` → `<Svg>`, `<g>` → `<G>`, `<path>` → `<Path>` и т.д. — компоненты из `react-native-svg` с заглавных букв. Остальные атрибуты одинаковые.

Сделать так для всех 5 растений: Monstera, Fern, Succulent, Pothos, Cactus.

---

## 7. Перенести Icon компонент (30 мин)

`src/components/ui/Icon.tsx` — взять функцию `Icon` из `design/screens.jsx` строки 174–199, превратить `<svg>` в `<Svg>`. Имена иконок остаются те же: `drop`, `spray`, `fert`, `sun`, `search`, `bell`, `home`, `calendar`, `user`, `plus`, `arrow-left`, `more`, `check`, `leaf`, `thermo`, `heart`.

---

## 8. API client (1 час)

`src/api/client.ts`:

```ts
import axios from 'axios';
import * as SecureStore from 'expo-secure-store';

const BASE_URL = process.env.EXPO_PUBLIC_API_URL ?? 'http://localhost:8080';

export const api = axios.create({ baseURL: BASE_URL });

api.interceptors.request.use(async (config) => {
  // Dev-hack: chat_id из env
  const chatId = process.env.EXPO_PUBLIC_CHAT_ID;
  const userId = process.env.EXPO_PUBLIC_USER_ID;

  if (chatId) config.headers['X-Chat-Id'] = chatId;
  if (userId) config.headers['X-User-Id'] = userId;

  // Когда появится JWT — добавить:
  // const token = await SecureStore.getItemAsync('jwt');
  // if (token) config.headers.Authorization = `Bearer ${token}`;

  return config;
});

api.interceptors.response.use(
  (r) => r,
  (err) => {
    // Map ApiErrorResponse → throw
    if (err.response?.data?.error) {
      const { code, message } = err.response.data.error;
      throw new ApiError(code, message);
    }
    throw err;
  },
);

export class ApiError extends Error {
  constructor(public code: string, message: string) {
    super(message);
  }
}
```

`.env`:
```
EXPO_PUBLIC_API_URL=https://plants-care.up.railway.app
EXPO_PUBLIC_CHAT_ID=9000001
EXPO_PUBLIC_USER_ID=1
```

---

## 9. Реализовать 5 экранов (3 дня)

### День 1 — экран 01 Home

```tsx
// app/(tabs)/index.tsx
import { useQuery } from '@tanstack/react-query';
import { getToday, listPlants, listLocations } from '@/api/generated';

export default function HomeScreen() {
  const today = useQuery({ queryKey: ['today'], queryFn: () => getToday() });
  const plants = useQuery({ queryKey: ['plants'], queryFn: () => listPlants({ limit: 20 }) });
  const rooms = useQuery({ queryKey: ['locations'], queryFn: () => listLocations() });

  if (today.isLoading || plants.isLoading) return <SkeletonHome />;
  if (today.error || plants.error) return <ErrorState />;

  return (
    <ScrollView style={{ backgroundColor: theme.bg }}>
      <Header />
      <DiagnosisAlert />   {/* пока — заглушка, реальный endpoint придёт позже */}
      <WeatherStrip />     {/* пока — заглушка */}
      <TodayCard tasks={today.data.tasks} />
      <RoomsChips rooms={rooms.data} />
      <PlantGrid plants={plants.data.items} />
    </ScrollView>
  );
}
```

Вёрстка — внимательно сверяясь с `design/screens.jsx → HomeScreen`. Все размеры, отступы, шрифты — оттуда.

### День 2 — экран 02 Plant Card

```tsx
// app/plants/[id].tsx
import { useLocalSearchParams } from 'expo-router';
import { getPlant, getPlantHistory, getPlantStreak } from '@/api/generated';

export default function PlantCardScreen() {
  const { id } = useLocalSearchParams();
  const plant = useQuery({ queryKey: ['plant', id], queryFn: () => getPlant({ id: Number(id) }) });
  const history = useQuery({ queryKey: ['plant', id, 'history'], queryFn: () => getPlantHistory({ id: Number(id), limit: 10 }) });
  const streak = useQuery({ queryKey: ['plant', id, 'streak'], queryFn: () => getPlantStreak({ plantId: Number(id) }) });

  // … вёрстка из design/screens.jsx → PlantCardScreen
}
```

### День 3 — экран 06 Water sheet

```tsx
// components/sheets/WaterSheet.tsx — открывается из карточки или с главной
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { createCareEvent } from '@/api/generated';
import * as Crypto from 'expo-crypto';

export function WaterSheet({ plant, onClose }) {
  const qc = useQueryClient();
  const [amountMl, setAmountMl] = useState(200);
  const [soilWasDry, setSoilWasDry] = useState(true);
  const [performedAt, setPerformedAt] = useState(new Date());

  const mutate = useMutation({
    mutationFn: () => createCareEvent({
      requestBody: {
        plantId: plant.id,
        type: 'WATER',
        performedAt: performedAt.toISOString(),
        note: soilWasDry ? `${amountMl}мл, грунт сухой` : `${amountMl}мл`,
        clientId: Crypto.randomUUID(),
      },
    }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['today'] });
      qc.invalidateQueries({ queryKey: ['plant', plant.id] });
      qc.invalidateQueries({ queryKey: ['plant', plant.id, 'history'] });
      onClose();
    },
  });

  // … вёрстка из design/screens-v2.jsx → WaterActionScreen
}
```

### День 3 (вторая половина) — экраны 07 и 09 как заглушки

Если выбрал auth‑вариант **А**, экраны 07/08 просто рендерят:
```tsx
<View>
  <Text>В debug‑режиме auth пропущен. Подменяй X-Chat-Id в .env.</Text>
  <Button onPress={() => router.replace('/(tabs)/')}>В сад</Button>
</View>
```

Полную вёрстку 07/09 делаем в Sprint 3 вместе с реальным auth.

---

## 10. Перед концом спринта — checklist

- [ ] Запускается на iOS симуляторе и Android эмуляторе.
- [ ] Шрифты загружены (Plus Jakarta Sans, Instrument Serif).
- [ ] Theme tokens переключаются по системной теме.
- [ ] `GET /api/v1/today` отдаёт реальные данные (если есть `X-Chat-Id` с растениями в БД).
- [ ] Экран 01 показывает реальный список растений.
- [ ] Экран 02 показывает реальную карточку.
- [ ] Кнопка «Полить» → `POST /api/v1/care-events` → запись появляется в дневнике.
- [ ] Идемпотентность работает: двойной тап не создаёт две записи (одинаковый `clientId`).
- [ ] Skeleton / loading / error states нарисованы хотя бы на скелетном уровне.

---

## 11. Что делать дальше (Sprint 2+)

| Спринт | Экраны | Зависимости |
|---|---|---|
| **2** | 03 Today, 04a/04b/04/04c мастер, 10 Empty | — |
| **3** | 07/08 Auth (Telegram magic‑link), 09 Welcome back | Бэк: `/auth/telegram/*` |
| **4** | 11 Calendar, 13 Profile | Бэк: `PATCH /me`, `/me/settings` |
| **5** | 05 Push, 06a/06b Spray/Fert sheets, snooze | `expo-notifications`, push token register |
| **6** | 12 Catalog, 14 Monthly report, 17 Archive | Бэк: `/reports/monthly`, `archive` |
| **7+** | 15 Diagnosis, 16 AI doctor, 18 Propagation, 19 Shopping | Бэк‑gaps из § 12 `api-contract.md` |

---

## 12. Известные ловушки

- **`/today` использует `X-Chat-Id`, а `/plants` — `X-User-Id`.** Это PoC‑несоответствие на бэке (см. `api-contract.md` § 1). Клиент должен знать оба заголовка. Когда появится JWT — оба удалить.
- **`taskType` в `/today` ≠ `type` в `/care-events`.** В today это `WATERING/MISTING/...`, в care-events — `WATER/SPRAY/...`. См. справочник `/care-types` или маппинг руками.
- **`POST /care-events` без `clientId`** не идемпотентен — двойной тап на flaky сети создаст два полива. Всегда генерируй UUID через `expo-crypto`.
- **`/calendar` максимум 60 дней.** Запрашивай неделю/месяц, не год.
- **Soft‑delete растения** — `DELETE /plants/{id}` ставит `archivedAt`. Реальное удаление недоступно через API. Учитывай при «удалении» в UI — оно навсегда из обычных списков, но в архив пока попасть нельзя (gap).
