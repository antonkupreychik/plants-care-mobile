import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/add_plant/domain/species_summary.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/widgets/care_plan_preview.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/widgets/step_care_plan.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

// Вид с двумя пунктами плана ухода
const _speciesWithPlan = SpeciesSummary(
  id: 1,
  name: 'Фикус',
  wateringDays: 7,
  fertilizingDays: 30,
);

// Вид без ни одного заданного интервала — пустой carePlan
const _speciesEmptyPlan = SpeciesSummary(id: 2, name: 'Кактус');

void main() {
  group('StepCarePlan', () {
    testWidgets('should_show_CarePlanHint_when_species_is_null',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          StepCarePlan(
            species: null,
            intervalOverrides: const {},
            onIntervalChanged: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CarePlanHint), findsOneWidget);
      expect(find.byType(CarePlanPreview), findsNothing);
    });

    testWidgets('should_show_CarePlanHint_when_species_has_empty_carePlan',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          StepCarePlan(
            species: _speciesEmptyPlan,
            intervalOverrides: const {},
            onIntervalChanged: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CarePlanHint), findsOneWidget);
      expect(find.byType(CarePlanPreview), findsNothing);
    });

    testWidgets('should_show_CarePlanPreview_when_species_has_items',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          StepCarePlan(
            species: _speciesWithPlan,
            intervalOverrides: const {},
            onIntervalChanged: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CarePlanPreview), findsOneWidget);
      expect(find.byType(CarePlanHint), findsNothing);
    });

    testWidgets('should_not_show_InfoNotice_read_only_banner', (tester) async {
      // _InfoNotice был удалён в этом изменении. Проверяем, что его больше нет
      // ни для одного состояния шага.

      // Со species и планом
      await tester.pumpWidget(
        _wrap(
          StepCarePlan(
            species: _speciesWithPlan,
            intervalOverrides: const {},
            onIntervalChanged: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Проверяем l10n-строку, которую показывал старый _InfoNotice.
      // Получаем локализацию через context.
      final l10n = AppLocalizations.of(
        tester.element(find.byType(StepCarePlan)),
      );
      expect(find.text(l10n.addPlantCarePlanReadOnly), findsNothing);

      // Без species
      await tester.pumpWidget(
        _wrap(
          StepCarePlan(
            species: null,
            intervalOverrides: const {},
            onIntervalChanged: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.addPlantCarePlanReadOnly), findsNothing);
    });

    testWidgets('should_pass_overrides_to_CarePlanPreview', (tester) async {
      CareTaskType? capturedType;
      int? capturedEvery;

      await tester.pumpWidget(
        _wrap(
          StepCarePlan(
            species: _speciesWithPlan,
            intervalOverrides: const {CareTaskType.watering: 14},
            onIntervalChanged: (type, every) {
              capturedType = type;
              capturedEvery = every;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Оверрайд 14 должен отображаться в степпере
      expect(find.text('14 дн.'), findsOneWidget);

      // Вызываем increment через виджет-обёртку CarePlanPreview
      final preview =
          tester.widget<CarePlanPreview>(find.byType(CarePlanPreview));
      expect(preview.overrides[CareTaskType.watering], 14);

      // Убеждаемся что колбэк доходит до StepCarePlan → наружу
      preview.onIntervalChanged(CareTaskType.watering, 15);
      expect(capturedType, CareTaskType.watering);
      expect(capturedEvery, 15);
    });
  });
}
