import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plantcare_mobile/app.dart';
import 'package:plantcare_mobile/core/auth/auth_providers.dart';
import 'package:plantcare_mobile/core/auth/auth_status_notifier.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/env/app_config.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/router/app_router.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_welcome_screen.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/domain/today_tasks_result.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/home_screen.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

const _config = AppConfig(flavor: Flavor.dev, apiUrl: 'https://example.test');
final _utcNow = DateTime.utc(2026, 5, 27, 9);

/// Контейнер с реальным роутером (`appRouterProvider`) и управляемым
/// auth-флагом ([AuthStatusNotifier]). Home-секции пустые (без сети), чтобы
/// защищённый экран строился детерминированно.
ProviderContainer _container(AuthStatusNotifier status) {
  final c = ProviderContainer(
    overrides: [
      authStatusProvider.overrideWithValue(status),
      appConfigProvider.overrideWithValue(_config),
      clockProvider.overrideWithValue(_FixedClock(_utcNow)),
      homeTasksProvider.overrideWith(
        (ref) async => TodayTasksResult(tasks: const [], completedCount: 0, totalCount: 0),
      ),
      homePlantsProvider.overrideWith((ref) async => const <Plant>[]),
      homeLocationsProvider
          .overrideWith((ref) async => const <GardenLocation>[]),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

Future<GoRouter> _mount(WidgetTester tester, ProviderContainer container) async {
  final router = container.read(appRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const PlantCareApp(),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

String _path(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.path;

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  testWidgets('should_redirect_to_auth_welcome_when_unauthenticated_on_start',
      (tester) async {
    final container = _container(AuthStatusNotifier(false));

    final router = await _mount(tester, container);

    // Старт — /home, но гард увёл неавторизованного на welcome.
    expect(_path(router), '/auth/welcome');
    expect(find.byType(AuthWelcomeScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('should_allow_home_when_authenticated_on_start', (tester) async {
    final container = _container(AuthStatusNotifier(true));

    final router = await _mount(tester, container);

    expect(_path(router), '/home');
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('should_redirect_auth_route_to_home_when_authenticated',
      (tester) async {
    final container = _container(AuthStatusNotifier(true));

    final router = await _mount(tester, container);
    // Авторизованный, идущий на экран входа, отбрасывается на /home.
    router.go('/auth/welcome');
    await tester.pumpAndSettle();

    expect(_path(router), '/home');
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(AuthWelcomeScreen), findsNothing);
  });

  testWidgets('should_leave_auth_flow_when_login_flips_status_true',
      (tester) async {
    final status = AuthStatusNotifier(false);
    final container = _container(status);

    final router = await _mount(tester, container);
    // Старт — на welcome (не авторизован).
    expect(_path(router), '/auth/welcome');

    // Имитация логина: флаг поднят → refreshListenable дёргает redirect,
    // уводя с /auth/* на /home.
    status.set(true);
    await tester.pumpAndSettle();

    expect(_path(router), '/home');
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('should_return_to_auth_welcome_when_session_expires_on_protected',
      (tester) async {
    final status = AuthStatusNotifier(true);
    final container = _container(status);

    final router = await _mount(tester, container);
    // На защищённом экране.
    expect(_path(router), '/home');
    expect(find.byType(HomeScreen), findsOneWidget);

    // Имитация session-expired (RefreshInterceptor.onSessionExpired): флаг
    // опущен → гард выкидывает с защищённого экрана на welcome.
    status.set(false);
    await tester.pumpAndSettle();

    expect(_path(router), '/auth/welcome');
    expect(find.byType(AuthWelcomeScreen), findsOneWidget);
  });
}
