import 'dart:async';
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsNode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/api_error_l10n.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/care_event/data/care_event_repository_provider.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_repository.dart';
import 'package:plantcare_mobile/features/care_event/domain/logged_care_event.dart';
import 'package:plantcare_mobile/features/care_event/presentation/log_care_event_sheet.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements CareEventRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

const _plantId = 42;
final _fixedNow = DateTime.utc(2026, 5, 27, 9);

LoggedCareEvent _logged() => LoggedCareEvent(
      id: 7,
      plantId: _plantId,
      plantName: 'Фикус',
      type: CareEventKind.water,
      performedAtUtc: _fixedNow,
      onTime: true,
    );

bool _selected(SemanticsNode node) =>
    node.flagsCollection.isSelected == Tristate.isTrue;

bool _enabled(SemanticsNode node) =>
    node.flagsCollection.isEnabled == Tristate.isTrue;

/// Монтирует экран с кнопкой, открывающей sheet через публичный
/// [showLogCareEventSheet]. Возвращает локализацию для проверок.
///
/// Для стабильной прокрутки sheet (добавлены секции WATER/FERTILIZE, которые
/// увеличивают высоту содержимого) устанавливаем большой тестовый viewport.
Future<void> _openSheet(
  WidgetTester tester,
  _MockRepo repo, {
  CareEventKind? presetType,
}) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
        careEventRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => showLogCareEventSheet(
                  context,
                  plantId: _plantId,
                  presetType: presetType,
                  plantName: 'Фикус',
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

AppLocalizations _l10n(WidgetTester tester) => AppLocalizations.of(
      tester.element(find.text('open')),
    );

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

  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
    // submit() зовёт детекцию «первого ухода» ДО POST. По умолчанию — «уже есть
    // события» (>0): эти sheet-тесты проверяют общий путь (снэкбар/ошибка), а не
    // празднование. Тест экрана 33 живёт в first_care_success_flow_test.dart.
    when(() => repo.priorCareEventCount(any()))
        .thenAnswer((_) async => const Result.success(3));
  });

  group('idle', () {
    testWidgets('should_show_controls_and_enabled_submit_button',
        (tester) async {
      await _openSheet(tester, repo);
      final l10n = _l10n(tester);

      // Контролы: тип-чипы, поле «когда», submit. Лейблы полей виджет
      // отрисовывает в верхнем регистре (_FieldLabel.toUpperCase()).
      // Дефолтный тип — WATER, кнопка показывает type-specific «Полито».
      expect(find.text(l10n.careSheetTypeLabel.toUpperCase()), findsOneWidget);
      expect(find.text(l10n.careSheetWhenLabel.toUpperCase()), findsOneWidget);
      expect(find.text(l10n.careSheetWaterSubmit), findsOneWidget);

      // Кнопка доступна (canSubmit=true): её Semantics enabled.
      final semantics = tester.getSemantics(
        find.ancestor(
          of: find.text(l10n.careSheetWaterSubmit),
          matching: find.byType(Semantics),
        ).first,
      );
      expect(_enabled(semantics), isTrue);
    });

    testWidgets('should_preselect_type_from_presetType', (tester) async {
      await _openSheet(tester, repo, presetType: CareEventKind.fertilize);
      final l10n = _l10n(tester);

      // Чип «Удобрить» отрисован как selected (Semantics.selected).
      final chip = tester.getSemantics(
        find.ancestor(
          of: find.text(l10n.careKindFertilize),
          matching: find.byType(Semantics),
        ).first,
      );
      expect(_selected(chip), isTrue);
    });
  });

  group('type selection', () {
    testWidgets('should_select_spray_when_chip_tapped', (tester) async {
      await _openSheet(tester, repo, presetType: CareEventKind.water);
      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.careKindSpray));
      await tester.pump();

      final sprayChip = tester.getSemantics(
        find.ancestor(
          of: find.text(l10n.careKindSpray),
          matching: find.byType(Semantics),
        ).first,
      );
      expect(_selected(sprayChip), isTrue);
    });
  });

  group('submitting', () {
    testWidgets('should_show_progress_and_block_button_while_submitting',
        (tester) async {
      // Репо «висит» → state остаётся submitting.
      final completer = Completer<Result<LoggedCareEvent>>();
      when(() => repo.logCareEvent(any())).thenAnswer((_) => completer.future);

      await _openSheet(tester, repo);
      final l10n = _l10n(tester);

      // Дефолтный тип — WATER → кнопка «Полито».
      await tester.tap(find.text(l10n.careSheetWaterSubmit));
      await tester.pump(); // submitting

      // Спиннер в кнопке, лейбла больше нет (заменён индикатором).
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Кнопка заблокирована.
      final semantics = tester.getSemantics(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(Semantics),
        ).first,
      );
      expect(_enabled(semantics), isFalse);

      completer.complete(Result.success(_logged()));
      await tester.pumpAndSettle();
    });
  });

  group('failure', () {
    testWidgets('should_show_inline_error_and_keep_button_for_retry',
        (tester) async {
      when(() => repo.logCareEvent(any()))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      await _openSheet(tester, repo);
      final l10n = _l10n(tester);

      // Дефолтный тип — WATER → кнопка «Полито».
      await tester.tap(find.text(l10n.careSheetWaterSubmit));
      await tester.pumpAndSettle();

      // Inline-ошибка (текст по типу ApiError) + кнопка снова доступна.
      expect(find.text(l10n.messageForError(const ApiError.network())),
          findsOneWidget);
      expect(find.text(l10n.careSheetWaterSubmit), findsOneWidget);
      // Sheet не закрылся.
      expect(find.text(l10n.careSheetTypeLabel.toUpperCase()), findsOneWidget);
    });
  });

  group('success', () {
    testWidgets('should_close_sheet_and_show_snackbar_on_success',
        (tester) async {
      when(() => repo.logCareEvent(any()))
          .thenAnswer((_) async => Result.success(_logged()));

      await _openSheet(tester, repo);
      final l10n = _l10n(tester);

      // Дефолтный тип — WATER → кнопка «Полито».
      await tester.tap(find.text(l10n.careSheetWaterSubmit));
      await tester.pumpAndSettle();

      // Sheet закрыт (контролов нет), snackbar показан.
      expect(find.text(l10n.careSheetTypeLabel.toUpperCase()), findsNothing);
      expect(find.text(l10n.careSheetSubmitted), findsOneWidget);
    });
  });

  group('canSubmit gate', () {
    testWidgets('should_call_repo_once_when_submit_tapped', (tester) async {
      when(() => repo.logCareEvent(any()))
          .thenAnswer((_) async => Result.success(_logged()));

      await _openSheet(tester, repo);
      final l10n = _l10n(tester);

      // Дефолтный тип — WATER → кнопка «Полито».
      await tester.tap(find.text(l10n.careSheetWaterSubmit));
      await tester.pumpAndSettle();

      verify(() => repo.logCareEvent(any())).called(1);
    });
  });

  group('WATER type specifics', () {
    testWidgets('should_show_water_section_and_hide_fertilizer_section_for_water_type',
        (tester) async {
      await _openSheet(tester, repo, presetType: CareEventKind.water);
      final l10n = _l10n(tester);

      // Секция WATER: слайдер объёма присутствует.
      expect(find.text(l10n.careSheetWaterAmountLabel.toUpperCase()),
          findsOneWidget);
      // Изначально объём не задан.
      expect(find.text(l10n.careSheetWaterAmountNotSet), findsOneWidget);
      // Тоггл «Грунт был сухой» присутствует.
      expect(find.text(l10n.careSheetSoilDryLabel), findsOneWidget);

      // Секция FERTILIZE отсутствует.
      expect(find.text(l10n.careSheetFertilizerNameLabel.toUpperCase()),
          findsNothing);
    });

    testWidgets('should_select_quick_chip_and_update_amount_display',
        (tester) async {
      await _openSheet(tester, repo, presetType: CareEventKind.water);
      final l10n = _l10n(tester);

      // Тапаем quick-chip «200 мл».
      await tester.tap(find.text('200 мл'));
      await tester.pump();

      // Отображение обновилось: «Не указан» пропало, показывает «200 мл».
      expect(find.text(l10n.careSheetWaterAmountNotSet), findsNothing);
      expect(find.text(l10n.careSheetWaterAmountValue(200)), findsWidgets);
    });

    testWidgets('should_send_amountMl_in_note_when_water_amount_set',
        (tester) async {
      when(() => repo.logCareEvent(any()))
          .thenAnswer((_) async => Result.success(_logged()));

      await _openSheet(tester, repo, presetType: CareEventKind.water);
      final l10n = _l10n(tester);

      // Выбираем 300 мл через quick-chip.
      await tester.tap(find.text('300 мл'));
      await tester.pump();

      await tester.tap(find.text(l10n.careSheetWaterSubmit));
      await tester.pumpAndSettle();

      // Draft.note содержит объём воды.
      final captured =
          verify(() => repo.logCareEvent(captureAny())).captured.single
              as CareEventDraft;
      // Маппер кодирует amountMl в note.
      expect(captured.amountMl, 300);
    });
  });

  group('FERTILIZE type specifics', () {
    testWidgets(
        'should_show_fertilizer_section_and_hide_water_section_for_fertilize_type',
        (tester) async {
      await _openSheet(tester, repo, presetType: CareEventKind.fertilize);
      final l10n = _l10n(tester);

      // Секция FERTILIZE: поле названия присутствует.
      expect(find.text(l10n.careSheetFertilizerNameLabel.toUpperCase()),
          findsOneWidget);
      // Секция WATER отсутствует.
      expect(find.text(l10n.careSheetWaterAmountLabel.toUpperCase()),
          findsNothing);
      expect(find.text(l10n.careSheetSoilDryLabel), findsNothing);
    });

    testWidgets(
        'should_show_spray_label_on_button_and_no_extra_sections_for_spray_type',
        (tester) async {
      await _openSheet(tester, repo, presetType: CareEventKind.spray);
      final l10n = _l10n(tester);

      // Кнопка «Опрыскано» видна.
      expect(find.text(l10n.careSheetSpraySubmit), findsOneWidget);
      // Ни WATER, ни FERTILIZE секций нет.
      expect(find.text(l10n.careSheetWaterAmountLabel.toUpperCase()),
          findsNothing);
      expect(find.text(l10n.careSheetFertilizerNameLabel.toUpperCase()),
          findsNothing);
    });
  });
}
