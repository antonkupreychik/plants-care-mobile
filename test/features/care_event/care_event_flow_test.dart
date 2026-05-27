import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/care_event/data/care_event_repository_provider.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_repository.dart';
import 'package:plantcare_mobile/features/care_event/domain/logged_care_event.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/home/domain/garden_location.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/home_screen.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockCareEventRepo extends Mock implements CareEventRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

const _plantId = 42;
final _fixedNow = DateTime.utc(2026, 5, 27, 9);

/// Интеграция экрана 01 (Home) → sheet 06: тап по задаче `/today` открывает
/// sheet ухода с `presetType`, выведенным из `task.type` через маппер-ловушку.
void main() {
  setUpAll(() {
    registerFallbackValue(
      CareEventDraft(
        plantId: 0,
        type: CareEventKind.water,
        performedAtUtc: DateTime.utc(2026),
      ),
    );
  });

  testWidgets(
      'should_open_sheet_with_presetType_from_task_type_when_task_tapped',
      (tester) async {
    // Высокий вьюпорт, чтобы задача гарантированно была в кадре.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final task = CareTask(
      scheduleId: 1,
      plantId: _plantId,
      plantName: 'Фикус',
      // FERTILIZING → fertilize (маппер-ловушка). Sheet должен предвыбрать
      // именно «Удобрить», а не дефолтный «Полить».
      type: CareTaskType.fertilizing,
      dueAt: _fixedNow,
    );

    final repo = _MockCareEventRepo();
    when(() => repo.logCareEvent(any())).thenAnswer(
      (_) async => Result.success(
        LoggedCareEvent(
          id: 1,
          plantId: _plantId,
          plantName: 'Фикус',
          type: CareEventKind.fertilize,
          performedAtUtc: _fixedNow,
          onTime: true,
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
          careEventRepositoryProvider.overrideWithValue(repo),
          homeTasksProvider.overrideWith((ref) async => [task]),
          homePlantsProvider.overrideWith(
            (ref) async => const <Plant>[Plant(id: _plantId, name: 'Фикус')],
          ),
          homeLocationsProvider.overrideWith(
            (ref) async => const <GardenLocation>[],
          ),
        ],
        child: MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(tester.element(find.byType(HomeScreen)));

    // Тап по задаче в карточке «Сегодня» (имя растения может встречаться и в
    // списке сада — поэтому скоупим поиск внутрь TodayCard).
    await tester.tap(
      find.descendant(
        of: find.byType(TodayCard),
        matching: find.text('Фикус'),
      ),
    );
    await tester.pumpAndSettle();

    // Sheet открыт: видна шапка «Уход за Фикус» и лейбл типа.
    expect(find.text(l10n.careSheetTitleFor('Фикус')), findsOneWidget);
    expect(find.text(l10n.careSheetTypeLabel.toUpperCase()), findsOneWidget);

    // Отправляем как есть (без смены типа) → draft несёт presetType, который
    // sheet получил из task.type через маппер. Захватываем его в репо: это
    // доказывает сквозную проводку plantId + presetType (FERTILIZING →
    // fertilize), а не только факт открытия.
    await tester.tap(find.text(l10n.careSheetSubmit));
    await tester.pumpAndSettle();

    final draft =
        verify(() => repo.logCareEvent(captureAny())).captured.single
            as CareEventDraft;
    expect(draft.plantId, _plantId);
    expect(draft.type, CareEventKind.fertilize);
  });
}
