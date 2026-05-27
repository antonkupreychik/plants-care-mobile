import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/router/app_router.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/data/plant_card_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/plant_card_repository.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements PlantCardRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

void main() {
  testWidgets(
      'should_build_PlantCardScreen_with_parsed_id_when_navigating_to_route',
      (tester) async {
    // Захватываем plantId, с которым репозиторий зовётся — это и есть результат
    // парсинга `:id` из пути роутером.
    final repo = _MockRepo();
    final capturedIds = <int>[];

    when(() => repo.getPlant(any())).thenAnswer((inv) async {
      capturedIds.add(inv.positionalArguments.first as int);
      return const Result.success(Plant(id: 77, name: 'Фикус'));
    });
    when(() => repo.getStreak(any())).thenAnswer(
        (_) async => const Result.success(Streak(plantId: 77, count: 3)));
    when(() => repo.getHistory(any())).thenAnswer(
        (_) async => const Result.success(<CareHistoryEntry>[]));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
          plantCardRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp.router(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          routerConfig: appRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Старт на /home → переходим на карточку конкретного растения.
    appRouter.go('/home/plants/77');
    await tester.pumpAndSettle();

    final screen =
        tester.widget<PlantCardScreen>(find.byType(PlantCardScreen));
    expect(screen.plantId, 77);
    expect(capturedIds, contains(77));
    expect(find.text('Фикус'), findsOneWidget);
  });
}

final _fixedNow = DateTime.utc(2026, 5, 27, 9);
