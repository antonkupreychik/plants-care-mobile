import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/add_plant/presentation/add_plant_wizard_screen.dart';
import '../../features/archive/presentation/archive_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/catalog/presentation/species_detail_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/today_screen.dart';
import '../../features/plant_card/presentation/plant_card_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/rooms/presentation/rooms_screen.dart';
import '../../features/schedule/presentation/schedule_screen.dart';
import 'app_shell.dart';

/// Корневой навигатор: на нём рисуются полноэкранные push-маршруты поверх
/// [AppShell] (без нижней навигации) — напр. карточка растения.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Роутер приложения (MADR-005).
///
/// `StatefulShellRoute.indexedStack` с тремя branch'ами под общим [AppShell]:
/// Сад (`/home`), График (`/schedule`) и Каталог (`/catalog`). Каждый branch
/// держит свой стек: в саду живут push-маршруты `/home/today` (экран 03
/// «Сегодня»), `/home/add` (экран 04 «Мастер добавления») и `/home/plants/:id`
/// (экран 02 «Карточка растения»), в каталоге —
/// `/catalog/:id` (экран 13 «Деталь вида»), в профиле — `/profile/rooms`
/// (управление комнатами). Detail/drill-in-экраны со своей нижней кнопкой/назад
/// рендерятся на [_rootNavigatorKey] (поверх shell, без плавающего таб-бара).
/// Профиль — branch 3 (`/profile`), таб в нижней навигации активен, см.
/// [AppBottomNav].
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
                // Экран 03 «Сегодня» (полный список задач). Push поверх shell
                // (своя кнопка «назад», без таб-бара) — как карточка растения.
                // Позже может переехать под таб «График» (StatefulShellBranch).
                GoRoute(
                  path: 'today',
                  name: 'today',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const TodayScreen(),
                ),
                // Мастер добавления растения (экран 04) — полноэкранно поверх
                // shell (на root-навигаторе, без нижней навигации), как карточка.
                GoRoute(
                  path: 'add',
                  name: 'addPlant',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AddPlantWizardScreen(),
                ),
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalog',
              name: 'catalog',
              builder: (context, state) => const CatalogScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'speciesDetail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    // `id` валидируется парсингом: некорректный путь → 0
                    // (деталь покажет ошибку через провайдер). Навигация
                    // строится из `species.id` (int), так что в норме надёжно.
                    final id =
                        int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                    return SpeciesDetailScreen(id: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                // Управление комнатами (CRUD локаций) — push поверх shell (своя
                // кнопка «назад», без таб-бара), как карточка/today.
                GoRoute(
                  path: 'rooms',
                  name: 'rooms',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const RoomsScreen(),
                ),
                // Экран 17 «Архив» (memorial) — полноэкранно поверх shell (своя
                // кнопка «назад», без таб-бара), как rooms/карточка.
                GoRoute(
                  path: 'archive',
                  name: 'archive',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const ArchiveScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
