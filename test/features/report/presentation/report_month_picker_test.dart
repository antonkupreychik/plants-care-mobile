import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/report/presentation/widgets/report_month_picker.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

Widget _wrap({
  required String month,
  required bool canGoPrev,
  required bool canGoNext,
  VoidCallback? onPrevMonth,
  VoidCallback? onNextMonth,
}) {
  return MaterialApp(
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    home: Scaffold(
      body: Center(
        child: ReportMonthPicker(
          month: month,
          canGoPrev: canGoPrev,
          canGoNext: canGoNext,
          onPrevMonth: onPrevMonth ?? () {},
          onNextMonth: onNextMonth ?? () {},
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  group('ReportMonthPicker', () {
    group('label', () {
      testWidgets('should_show_localized_month_label_for_june_2026',
          (tester) async {
        await tester.pumpWidget(_wrap(
          month: '2026-06',
          canGoPrev: true,
          canGoNext: false,
        ));
        await tester.pumpAndSettle();

        // «Июн 2026» — русская аббревиатура июня, заглавная первая буква.
        expect(find.textContaining('2026'), findsOneWidget);
        // Текст не должен быть пустым.
        final textWidgets = tester
            .widgetList<Text>(find.byType(Text))
            .where((t) => (t.data ?? '').contains('2026'))
            .toList();
        expect(textWidgets, isNotEmpty);
      });

      testWidgets('should_show_may_2026_label', (tester) async {
        await tester.pumpWidget(_wrap(
          month: '2026-05',
          canGoPrev: true,
          canGoNext: true,
        ));
        await tester.pumpAndSettle();

        expect(find.textContaining('2026'), findsOneWidget);
      });
    });

    group('prev button', () {
      testWidgets('should_call_onPrevMonth_when_tapped_and_enabled',
          (tester) async {
        var tapped = false;
        await tester.pumpWidget(_wrap(
          month: '2026-05',
          canGoPrev: true,
          canGoNext: true,
          onPrevMonth: () => tapped = true,
        ));
        await tester.pumpAndSettle();

        // Тапаем по первой InkWell (кнопка «<»).
        await tester.tap(find.byType(InkWell).first);
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('should_not_call_onPrevMonth_when_disabled', (tester) async {
        var tapped = false;
        await tester.pumpWidget(_wrap(
          month: '2025-06',
          canGoPrev: false,
          canGoNext: true,
          onPrevMonth: () => tapped = true,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(InkWell).first, warnIfMissed: false);
        await tester.pump();

        expect(tapped, isFalse);
      });
    });

    group('next button', () {
      testWidgets('should_call_onNextMonth_when_tapped_and_enabled',
          (tester) async {
        var tapped = false;
        await tester.pumpWidget(_wrap(
          month: '2026-05',
          canGoPrev: true,
          canGoNext: true,
          onNextMonth: () => tapped = true,
        ));
        await tester.pumpAndSettle();

        // Тапаем по последней InkWell (кнопка «>»).
        await tester.tap(find.byType(InkWell).last);
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('should_not_call_onNextMonth_when_disabled', (tester) async {
        var tapped = false;
        await tester.pumpWidget(_wrap(
          month: '2026-06',
          canGoPrev: true,
          canGoNext: false,
          onNextMonth: () => tapped = true,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(InkWell).last, warnIfMissed: false);
        await tester.pump();

        expect(tapped, isFalse);
      });
    });

    group('semantics', () {
      testWidgets('should_render_semantics_labels_for_both_arrows',
          (tester) async {
        await tester.pumpWidget(_wrap(
          month: '2026-05',
          canGoPrev: true,
          canGoNext: true,
        ));
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(
          tester.element(find.byType(ReportMonthPicker)),
        );

        expect(
          find.bySemanticsLabel(l10n.reportPrevMonth),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel(l10n.reportNextMonth),
          findsOneWidget,
        );
      });
    });
  });
}
