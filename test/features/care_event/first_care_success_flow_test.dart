import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/router/app_router.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/care_event/data/care_event_repository_provider.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_repository.dart';
import 'package:plantcare_mobile/features/care_event/domain/logged_care_event.dart';
import 'package:plantcare_mobile/features/care_event/presentation/first_care_success_screen.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_screen.dart';
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

LoggedCareEvent _logged({
  CareEventKind type = CareEventKind.water,
  bool onTime = true,
  DateTime? performedAtUtc,
}) =>
    LoggedCareEvent(
      id: 7,
      plantId: _plantId,
      plantName: 'Фикус',
      type: type,
      performedAtUtc: performedAtUtc ?? _fixedNow,
      onTime: onTime,
    );

Widget _harness(_MockCareEventRepo repo) {
  return ProviderScope(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
      careEventRepositoryProvider.overrideWithValue(repo),
      plantDetailProvider(_plantId).overrideWith(
        (ref) async => const Plant(id: _plantId, name: 'Фикус'),
      ),
      plantStreakProvider(_plantId).overrideWith(
        (ref) async => const Streak(plantId: _plantId, count: 0),
      ),
      plantHistoryProvider(_plantId).overrideWith(
        (ref) async => const <CareHistoryEntry>[],
      ),
    ],
    child: MaterialApp.router(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    ),
  );
}

Future<void> _openSheetAndSubmit(WidgetTester tester) async {
  // Высокий вьюпорт, чтобы кнопки гарантированно были в кадре.
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  appRouter.go('/home/plants/$_plantId');
  await tester.pumpAndSettle();

  final l10n =
      AppLocalizations.of(tester.element(find.byType(PlantCardScreen)));

  await tester.tap(find.text(l10n.plantCardLogCare));
  await tester.pumpAndSettle();

  await tester.tap(find.text(l10n.careSheetSubmit));
  await tester.pumpAndSettle();
}

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

  late _MockCareEventRepo repo;

  setUp(() {
    repo = _MockCareEventRepo();
    appRouter.go('/home'); // сброс на старт между тестами
  });

  testWidgets(
      'should_navigate_to_care_success_with_kind_and_onTime_when_first_care',
      (tester) async {
    // Нет предыдущих событий → первый уход → push экрана 33.
    when(() => repo.priorCareEventCount(_plantId))
        .thenAnswer((_) async => const Result.success(0));
    when(() => repo.logCareEvent(any())).thenAnswer(
      (_) async => Result.success(
        _logged(type: CareEventKind.fertilize, onTime: true),
      ),
    );

    await tester.pumpWidget(_harness(repo));
    await _openSheetAndSubmit(tester);

    // Sheet закрылся, экран 33 на стеке с careKind/onTime из ответа backend.
    final screen = tester.widget<FirstCareSuccessScreen>(
      find.byType(FirstCareSuccessScreen),
    );
    expect(screen.plantId, _plantId);
    expect(screen.careKind, CareEventKind.fertilize);
    expect(screen.onTime, isTrue);
  });

  testWidgets('should_carry_onTime_false_in_route_when_late_first_care',
      (tester) async {
    // onTime приходит из ответа backend и кодируется в query экрана 33.
    when(() => repo.priorCareEventCount(_plantId))
        .thenAnswer((_) async => const Result.success(0));
    when(() => repo.logCareEvent(any())).thenAnswer(
      (_) async => Result.success(_logged(onTime: false)),
    );

    await tester.pumpWidget(_harness(repo));
    await _openSheetAndSubmit(tester);

    final screen = tester.widget<FirstCareSuccessScreen>(
      find.byType(FirstCareSuccessScreen),
    );
    expect(screen.onTime, isFalse);
    // Поздний первый уход стрик не начинает.
    final l10n =
        AppLocalizations.of(tester.element(find.byType(FirstCareSuccessScreen)));
    expect(find.text(l10n.firstCareSuccessStreakDayOne), findsNothing);
  });

  testWidgets('should_show_snackbar_and_not_navigate_when_not_first_care',
      (tester) async {
    // Уже есть события → НЕ первый уход → снэкбар, без экрана 33.
    when(() => repo.priorCareEventCount(_plantId))
        .thenAnswer((_) async => const Result.success(2));
    when(() => repo.logCareEvent(any()))
        .thenAnswer((_) async => Result.success(_logged()));

    await tester.pumpWidget(_harness(repo));
    await _openSheetAndSubmit(tester);

    expect(find.byType(FirstCareSuccessScreen), findsNothing);
    final l10n =
        AppLocalizations.of(tester.element(find.byType(PlantCardScreen)));
    expect(find.text(l10n.careSheetSubmitted), findsOneWidget);
  });

  testWidgets('should_cta_return_to_home_from_care_success', (tester) async {
    when(() => repo.priorCareEventCount(_plantId))
        .thenAnswer((_) async => const Result.success(0));
    when(() => repo.logCareEvent(any()))
        .thenAnswer((_) async => Result.success(_logged()));

    await tester.pumpWidget(_harness(repo));
    await _openSheetAndSubmit(tester);

    expect(find.byType(FirstCareSuccessScreen), findsOneWidget);

    final l10n =
        AppLocalizations.of(tester.element(find.byType(FirstCareSuccessScreen)));
    await tester.tap(find.text(l10n.firstCareSuccessCta));
    await tester.pumpAndSettle();

    // CTA «Вернуться в сад» → context.go('/home'): экран 33 ушёл со стека.
    expect(find.byType(FirstCareSuccessScreen), findsNothing);
    expect(
      appRouter.routerDelegate.currentConfiguration.uri.path,
      '/home',
    );
  });

  group('timezone', () {
    testWidgets(
        'should_keep_submit_path_tz_safe_when_non_utc_performedAt_logged',
        (tester) async {
      // Экран 33 не показывает время (footer — generic hint, без даты), поэтому
      // отдельной TZ-логики на экране нет. Здесь фиксируем, что сам submit-путь
      // первого ухода tz-безопасен: performedAt уходит в backend как UTC, а
      // экран 33 строится на kind/onTime, не на локальном времени. Регрессия —
      // если бы целебрейшен начал зависеть от raw-UTC vs local.
      when(() => repo.priorCareEventCount(_plantId))
          .thenAnswer((_) async => const Result.success(0));
      when(() => repo.logCareEvent(any())).thenAnswer(
        (_) async => Result.success(
          // backend «вернул» момент в UTC (23:00) — в не-UTC окружении локальный
          // час ≠ 23, но экран 33 это не отображает и не должен ломаться.
          _logged(performedAtUtc: DateTime.utc(2026, 5, 26, 23, 0)),
        ),
      );

      await tester.pumpWidget(_harness(repo));
      await _openSheetAndSubmit(tester);

      // Дошли до экрана 33 без падения; draft ушёл в UTC.
      expect(find.byType(FirstCareSuccessScreen), findsOneWidget);
      final draft = verify(() => repo.logCareEvent(captureAny()))
          .captured
          .single as CareEventDraft;
      expect(draft.performedAtUtc.isUtc, isTrue);
    });
  });
}
