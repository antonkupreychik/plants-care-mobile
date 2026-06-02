import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/add_plant/presentation/add_plant_wizard_screen.dart';
import '../../features/archive/presentation/archive_screen.dart';
import '../../features/report/presentation/monthly_report_screen.dart';
import '../../features/auth/presentation/auth_code_screen.dart';
import '../../features/auth/presentation/auth_email_screen.dart';
import '../../features/auth/presentation/auth_verify_screen.dart';
import '../../features/auth/presentation/auth_welcome_back_screen.dart';
import '../../features/auth/presentation/auth_welcome_screen.dart';
import '../../features/care_event/presentation/first_care_success_screen.dart';
import '../../features/care_history/presentation/care_history_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/catalog/presentation/species_detail_screen.dart';
import '../../features/edit_schedule/presentation/edit_schedule_screen.dart';
import '../../features/plant_card/domain/care_event_kind.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/today_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/plant_card/presentation/plant_card_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/quiet_hours/presentation/quiet_hours_screen.dart';
import '../../features/quiet_hours/presentation/timezone_screen.dart';
import '../../features/rooms/presentation/rooms_screen.dart';
import '../../features/schedule/presentation/schedule_screen.dart';
import '../auth/auth_providers.dart';
import 'app_shell.dart';

part 'app_router.g.dart';

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
///
/// Группа `/auth/*` — полноэкранные экраны входа ВНЕ табов, на
/// [_rootNavigatorKey] (рядом с shell, top-level). Это РЕАЛЬНЫЙ auth-флоу с
/// router-guard (MADR-008): email magic-link (`/auth/email` → `/auth/verify`)
/// + legacy-превью (07/08/09). [redirect] гейтит всё приложение по
/// [AuthStatusNotifier] (`authStatusProvider`): неавторизованного уводит на
/// `/auth/welcome`, авторизованного из `/auth/*` — на `/home`. Реактивность —
/// через [GoRouter.refreshListenable] на тот же notifier (роутер сам по себе
/// keepAlive и не пересобирается).
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authStatus = ref.watch(authStatusProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: authStatus,
    redirect: (context, state) {
      final authed = ref.read(authStatusProvider).isAuthenticated;
      final atAuth = state.matchedLocation.startsWith('/auth');
      if (!authed) return atAuth ? null : '/auth/welcome';
      if (atAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth/welcome',
        name: 'authWelcome',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AuthWelcomeScreen(),
      ),
      GoRoute(
        path: '/auth/email',
        name: 'authEmail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AuthEmailScreen(),
      ),
      GoRoute(
        path: '/auth/verify',
        name: 'authVerify',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            AuthVerifyScreen(token: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: '/auth/code',
        name: 'authCode',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AuthCodeScreen(),
      ),
      GoRoute(
        path: '/auth/welcome-back',
        name: 'authWelcomeBack',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AuthWelcomeBackScreen(),
      ),
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
                // Экран 24 «Лента уведомлений». Полноэкранно поверх shell (своя
                // кнопка «назад», без таб-бара), как «Сегодня»/история ухода.
                // Вход: колокольчик 🔔 в шапке главной (01).
                GoRoute(
                  path: 'notifications',
                  name: 'notifications',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const NotificationsScreen(),
                ),
                // Мастер добавления растения (экран 04) — полноэкранно поверх
                // shell (на root-навигаторе, без нижней навигации), как карточка.
                GoRoute(
                  path: 'add',
                  name: 'addPlant',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    // Опциональный предвыбранный вид: `/home/add?speciesId=123`
                    // (CTA с карточки вида, экран 20). Невалидный/отсутствующий
                    // → null, мастер стартует с шага 1 «Выбор вида».
                    final speciesId = int.tryParse(
                      state.uri.queryParameters['speciesId'] ?? '',
                    );
                    return AddPlantWizardScreen(initialSpeciesId: speciesId);
                  },
                ),
                // Экран 33 «Успех первого ухода» — полноэкранное празднование
                // поверх shell (на root-навигаторе, без таб-бара), как карточка
                // растения. Push'ится из sheet ухода после ПЕРВОГО события.
                // `kind`/`onTime` несёт сам путь (запрос-параметры), асинхронно
                // экран дочитывает имя/вид через `plantDetailProvider(plantId)`.
                GoRoute(
                  path: 'care-success/:plantId',
                  name: 'careSuccess',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final plantId = int.tryParse(
                          state.pathParameters['plantId'] ?? '',
                        ) ??
                        0;
                    // Неизвестный/отсутствующий kind → нейтральный fallback
                    // (экран рисует без падения). `onTime` по умолчанию true.
                    final kind = _careKindFromName(
                      state.uri.queryParameters['kind'],
                    );
                    final onTime =
                        state.uri.queryParameters['onTime'] != 'false';
                    return FirstCareSuccessScreen(
                      plantId: plantId,
                      careKind: kind,
                      onTime: onTime,
                    );
                  },
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
                  routes: [
                    // Экран 21 «Полная история ухода». Полноэкранно поверх
                    // shell (своя кнопка «назад», без таб-бара), как карточка.
                    // Вход: карточка 02 → «Дневник · Всё».
                    GoRoute(
                      path: 'history',
                      name: 'plantHistory',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id =
                            int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                        return CareHistoryScreen(plantId: id);
                      },
                    ),
                    // Экран 22 «Редактирование расписания ухода».
                    // Полноэкранно поверх shell (своя шапка с «назад»/«Готово»,
                    // без таб-бара), как история/карточка. Вход: карточка 02 →
                    // «Расписание · Изменить». Опциональное `name` растения
                    // (для overline) пробрасываем через extra.
                    GoRoute(
                      path: 'schedule',
                      name: 'editSchedule',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id =
                            int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                        final name = state.extra is String
                            ? state.extra as String
                            : null;
                        return EditScheduleScreen(plantId: id, plantName: name);
                      },
                    ),
                  ],
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
                // Экран 14 «Месячный отчёт» — полноэкранно поверх shell (своя
                // кнопка «назад», без таб-бара), как archive/rooms.
                GoRoute(
                  path: 'report',
                  name: 'monthlyReport',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const MonthlyReportScreen(),
                ),
                // Экран 23 «Тихие часы» — полноэкранно поверх shell (своя
                // кнопка «назад», без таб-бара), как report/archive. Пикер
                // времени (экран 36) внутри открывается showModalBottomSheet
                // (не маршрут).
                GoRoute(
                  path: 'quiet-hours',
                  name: 'quietHours',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const QuietHoursScreen(),
                ),
                // Экран 37 «Выбор таймзоны» — полноэкранно поверх shell, push
                // из экрана 23 (строка «Таймзона»).
                GoRoute(
                  path: 'timezone',
                  name: 'timezone',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const TimezoneScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    ],
  );
}

/// Парсит query-параметр `kind` экрана 33 в [CareEventKind]. Неизвестное/пустое
/// значение → [CareEventKind.water] (нейтральный fallback — экран не падает).
/// Значения совпадают с `CareEventKind.name` (water/spray/fertilize), которые
/// строит sheet при push.
CareEventKind _careKindFromName(String? name) => switch (name) {
      'water' => CareEventKind.water,
      'spray' => CareEventKind.spray,
      'fertilize' => CareEventKind.fertilize,
      _ => CareEventKind.water,
    };
