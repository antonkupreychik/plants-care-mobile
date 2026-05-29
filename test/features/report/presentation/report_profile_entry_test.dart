import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/app.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/env/app_config.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/router/app_router.dart';
import 'package:plantcare_mobile/core/widgets/app_bottom_nav.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/profile/presentation/profile_screen.dart';
import 'package:plantcare_mobile/features/report/data/reports_repository_provider.dart';
import 'package:plantcare_mobile/features/report/domain/monthly_report.dart';
import 'package:plantcare_mobile/features/report/domain/reports_repository.dart';
import 'package:plantcare_mobile/features/report/presentation/monthly_report_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockReportsRepo extends Mock implements ReportsRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

const _config = AppConfig(
  flavor: Flavor.dev,
  apiUrl: 'https://example.test',
  chatId: '9000001',
  userId: '1',
);

final _utcNow = DateTime.utc(2026, 5, 27, 9);

final _report = MonthlyReport(
  month: '2026-05',
  done: 5,
  overdue: 1,
  byType: const {CareTaskType.watering: 5},
  streak: 3,
  healthTrend: const [],
);

Widget _wrap(ReportsRepository reportsRepo) {
  return ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(_config),
      clockProvider.overrideWithValue(_FixedClock(_utcNow)),
      homeTasksProvider.overrideWith((ref) async => const <CareTask>[]),
      homePlantsProvider.overrideWith((ref) async => const <Plant>[]),
      homeLocationsProvider
          .overrideWith((ref) async => const <GardenLocation>[]),
      reportsRepositoryProvider.overrideWithValue(reportsRepo),
    ],
    child: const PlantCareApp(),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  setUp(() => appRouter.go('/home'));

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(AppBottomNav)));

  testWidgets('should_open_monthly_report_when_profile_row_tapped',
      (tester) async {
    final reportsRepo = _MockReportsRepo();
    when(() => reportsRepo.getMonthlyReport(month: any(named: 'month')))
        .thenAnswer((_) async => Result.success(_report));

    await tester.pumpWidget(_wrap(reportsRepo));
    await tester.pumpAndSettle();

    final l10n = l10nOf(tester);
    await tester.tap(find.text(l10n.navProfile));
    await tester.pumpAndSettle();

    // В профиле есть строка «Месячный отчёт».
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text(l10n.profileReportTitle), findsOneWidget);

    await tester.tap(find.text(l10n.profileReportTitle));
    await tester.pumpAndSettle();

    // Экран отчёта открыт поверх shell (таб-бар скрыт), данные подгружены.
    expect(find.byType(MonthlyReportScreen), findsOneWidget);
    expect(find.byType(AppBottomNav), findsNothing);
    verify(() => reportsRepo.getMonthlyReport(month: any(named: 'month')))
        .called(1);
  });
}
