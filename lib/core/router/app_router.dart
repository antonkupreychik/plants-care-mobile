import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';

/// Роутер приложения (MADR-005).
///
/// Каркас: единственный маршрут `/home`. На шаге фич сюда придёт
/// `StatefulShellRoute` с табами (Сад / График / Каталог / Профиль),
/// push-маршруты (`/plant/:id`, мастер) и auth-ветка.
final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
