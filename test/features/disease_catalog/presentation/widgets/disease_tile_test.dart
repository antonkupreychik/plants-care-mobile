import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/disease_catalog/domain/disease.dart';
import 'package:plantcare_mobile/features/disease_catalog/presentation/widgets/disease_tile.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );

Disease _disease({required String name, required String symptoms}) => Disease(
      id: 1,
      name: name,
      symptoms: symptoms,
      treatment: 't',
      prevention: 'p',
    );

void main() {
  group('DiseaseTile', () {
    testWidgets('shows_name', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DiseaseTile(
            disease: _disease(name: 'Тля', symptoms: 'Мелкие насекомые'),
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Тля'), findsOneWidget);
    });

    testWidgets('truncates_long_symptoms_with_ellipsis', (tester) async {
      final longSymptoms = 'А' * 120;
      await tester.pumpWidget(
        _wrap(
          DiseaseTile(
            disease: _disease(name: 'X', symptoms: longSymptoms),
            onTap: () {},
          ),
        ),
      );

      // Превью обрезано до ~60 символов и оканчивается многоточием.
      final textFinder = find.textContaining('…');
      expect(textFinder, findsOneWidget);
      final shown = tester.widget<Text>(textFinder).data!;
      expect(shown.length, lessThan(longSymptoms.length));
    });

    testWidgets('short_symptoms_shown_without_ellipsis', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DiseaseTile(
            disease: _disease(name: 'X', symptoms: 'Коротко'),
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Коротко'), findsOneWidget);
    });

    testWidgets('tap_invokes_callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          DiseaseTile(
            disease: _disease(name: 'X', symptoms: 'Y'),
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(DiseaseTile));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
