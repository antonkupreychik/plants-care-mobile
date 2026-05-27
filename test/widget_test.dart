import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcate_mobile/app.dart';
import 'package:plantcate_mobile/core/clock/clock.dart';
import 'package:plantcate_mobile/core/clock/clock_provider.dart';
import 'package:plantcate_mobile/core/env/app_config.dart';
import 'package:plantcate_mobile/features/home/domain/care_task.dart';
import 'package:plantcate_mobile/features/home/domain/garden_location.dart';
import 'package:plantcate_mobile/features/home/domain/plant.dart';
import 'package:plantcate_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcate_mobile/features/home/presentation/home_screen.dart';
import 'package:plantcate_mobile/l10n/app_localizations.dart';

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
      chatId: '9000001',
      userId: '1',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(config),
          clockProvider
              .overrideWithValue(_FixedClock(DateTime.utc(2026, 5, 27, 9))),
          // Пустые данные, чтобы smoke-тест не ходил в сеть
          // (HttpClient в тестах вернул бы 400).
          homeTasksProvider.overrideWith((ref) async => const <CareTask>[]),
          homePlantsProvider.overrideWith((ref) async => const <Plant>[]),
          homeLocationsProvider
              .overrideWith((ref) async => const <GardenLocation>[]),
        ],
        child: const PlantCateApp(),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(tester.element(find.byType(HomeScreen)));
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text(l10n.appTitle), findsOneWidget);
  });
}
