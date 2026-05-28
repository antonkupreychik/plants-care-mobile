import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/presentation/plant_illustration.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

final _now = DateTime.utc(2026, 5, 27, 9);

CareTask _task({String? speciesName}) => CareTask(
      scheduleId: 1,
      plantId: 1,
      plantName: 'Растение',
      type: CareTaskType.watering,
      dueAt: _now.add(const Duration(hours: 3)),
      speciesName: speciesName,
    );

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );

PlantIllustration _illustration(WidgetTester tester) =>
    tester.widget<PlantIllustration>(find.byType(PlantIllustration));

void main() {
  group('TodayCard plant illustration (G6)', () {
    testWidgets(
        'should_render_species_illustration_when_speciesName_known',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: [_task(speciesName: 'Папоротник')],
        now: _now,
        onTaskTap: (_) {},
      )));
      await tester.pumpAndSettle();

      // Иллюстрация подбирается по виду задачи, а не нейтральный глиф.
      final art = _illustration(tester);
      expect(art.speciesName, 'Папоротник');
      // Известный вид резолвится в соответствующий ассет (не дефолт).
      expect(PlantArt.fromSpecies(art.speciesName), PlantArt.fern);
    });

    testWidgets(
        'should_resolve_monstera_for_another_known_species',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: [_task(speciesName: 'Монстера')],
        now: _now,
        onTaskTap: (_) {},
      )));
      await tester.pumpAndSettle();

      final art = _illustration(tester);
      expect(art.speciesName, 'Монстера');
      expect(PlantArt.fromSpecies(art.speciesName), PlantArt.monstera);
    });

    testWidgets(
        'should_render_default_illustration_when_speciesName_null',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: [_task(speciesName: null)],
        now: _now,
        onTaskTap: (_) {},
      )));
      await tester.pumpAndSettle();

      // Не падаем при null-виде; PlantIllustration отрисован с null и
      // резолвится в дефолт (monstera).
      final art = _illustration(tester);
      expect(art.speciesName, isNull);
      expect(PlantArt.fromSpecies(art.speciesName), PlantArt.monstera);
    });

    testWidgets(
        'should_not_render_neutral_florist_glyph_on_task_row',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: [_task(speciesName: 'Монстера')],
        now: _now,
        onTaskTap: (_) {},
      )));
      await tester.pumpAndSettle();

      // Прежний нейтральный глиф вида заменён на PlantIllustration (G6).
      expect(find.byIcon(Icons.local_florist_outlined), findsNothing);
      expect(find.byType(PlantIllustration), findsOneWidget);
    });
  });
}
