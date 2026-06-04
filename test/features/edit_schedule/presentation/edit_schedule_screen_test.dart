import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/care/care_task_l10n.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/edit_schedule/data/edit_schedule_repository_provider.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/care_schedule_unit.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/edit_schedule_repository.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/plant_care_schedule.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/edit_schedule_controller.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/edit_schedule_screen.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/edit_schedule_state.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/recommended_intervals_provider.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/widgets/reset_intervals_card.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/widgets/schedule_type_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements EditScheduleRepository {}

class _FakeSchedule extends Fake implements PlantCareSchedule {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

/// Контроллер с фиксированным состоянием — для детерминированных state-кейсов
/// (loading / saving / saveError), где сеть не нужна.
class _StubController extends EditScheduleController {
  _StubController(this._state);
  final EditScheduleState _state;
  @override
  Future<EditScheduleState> build(int plantId) async => _state;
}

const _plantId = 1;
final _fixedNow = DateTime.utc(2026, 6, 1, 9);

PlantCareSchedule _schedule(
  CareTaskType type,
  String rawType, {
  int every = 7,
  bool enabled = true,
  int? amountMl,
  DateTime? nextDueAt,
}) =>
    PlantCareSchedule(
      type: type,
      rawType: rawType,
      every: every,
      unit: CareScheduleUnit.day,
      rawUnit: 'DAY',
      amountMl: amountMl,
      enabled: enabled,
      nextDueAt: nextDueAt,
    );

List<PlantCareSchedule> _fourSchedules() => [
      _schedule(CareTaskType.watering, 'WATERING', every: 7, amountMl: 200),
      _schedule(CareTaskType.misting, 'MISTING', every: 3),
      _schedule(CareTaskType.fertilizing, 'FERTILIZING', every: 30),
      _schedule(CareTaskType.soilCheck, 'SOIL_CHECK', every: 14),
    ];

Future<T> _pending<T>() => Completer<T>().future;

/// Обёртка экрана с реальным контроллером поверх мок-репо.
Widget _wrap(
  EditScheduleRepository repo, {
  Map<CareTaskType, int>? recommended,
}) {
  return ProviderScope(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
      editScheduleRepositoryProvider.overrideWithValue(repo),
      recommendedIntervalsProvider(_plantId)
          .overrideWith((ref) async => recommended),
    ],
    child: const _App(),
  );
}

