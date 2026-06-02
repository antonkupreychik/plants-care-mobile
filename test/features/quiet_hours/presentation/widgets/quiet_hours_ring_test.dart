import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/quiet_time.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/widgets/quiet_hours_ring.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

Widget _wrap(QuietTime start, QuietTime end) => MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: Scaffold(
        body: Center(child: QuietHoursRing(start: start, end: end)),
      ),
    );

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(QuietHoursRing)));

void main() {
  testWidgets('should_render_same_day_range_without_exception', (tester) async {
    // Обычный диапазон в пределах суток: 13:00 → 15:00 = 2 ч.
    await tester.pumpWidget(_wrap(
      const QuietTime(hour: 13, minute: 0),
      const QuietTime(hour: 15, minute: 0),
    ));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(QuietHoursRing), findsOneWidget);
    final l10n = _l10n(tester);
    // Подпись «N часов тишины» считает 2 часа.
    expect(find.text(l10n.quietHoursRingCount(2)), findsWidgets);
    expect(find.text('13:00'), findsOneWidget);
    expect(find.text('15:00'), findsOneWidget);
  });

  testWidgets('should_render_overnight_range_as_10_hours', (tester) async {
    // Через полночь: 22:00 → 08:00 = 10 ч тишины.
    await tester.pumpWidget(_wrap(
      const QuietTime(hour: 22, minute: 0),
      const QuietTime(hour: 8, minute: 0),
    ));
    await tester.pump();

    expect(tester.takeException(), isNull);
    final l10n = _l10n(tester);
    expect(find.text(l10n.quietHoursRingCount(10)), findsWidgets);
  });

  testWidgets('should_render_equal_start_end_as_zero_without_crash',
      (tester) async {
    // start == end → 0 часов, без падения (backend отвергнет на save отдельно).
    await tester.pumpWidget(_wrap(
      const QuietTime(hour: 8, minute: 0),
      const QuietTime(hour: 8, minute: 0),
    ));
    await tester.pump();

    expect(tester.takeException(), isNull);
    final l10n = _l10n(tester);
    expect(find.text(l10n.quietHoursRingCount(0)), findsWidgets);
  });
}
