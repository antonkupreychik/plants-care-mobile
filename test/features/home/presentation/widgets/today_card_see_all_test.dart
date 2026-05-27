import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

final _now = DateTime.utc(2026, 5, 27, 9);

CareTask _task() => CareTask(
      scheduleId: 1,
      plantId: 1,
      plantName: 'Фикус',
      type: CareTaskType.watering,
      dueAt: _now.add(const Duration(hours: 3)),
    );

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('should_call_onSeeAll_when_section_header_tapped',
      (tester) async {
    var tapped = 0;

    await tester.pumpWidget(_wrap(TodayCard(
      tasks: [_task()],
      now: _now,
      onTaskTap: (_) {},
      onSeeAll: () => tapped++,
    )));
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(tester.element(find.byType(TodayCard)));
    // Тап по заголовку секции (overline в верхнем регистре).
    await tester.tap(find.text(l10n.homeTodayTitle.toUpperCase()));
    await tester.pump();

    expect(tapped, 1);
  });

  testWidgets('should_not_make_header_interactive_when_onSeeAll_null',
      (tester) async {
    await tester.pumpWidget(_wrap(TodayCard(
      tasks: [_task()],
      now: _now,
      onTaskTap: (_) {},
    )));
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(tester.element(find.byType(TodayCard)));
    // Без onSeeAll нет аффорданса «посмотреть все» (шеврон/seeAll-семантика).
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    // Заголовок по-прежнему отрисован.
    expect(find.text(l10n.homeTodayTitle.toUpperCase()), findsOneWidget);
  });
}
