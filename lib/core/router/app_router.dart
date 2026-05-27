import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/plant_card/presentation/plant_card_screen.dart';
import '../../features/schedule/presentation/schedule_screen.dart';
import 'app_shell.dart';

/// Корневой навигатор: на нём рисуются полноэкранные push-маршруты поверх
/// [AppShell] (без нижней навигации) — напр. карточка растения.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Роутер приложения (MADR-005).
///
/// `StatefulShellRoute.indexedStack` с двумя branch'ами под общим [AppShell]:
/// Сад (`/home`) и График (`/schedule`). Каждый branch держит свой стек: в саду
/// живёт push-маршрут `/home/plants/:id` (экран 02 «Карточка растения»). Сама
/// карточка — detail-экран со своей нижней кнопкой действия, поэтому рендерится
/// на [_rootNavigatorKey] (поверх shell, без плавающего таб-бара).
/// Каталог/Профиль ещё не branch'и — их табы в нижней навигации инертны
/// (coming-soon), см. [AppBottomNav].
///
/// Старт — `/home` (экран «Мой сад»), это фиксирует контракт стартового экрана.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'plants/:id',
                  name: 'plantCard',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    // `id` валидируется парсингом: некорректный путь → 0
                    // (карточка покажет ошибку секций через провайдеры).
                    // Навигация всегда строится из `plant.id` (int), так что
                    // в норме это надёжно.
                    final id =
                        int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                    return PlantCardScreen(plantId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/schedule',
              name: 'schedule',
              builder: (context, state) => const ScheduleScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