/// Обёртка экрана со стаб-контроллером (фиксированное состояние).
Widget _wrapStub(
  EditScheduleState state, {
  Map<CareTaskType, int>? recommended,
}) {
  return ProviderScope(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
      recommendedIntervalsProvider(_plantId)
          .overrideWith((ref) async => recommended),
      editScheduleControllerProvider(_plantId)
          .overrideWith(() => _StubController(state)),
    ],
    child: const _App(),
  );
}

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) => MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const EditScheduleScreen(plantId: _plantId),
      );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(EditScheduleScreen)));

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeSchedule());
  });

  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  group('loading', () {
    testWidgets('should_show_skeleton_while_pending', (tester) async {
      when(() => repo.getSchedules(any()))
          .thenAnswer((_) => _pending<Result<List<PlantCareSchedule>>>());

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      // Скелетон присутствует, карточек данных ещё нет.
      expect(find.byType(SkeletonBox), findsWidgets);
      expect(find.byType(ScheduleTypeCard), findsNothing);
      expect(find.byType(ErrorState), findsNothing);
    });
  });

  group('error', () {
    testWidgets('should_show_ErrorState_with_retry_and_reload_on_tap',
        (tester) async {
      var calls = 0;
      when(() => repo.getSchedules(any())).thenAnswer((_) async {
        calls++;
        return const Result.failure(ApiError.network());
      });

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
      final before = calls;

      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(calls, greaterThan(before));
    });
  });

  group('empty', () {
    testWidgets('should_show_empty_body_when_draft_empty', (tester) async {
      when(() => repo.getSchedules(any()))
          .thenAnswer((_) async => const Result.success(<PlantCareSchedule>[]));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.editScheduleEmptyTitle), findsOneWidget);
      expect(find.byType(ScheduleTypeCard), findsNothing);
    });
  });

  group('data', () {
    testWidgets('should_render_four_cards_with_type_labels', (tester) async {
      // Высокая поверхность, чтобы ленивый ListView построил все 4 карточки.
      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(() => repo.getSchedules(any()))
          .thenAnswer((_) async => Result.success(_fourSchedules()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(ScheduleTypeCard), findsNWidgets(4));
      expect(find.byType(Switch), findsNWidgets(4));
      // Подписи всех четырёх типов на экране.
      expect(find.text(CareTaskType.watering.label(l10n)), findsOneWidget);
      expect(find.text(CareTaskType.misting.label(l10n)), findsOneWidget);
      expect(find.text(CareTaskType.fertilizing.label(l10n)), findsOneWidget);
      expect(find.text(CareTaskType.soilCheck.label(l10n)), findsOneWidget);
    });

    testWidgets('should_show_reset_card_when_recommended_nonempty',
        (tester) async {
      when(() => repo.getSchedules(any()))
          .thenAnswer((_) async => Result.success(_fourSchedules()));

      await tester.pumpWidget(_wrap(repo,
          recommended: const {CareTaskType.watering: 5}));
      await tester.pumpAndSettle();

      // «Сбросить» видна — рекомендации непустые.
      await tester.scrollUntilVisible(
        find.byType(ResetIntervalsCard),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byType(ResetIntervalsCard), findsOneWidget);
    });

    testWidgets('should_hide_reset_card_when_recommended_null', (tester) async {
      when(() => repo.getSchedules(any()))
          .thenAnswer((_) async => Result.success(_fourSchedules()));

      await tester.pumpWidget(_wrap(repo, recommended: null));
      await tester.pumpAndSettle();

      expect(find.byType(ResetIntervalsCard), findsNothing);
    });
  });

  group('interactions', () {
    testWidgets('should_toggle_draft_enabled_when_switch_tapped',
        (tester) async {
      when(() => repo.getSchedules(any()))
          .thenAnswer((_) async => Result.success(_fourSchedules()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // Тапаем тумблер первой карточки (watering, enabled=true → станет false).
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(EditScheduleScreen)),
      );
      final state =
          container.read(editScheduleControllerProvider(_plantId)).value!;
      expect(state.draftOf(CareTaskType.watering)!.enabled, isFalse);
      expect(state.dirtyTypes, contains(CareTaskType.watering));
    });

    testWidgets('should_increment_every_in_draft_when_plus_tapped',
        (tester) async {
      when(() => repo.getSchedules(any()))
          .thenAnswer((_) async => Result.success(_fourSchedules()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // Первый «+» — интервал watering (7 → 8).
      await tester.tap(find.byIcon(Icons.add_rounded).first);
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(EditScheduleScreen)),
      );
      final state =
          container.read(editScheduleControllerProvider(_plantId)).value!;
      expect(state.draftOf(CareTaskType.watering)!.every, 8);
    });
  });

  group('saving / saveError', () {
    testWidgets('should_show_progress_on_done_button_when_saving',
        (tester) async {
      // Стаб: dirty + saving=true → кнопка «Готово» крутит прогресс и заблочена.
      final dirtyState = EditScheduleState(
        loaded: _fourSchedules(),
        draft: [
          _schedule(CareTaskType.watering, 'WATERING', every: 9, amountMl: 200),
          ..._fourSchedules().sublist(1),
        ],
        saving: true,
      );

      await tester.pumpWidget(_wrapStub(dirtyState));
      // build() застаблен Future.value — один pump разрешает loading→data.
      // Без pumpAndSettle: CircularProgressIndicator анимируется бесконечно.
      await tester.pump();

      final l10n = _l10n(tester);
      // Во время сохранения — индикатор вместо текста «Готово».
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(l10n.editScheduleDone), findsNothing);
      // Тумблеры заблокированы во время сохранения.
      final sw = tester.widget<Switch>(find.byType(Switch).first);
      expect(sw.onChanged, isNull);
    });

    testWidgets('should_show_snackbar_and_stay_on_screen_when_save_fails',
        (tester) async {
      when(() => repo.getSchedules(any()))
          .thenAnswer((_) async => Result.success(_fourSchedules()));
      when(() => repo.updateSchedule(any(), any()))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // Делаем экран грязным: меняем интервал watering.
      await tester.tap(find.byIcon(Icons.add_rounded).first);
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Жмём «Готово» → save() падает → снэкбар, экран НЕ закрыт.
      await tester.tap(find.text(l10n.editScheduleDone));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(EditScheduleScreen), findsOneWidget);
      // saveError проставлен в состоянии.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(EditScheduleScreen)),
      );
      expect(
        container
            .read(editScheduleControllerProvider(_plantId))
            .value!
            .saveError,
        const ApiError.network(),
      );
    });
  });
}
