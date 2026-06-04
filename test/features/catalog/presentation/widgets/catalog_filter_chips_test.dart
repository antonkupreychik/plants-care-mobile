import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/catalog_filter_chips.dart';
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
  group('CatalogFilterChips', () {
    testWidgets('should_render_all_four_filter_chips', (tester) async {
      await tester.pumpWidget(_wrap(const CatalogFilterChips(total: 30)));
      await tester.pumpAndSettle();

      expect(find.text('Все'), findsOneWidget);
      expect(find.text('Для новичка'), findsOneWidget);
      expect(find.text('Безопасно для котов 🐈'), findsOneWidget);
      expect(find.text('Цветущие'), findsOneWidget);
    });

    testWidgets('should_show_total_count_on_all_chip', (tester) async {
      await tester.pumpWidget(_wrap(const CatalogFilterChips(total: 30)));
      await tester.pumpAndSettle();

      expect(find.text('30'), findsOneWidget);
    });

    testWidgets('should_hide_count_when_total_null', (tester) async {
      await tester.pumpWidget(_wrap(const CatalogFilterChips(total: null)));
      await tester.pumpAndSettle();

      expect(find.text('Все'), findsOneWidget);
      // Никаких числовых счётчиков, пока total неизвестен.
      expect(find.text('0'), findsNothing);
    });
  });
}
