import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/offline_state.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/home_loading_skeleton.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
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
    // Сад уже загружен (content) → вторичные секции (задачи/локации) рисуют
    // СВОИ скелетоны посекционно. Полноэкранный скелетон сюда не вмешивается:
    // он только для coldLoading самого сада (см. homeViewStateProvider).
    testWidgets('should_show_section_skeletons_when_secondary_providers_loading',
        (tester) async {
      await tester.pumpWidget(_wrap(
        tasks: _pending<List<CareTask>>,
        plants: () async => const [Plant(id: 1, name: 'Фикус')],
        locations: _pending<List<GardenLocation>>,
      ));
      await tester.pump();

      expect(find.byType(HomeLoadingSkeleton), findsNothing);
      expect(find.byType(TodayCardSkeleton), findsOneWidget);
      expect(find.byType(LocationChipsSkeleton), findsOneWidget);
    });
  });

  group('HomeScreen error', () {
    // Сад загружен (content); падает секция задач → её посекционный ErrorState.
    // Сетевая ошибка САДА без кэша даёт полноэкранный офлайн (см. отдельный
    // тест в 'top-level states'), поэтому здесь сад намеренно резолвится.
    testWidgets('should_show_section_error_with_retry_when_tasks_fail',
        (tester) async {
      await tester.pumpWidget(_wrap(
        tasks: () async => throw const ApiError.notFound(),
        plants: () async => const [Plant(id: 1, name: 'Фикус')],
      ));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.byType(OfflineState), findsNothing);
      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
    });
  });

  group('HomeScreen empty', () {
    testWidgets('should_show_GardenEmpty_when_plants_empty', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.byType(GardenEmpty), findsOneWidget);
      expect(find.text(l10n.homeGardenEmptyHeading), findsOneWidget);
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

  // Top-level состояния поверх посекционной логики (экраны 28/29).
  // Ключуются ТОЛЬКО на homePlantsProvider (сад) — см. homeViewStateProvider.
  group('HomeScreen top-level states', () {
    testWidgets('should_show_loading_skeleton_when_plants_cold_loading',
        (tester) async {
      // Сад грузится без данных → полноэкранный скелетон (28).
      await tester.pumpWidget(_wrap(plants: _pending<List<Plant>>));
      await tester.pump();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.byType(HomeLoadingSkeleton), findsOneWidget);
      expect(find.text(l10n.homeLoadingCaption), findsOneWidget);
      // Это не контент и не офлайн.
      expect(find.byType(OfflineState), findsNothing);
      expect(find.byType(TodayCard), findsNothing);
    });

    testWidgets('should_show_offline_state_when_plants_network_error',
        (tester) async {
      // Сетевая ошибка сада без кэша → полноэкранный офлайн (29).
      await tester.pumpWidget(_wrap(
        plants: () async => throw const ApiError.network(),
      ));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.byType(OfflineState), findsOneWidget);
      expect(find.text(l10n.offlineMessage), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
      // Ни скелетона, ни посекционного контента/ErrorState.
      expect(find.byType(HomeLoadingSkeleton), findsNothing);
      expect(find.byType(TodayCard), findsNothing);
      expect(find.byType(ErrorState), findsNothing);
    });

    testWidgets('should_show_content_when_plants_data_present',
        (tester) async {
      // Есть данные сада → контент (посекционная раскладка), не скелетон/офлайн.
      await tester.pumpWidget(_wrap(
        plants: () async => const [Plant(id: 1, name: 'Фикус')],
      ));
      await tester.pumpAndSettle();

      // Контент: посекционная раскладка с карточкой растения.
      expect(find.byType(PlantCard), findsOneWidget);
      expect(find.text('Фикус'), findsOneWidget);
      expect(find.byType(HomeLoadingSkeleton), findsNothing);
      expect(find.byType(OfflineState), findsNothing);
    });

    testWidgets('should_show_content_when_plants_non_network_error',
        (tester) async {
      // Не-сетевая ошибка сада без кэша → content (посекционный ErrorState),
      // НЕ полноэкранный офлайн.
      await tester.pumpWidget(_wrap(
        plants: () async => throw const ApiError.unknown(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(OfflineState), findsNothing);
      expect(find.byType(HomeLoadingSkeleton), findsNothing);
      expect(find.byType(ErrorState), findsWidgets);
    });
  });
}
