import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/network/connectivity_provider.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/sdui/data/sdui_repository_provider.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_block.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_repository.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_screen_layout.dart';
import 'package:plantcare_mobile/features/care_event/data/care_event_repository_provider.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_repository.dart';
import 'package:plantcare_mobile/features/care_event/domain/logged_care_event.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/home/presentation/home_screen.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockCareEventRepo extends Mock implements CareEventRepository {}

class _MockSduiRepo extends Mock implements SduiRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

const _plantId = 42;
final _fixedNow = DateTime.utc(2026, 5, 27, 9);

/// Интеграция экрана 01 (Home, теперь Server-Driven, MADR-015) → sheet 06:
/// тап по задаче в SDUI-блоке `today_tasks` открывает sheet ухода с
/// `presetType`, выведенным из `task.type` через маппер-ловушку.
///
/// Это ВОССТАНОВЛЕННЫЙ интерактив: пилот переключил home на SDUI и временно
/// потерял список задач (блок `today_summary` несёт только счётчики). Backend
/// теперь шлёт `today_tasks` со списком — мобайл рендерит его тапабельным
/// `TodayCard`. Замоканный seam — SDUI-репозиторий ([SduiRepository]), а не
/// старые `homeTasksProvider`/`homePlantsProvider`/`homeLocationsProvider`.
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

    // SDUI-лейаут home несёт ровно один блок today_tasks с задачей 'Фикус'.
    final layout = SduiScreenLayout(
      screenId: 'home',
      version: 1,
      blocks: [
        SduiBlock.todayTasks(
          completedCount: 0,
          totalCount: 1,
          tasks: [task],
        ),
      ],
    );

    final sduiRepo = _MockSduiRepo();
    when(() => sduiRepo.getHomeLayout())
        .thenAnswer((_) async => Result.success(layout));

    final repo = _MockCareEventRepo();
    // submit() зовёт детекцию «первого ухода» ДО POST — стабим, иначе мок кинет
    // на незастабленном вызове. Этот флоу-тест про проводку presetType, не про
    // экран 33: отдаём «уже есть события» (path снэкбара).
    when(() => repo.priorCareEventCount(any()))
        .thenAnswer((_) async => const Result.success(3));
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
          connectivityProvider.overrideWith((_) => Stream.value(true)),
          careEventRepositoryProvider.overrideWithValue(repo),
          sduiRepositoryProvider.overrideWithValue(sduiRepo),
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
    // Тип FERTILIZE → кнопка показывает «Подкормлено» (type-specific label).
    await tester.tap(find.text(l10n.careSheetFertilizeSubmit));
    await tester.pumpAndSettle();

    final draft =
        verify(() => repo.logCareEvent(captureAny())).captured.single
            as CareEventDraft;
    expect(draft.plantId, _plantId);
    expect(draft.type, CareEventKind.fertilize);
  });
}
