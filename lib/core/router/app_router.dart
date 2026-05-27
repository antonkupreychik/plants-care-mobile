import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/plant_card/presentation/plant_card_screen.dart';

/// Роутер приложения (MADR-005).
///
/// Каркас: маршрут `/home` (экран 01) + push-маршрут `/plants/:id`
/// (экран 02 «Карточка растения»). На шаге фич сюда придёт
/// `StatefulShellRoute` с табами (Сад / График / Каталог / Профиль),
/// мастер добавления и auth-ветка.
final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'plants/:id',
          name: 'plantCard',
          builder: (context, state) {
            // `id` валидируется парсингом: некорректный путь → 0 (карточка
            // покажет ошибку секций через провайдеры). Навигация всегда
            // строится из `plant.id` (int), так что в норме это надёжно.
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return PlantCardScreen(plantId: id);
          },
        ),
      ],
    ),
  ],
);
