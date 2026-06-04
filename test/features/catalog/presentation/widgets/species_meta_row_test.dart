import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/theme/tokens.dart';
import 'package:plantcare_mobile/features/catalog/domain/care_difficulty.dart';
import 'package:plantcare_mobile/features/catalog/domain/light_preference.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_meta_row.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

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
  group('SpeciesMetaRow', () {
    testWidgets('should_render_light_with_dot_separator_no_sun_icon',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SpeciesMetaRow(
            difficulty: CareDifficulty.easy,
            light: LightPreference.brightIndirect,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Свет через текстовый разделитель «·», без иконки солнца.
      expect(find.byIcon(Icons.wb_sunny_outlined), findsNothing);
      expect(
        find.textContaining('·'),
        findsWidgets,
        reason: 'light label prefixed with dot separator',
      );
    });

    testWidgets('should_hide_light_when_unknown', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SpeciesMetaRow(
            difficulty: CareDifficulty.easy,
            light: LightPreference.unknown,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('·'), findsNothing);
    });

    testWidgets('should_show_toxic_badge_when_toxic', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SpeciesMetaRow(
            difficulty: CareDifficulty.easy,
            light: LightPreference.unknown,
            toxic: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('⚠ ТОКСИЧНО · 🐈'), findsOneWidget);
    });

    testWidgets('should_hide_toxic_badge_when_not_toxic', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SpeciesMetaRow(
            difficulty: CareDifficulty.easy,
            light: LightPreference.unknown,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('⚠ ТОКСИЧНО · 🐈'), findsNothing);
    });

    testWidgets('difficulty_dot_easy_primary_medium_terracotta',
        (tester) async {
      const c = PcColors.light;

      Color dotColorOf() {
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(SpeciesMetaRow),
                matching: find.byType(Container),
              )
              .first,
        );
        return (container.decoration! as BoxDecoration).color!;
      }

      // Лёгкая → primary (зелёная).
      await tester.pumpWidget(
        _wrap(
          const SpeciesMetaRow(
            difficulty: CareDifficulty.easy,
            light: LightPreference.unknown,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(dotColorOf(), c.primary);

      // Средняя → terracotta (по дизайну diffOk == false).
      await tester.pumpWidget(
        _wrap(
          const SpeciesMetaRow(
            difficulty: CareDifficulty.medium,
            light: LightPreference.unknown,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(dotColorOf(), c.terracotta);
    });
  });
}
