import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/home/domain/garden_location.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/home_screen.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/garden_empty.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/location_chips.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/plant_card.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

/// Никогда не завершающийся Future → провайдер остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

final _utcNow = DateTime.utc(2026, 5, 27, 9);

typedef _Tasks = Future<List<CareTask>> Function();
typedef _Plants = Future<List<Plant>> Function();
typedef _Locations = Future<List<GardenLocation>> Function();

Widget _wrap({
  _Tasks? tasks,
  _Plants? plants,
  _Locations? locations,
}) {
  return ProviderScope(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_utcNow)),
      homeTasksProvider.overrideWith(
        (ref) => (tasks ?? () async => const <CareTask>[])(),
      ),
      homePlantsProvider.overrideWith(
        (ref) => (plants ?? () async => const <Plant>[])(),
      ),
      homeLocationsProvider.overrideWith(
        (ref) => (locations ?? () async => const <GardenLocation>[])(),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const HomeScreen(),
    ),
  );
}

void main() {
  group('HomeScreen loading', () {
    testWidgets('should_show_skeletons_when_all_providers_loading',
        (tester) async {
      await tester.pumpWidget(_wrap(
        tasks: _pending<List<CareTask>>,
        plants: _pending<List<Plant>>,
        locations: _pending<List<GardenLocation>>,
      ));
      await tester.pump();

      expect(find.byType(TodayCardSkeleton), findsOneWidget);
      expect(find.byType(PlantCardSkeleton), findsWidgets);
      expect(find.byType(LocationChipsSkeleton), findsOneWidget);
    });
  });

  group('HomeScreen error', () {
    testWidgets('should_show_error_with_retry_when_tasks_and_plants_fail',
        (tester) async {
      await tester.pumpWidget(_wrap(
        tasks: () async => throw const ApiError.notFound(),
        plants: () async => throw const ApiError.network(),
      ));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.byType(ErrorState), findsNWidgets(2));
      expect(find.text(l10n.retry), findsNWidgets(2));
    });
  });

  group('HomeScreen empty', () {
    testWidgets('should_show_GardenEmpty_when_plants_empty', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.byType(GardenEmpty), findsOneWidget);
      expect(find.text(l10n.homeGardenEmptyTitle), findsOneWidget);
    });

    testWidgets('should_show_tasks_empty_hint_when_tasks_empty',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.text(l10n.homeTasksEmptyHint), findsOneWidget);
    });
  });

  group('HomeScreen data', () {
    testWidgets('should_render_plant_cards_and_task_when_data_present',
        (tester) async {
      final task = CareTask(
        scheduleId: 1,
        plantId: 1,
        plantName: 'Monstera',
        type: CareTaskType.watering,
        dueAt: _utcNow.add(const Duration(hours: 3)),
      );
      await tester.pumpWidget(_wrap(
        tasks: () async => [task],
        plants: () async => const [
          Plant(id: 1, name: 'Фикус'),
          Plant(id: 2, name: 'Кактус'),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.byType(TodayCard), findsOneWidget);
      expect(find.byType(PlantCard), findsNWidgets(2));
      expect(find.text('Фикус'), findsOneWidget);
      expect(find.text('Кактус'), findsOneWidget);
      // Растения есть → пустого состояния нет.
      expect(find.byType(GardenEmpty), findsNothing);
    });
  });
}
