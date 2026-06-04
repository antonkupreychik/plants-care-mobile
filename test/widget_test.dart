import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/app.dart';
import 'package:plantcare_mobile/core/auth/auth_providers.dart';
import 'package:plantcare_mobile/core/auth/auth_status_notifier.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/env/app_config.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/network/connectivity_provider.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/domain/today_tasks_result.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/home_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

void main() {
  // Smoke-тест каркаса: приложение поднимается и стартует на экране «Мой сад».
  // (Раньше проверял заглушку «Сборка работает» — экран заменён HomeScreen.)
  testWidgets('Приложение стартует на экране «Мой сад» (HomeScreen)',
      (tester) async {
    const config = AppConfig(
      flavor: Flavor.dev,
      apiUrl: 'https://example.test',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Снимаем auth-гард: без override redirect увёл бы старт на
          // /auth/welcome (и jwtAuthSessionProvider бросил бы из bootstrap).
          authStatusProvider.overrideWithValue(AuthStatusNotifier(true)),
          appConfigProvider.overrideWithValue(config),
          clockProvider
              .overrideWithValue(_FixedClock(DateTime.utc(2026, 5, 27, 9))),
          // Connectivity: stub онлайн, чтобы не было реальных DNS-запросов
          // и не оставались pending timers после теста.
          connectivityProvider.overrideWith((_) => Stream.value(true)),
          // Пустые данные, чтобы smoke-тест не ходил в сеть
          // (HttpClient в тестах вернул бы 400).
          homeTasksProvider.overrideWith(
            (ref) async => TodayTasksResult(tasks: const [], completedCount: 0, totalCount: 0),
          ),
          homePlantsProvider.overrideWith((ref) async => const <Plant>[]),
          homeLocationsProvider
              .overrideWith((ref) async => const <GardenLocation>[]),
        ],
        child: const PlantCareApp(),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(tester.element(find.byType(HomeScreen)));
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text(l10n.appTitle), findsOneWidget);
  });
}
