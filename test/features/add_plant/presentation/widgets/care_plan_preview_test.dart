import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/add_plant/domain/care_plan_item.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/widgets/care_plan_preview.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/widgets/value_stepper.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

/// Минимальная обёртка для виджета: тема с PcColors + локализация.
Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  const wateringItem = CarePlanItem(type: CareTaskType.watering, everyDays: 7);
  const mistingItem = CarePlanItem(type: CareTaskType.misting, everyDays: 3);

  group('CarePlanPreview', () {
    testWidgets('should_render_ValueStepper_for_each_item', (tester) async {
      await tester.pumpWidget(
        _wrap(
          CarePlanPreview(
            items: const [wateringItem, mistingItem],
            overrides: const {},
            onIntervalChanged: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Два элемента → два ValueStepper.
      expect(find.byType(ValueStepper), findsNWidgets(2));
    });

    testWidgets('should_show_species_default_value_when_no_override',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          CarePlanPreview(
            items: const [wateringItem],
            overrides: const {},
            onIntervalChanged: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // l10n.editScheduleDaysUnit(7) → «7 дн.»
      expect(find.text('7 дн.'), findsOneWidget);
    });

    testWidgets('should_show_override_value_when_override_present',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          CarePlanPreview(
            items: const [wateringItem],
            overrides: const {CareTaskType.watering: 14},
            onIntervalChanged: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Оверрайд = 14 дн., дефолт 7 не показывается.
      expect(find.text('14 дн.'), findsOneWidget);
      expect(find.text('7 дн.'), findsNothing);
    });

    testWidgets(
        'should_call_onIntervalChanged_with_correct_type_and_incremented_value_on_tap_plus',
        (tester) async {
      CareTaskType? capturedType;
      int? capturedEvery;

      await tester.pumpWidget(
        _wrap(
          CarePlanPreview(
            items: const [wateringItem],
            overrides: const {CareTaskType.watering: 7},
            onIntervalChanged: (type, every) {
              capturedType = type;
              capturedEvery = every;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Тапаем кнопку «+» (increment) у шага.
      // Semantics-label = «Каждые 8 дн.» — ищем по иконке + через семантику.
      final stepper = tester.widget<ValueStepper>(find.byType(ValueStepper));
      expect(stepper.onIncrement, isNotNull);
      stepper.onIncrement!();

      expect(capturedType, CareTaskType.watering);
      expect(capturedEvery, 8); // 7 + 1
    });

    testWidgets('should_disable_decrement_button_when_currentEvery_is_1',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          CarePlanPreview(
            items: const [wateringItem],
            overrides: const {CareTaskType.watering: 1},
            onIntervalChanged: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final stepper = tester.widget<ValueStepper>(find.byType(ValueStepper));
      // При currentEvery == 1 onDecrement должен быть null (кнопка disabled).
      expect(stepper.onDecrement, isNull);
    });

    testWidgets(
        'should_enable_decrement_button_when_currentEvery_is_greater_than_1',
        (tester) async {
      CareTaskType? capturedType;
      int? capturedEvery;

      await tester.pumpWidget(
        _wrap(
          CarePlanPreview(
            items: const [wateringItem],
            overrides: const {CareTaskType.watering: 5},
            onIntervalChanged: (type, every) {
              capturedType = type;
              capturedEvery = every;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final stepper = tester.widget<ValueStepper>(find.byType(ValueStepper));
      expect(stepper.onDecrement, isNotNull);
      stepper.onDecrement!();

      expect(capturedType, CareTaskType.watering);
      expect(capturedEvery, 4); // 5 - 1
    });
  });
}
