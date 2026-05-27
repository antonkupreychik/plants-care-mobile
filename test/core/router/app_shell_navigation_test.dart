import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/app.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/env/app_config.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/router/app_router.dart';
import 'package:plantcare_mobile/core/widgets/app_bottom_nav.dart';
import 'package:plantcare_mobile/features/add_plant/domain/species_summary.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_screen.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/species_providers.dart';
import 'package:plantcare_mobile/features/home/domain/garden_location.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/home_screen.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_screen.dart';
import 'package:plantcare_mobile/features/schedule/data/schedule_repository_provider.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_day.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_repository.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_week.dart';
import 'package:plantcare_mobile/features/schedule/presentation/schedule_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

class _MockScheduleRepo extends Mock implements ScheduleRepository {}

const _config = AppConfig(
  flavor: Flavor.dev,
  apiUrl: 'https://example.test',
  chatId: '9000001',
  userId: '1',
);

/// «Сегодня» зафиксировано (детерминизм заголовков «сегодня» в обоих экранах).
final _utcNow = DateTime.utc(2026, 5, 27, 9);

const _plantId = 7;

/// Пустая неделя — ScheduleScreen рисует контент без сети.
ScheduleWeek _emptyWeek(DateTime monday) => ScheduleWeek(
      weekStart: monday,
      days: List.generate(
        7,
        (i) => ScheduleDay(
          date: DateTime(monday.year, monday.month, monday.day + i),
          tasks: const [],
        ),
      ),
    );

/// Поднимает реальный [appRouter] + [AppShell] под [PlantCareApp] с замоканными
/// провайдерами всех экранов (home/schedule/plant_card) — без сети.
/// [scheduleRepo] прокидывается, чтобы можно было его проверить/настроить.
Widget _wrap({ScheduleRepository? scheduleRepo}) {
  return ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(_config),
      clockProvider.overrideWithValue(_FixedClock(_utcNow)),
      // Home: три секции пустые → детерминированный empty-сад без сети.
      homeTasksProvider.overrideWith((ref) async => const <CareTask>[]),
      homePlantsProvider.overrideWith((ref) async => const <Plant>[]),
      homeLocationsProvider
          .overrideWith((ref) async => const <GardenLocation>[]),
      // Schedule: репозиторий-мок (настраивается в тесте/по умолчанию пуст).
      scheduleRepositoryProvider
          .overrideWithValue(scheduleRepo ?? _MockScheduleRepo()),
      // Add-plant: шаг 1 (поиск видов) без сети.
      speciesSearchProvider('')
          .overrideWith((ref) async => const <SpeciesSummary>[]),
      // Plant card: три family-секции отдают валидные данные без сети.
      plantDetailProvider(_plantId).overrideWith(
        (ref) async => const Plant(id: _plantId, name: 'Монстера'),
      ),
      plantStreakProvider(_plantId).overrideWith(
        (ref) async => const Streak(plantId: _plantId, count: 0),
      ),
      plantHistoryProvider(_plantId).overrideWith(
        (ref) async => const <CareHistoryEntry>[],
      ),
    ],
    child: const PlantCareApp(),
  );
}

void main() {
  setUpAll(() async {
    registerFallbackValue(DateTime(2026, 5, 18));
    await initializeDateFormatting('ru');
  });

  // appRouter — глобальный singleton: состояние навигации переживает тесты.
  // Сбрасываем на стартовый branch перед каждым тестом, чтобы изоляция держалась.
  setUp(() {
    appRouter.go('/home');
  });

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(AppBottomNav)));

  group('AppShell navigation', () {
    testWidgets('should_start_on_garden_with_bottom_nav_when_app_launches',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // Стартовый branch — «Сад».
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(ScheduleScreen), findsNothing);
      // Плавающая нижняя навигация — на экране.
      expect(find.byType(AppBottomNav), findsOneWidget);
    });

    testWidgets('should_show_schedule_screen_when_schedule_tab_tapped',
        (tester) async {
      final repo = _MockScheduleRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
        (i) async => Result.success(
          _emptyWeek(i.namedArguments[#weekStart] as DateTime),
        ),
      );

      await tester.pumpWidget(_wrap(scheduleRepo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10nOf(tester).navSchedule));
      await tester.pumpAndSettle();

      // Активный branch переключился на «График».
      expect(find.byType(ScheduleScreen), findsOneWidget);
      // indexedStack: HomeScreen остаётся в дереве, но ScheduleScreen — поверх
      // и активен; маркер активности — отрисованный контент графика (хедер
      // недели через repo). Контракт смены branch фиксируем наличием экрана.
      // Таб-бар по-прежнему виден.
      expect(find.byType(AppBottomNav), findsOneWidget);
      // Репозиторий недели реально дёрнут (экран построился, не заглушка).
      verify(() => repo.getWeek(weekStart: any(named: 'weekStart')))
          .called(greaterThanOrEqualTo(1));
    });

    testWidgets('should_return_to_garden_when_garden_tab_tapped_after_schedule',
        (tester) async {
      final repo = _MockScheduleRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
        (i) async => Result.success(
          _emptyWeek(i.namedArguments[#weekStart] as DateTime),
        ),
      );

      await tester.pumpWidget(_wrap(scheduleRepo: repo));
      await tester.pumpAndSettle();

      // Сад → График → Сад.
      await tester.tap(find.text(l10nOf(tester).navSchedule));
      await tester.pumpAndSettle();
      expect(find.byType(ScheduleScreen), findsOneWidget);

      await tester.tap(find.text(l10nOf(tester).navGarden));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(ScheduleScreen), findsNothing);
    });

    testWidgets(
        'should_show_coming_soon_and_keep_garden_when_catalog_tab_tapped',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await tester.tap(find.text(l10n.navCatalog));
      await tester.pump(); // прокрутить кадр для snackbar

      // Инертный таб: показывает coming-soon, branch не сменился.
      expect(find.text(l10n.comingSoon), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(ScheduleScreen), findsNothing);
    });

    testWidgets('should_hide_bottom_nav_when_plant_card_pushed_over_shell',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // Старт: таб-бар виден над shell.
      expect(find.byType(AppBottomNav), findsOneWidget);

      // Переход на карточку растения (push на root-навигаторе поверх shell).
      appRouter.go('/home/plants/$_plantId');
      await tester.pumpAndSettle();

      // Карточка отрисована, таб-бар скрыт (detail-экран на root-навигаторе).
      expect(find.byType(PlantCardScreen), findsOneWidget);
      expect(find.byType(AppBottomNav), findsNothing);
    });

    testWidgets('should_open_add_plant_wizard_over_shell_without_bottom_nav',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.byType(AppBottomNav), findsOneWidget);

      // Роут /home/add — мастер на root-навигаторе поверх shell.
      appRouter.go('/home/add');
      await tester.pumpAndSettle();

      expect(find.byType(AddPlantWizardScreen), findsOneWidget);
      // Таб-бар скрыт (мастер полноэкранно поверх shell).
      expect(find.byType(AppBottomNav), findsNothing);
    });
  });
}
