import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/presentation/plant_illustration.dart';
import 'package:plantcare_mobile/features/home/presentation/today_view.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_task_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

final _now = DateTime.utc(2026, 5, 27, 9);

TodayTaskItem _item({String? speciesName}) => TodayTaskItem(
      task: CareTask(
        scheduleId: 1,
        plantId: 1,
        plantName: 'Растение',
        type: CareTaskType.watering,
        dueAt: _now.add(const Duration(hours: 3)),
        speciesName: speciesName,
      ),
      overdue: false,
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
  group('TodayTaskCard plant illustration (G6)', () {
    testWidgets(
        'should_render_species_illustration_when_speciesName_known',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayTaskCard(
        item: _item(speciesName: 'Фикус'),
        now: _now,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      final art = _illustration(tester);
      expect(art.speciesName, 'Фикус');
      // «Фикус» не входит ни в один распознаваемый набор → дефолт monstera,
      // но иллюстрация всё равно строится по виду задачи (не нейтральный глиф).
      expect(PlantArt.fromSpecies(art.speciesName), PlantArt.monstera);
    });

    testWidgets(
        'should_resolve_fern_illustration_for_fern_species',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayTaskCard(
        item: _item(speciesName: 'Папоротник'),
        now: _now,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      final art = _illustration(tester);
      expect(art.speciesName, 'Папоротник');
      expect(PlantArt.fromSpecies(art.speciesName), PlantArt.fern);
    });

    testWidgets(
        'should_render_default_illustration_when_speciesName_null',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayTaskCard(
        item: _item(speciesName: null),
        now: _now,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      final art = _illustration(tester);
      expect(art.speciesName, isNull);
      expect(PlantArt.fromSpecies(art.speciesName), PlantArt.monstera);
    });

    testWidgets(
        'should_not_render_neutral_florist_glyph_on_card',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayTaskCard(
        item: _item(speciesName: 'Монстера'),
        now: _now,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_florist_outlined), findsNothing);
      expect(find.byType(PlantIllustration), findsOneWidget);
    });
  });
}
