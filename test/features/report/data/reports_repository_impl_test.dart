import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/reports_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/monthly_report_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/weekly_health_bucket.dart'
    as dto;
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/report/data/reports_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockReportsClient extends Mock implements ReportsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/reports/monthly'),
      error: error,
    );

MonthlyReportResponse _response() => const MonthlyReportResponse(
      month: '2026-05',
      done: 12,
      overdue: 3,
      byType: {'WATERING': 8, 'FERTILIZING': 4},
      streak: 7,
      healthTrend: [
        dto.WeeklyHealthBucket(week: '2026-W18', done: 6, onTimePct: 1),
        dto.WeeklyHealthBucket(week: '2026-W19', done: 6, onTimePct: 0.5),
      ],
    );

void main() {
  late _MockApi api;
  late _MockReportsClient reports;
  late ReportsRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    reports = _MockReportsClient();
    when(() => api.reports).thenReturn(reports);
    repo = ReportsRepositoryImpl(api);
  });

  group('getMonthlyReport success', () {
    test('should_return_success_with_mapped_domain', () async {
      when(() => reports.getMonthlyReport(
            xUserId: any(named: 'xUserId'),
            month: any(named: 'month'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _response());

      final result = await repo.getMonthlyReport(month: '2026-05');

      final report = (result as Success).value;
      expect(report.month, '2026-05');
      expect(report.done, 12);
      expect(report.overdue, 3);
      expect(report.streak, 7);
      expect(report.byType[CareTaskType.watering], 8);
      expect(report.byType[CareTaskType.fertilizing], 4);
      expect(report.healthTrend, hasLength(2));
      // Взвешенно: (6*1 + 6*0.5)/12 = 0.75 — проверяем сквозной маппинг до геттера.
      expect(report.onTimePct, closeTo(0.75, 1e-9));
    });

    test('should_forward_month_query_to_client', () async {
      when(() => reports.getMonthlyReport(
            xUserId: any(named: 'xUserId'),
            month: any(named: 'month'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _response());

      await repo.getMonthlyReport(month: '2026-04');

      verify(() => reports.getMonthlyReport(
            xUserId: any(named: 'xUserId'),
            month: '2026-04',
            extras: any(named: 'extras'),
          )).called(1);
    });

    // Auth-слот: отчёт user-scoped — идёт со scope user (X-User-Id ставит
    // интерсептор). Идентичность в data НЕ хардкодится. Тест ловит молчаливую
    // регрессию scope при подключении реального auth.
    test('should_send_user_authScope_in_extras', () async {
      when(() => reports.getMonthlyReport(
            xUserId: any(named: 'xUserId'),
            month: any(named: 'month'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _response());

      await repo.getMonthlyReport(month: '2026-05');

      final captured = verify(() => reports.getMonthlyReport(
            xUserId: any(named: 'xUserId'),
            month: any(named: 'month'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });
  });

  group('getMonthlyReport failure', () {
    test('should_return_failure_with_ApiError_from_DioException_without_throw',
        () async {
      when(() => reports.getMonthlyReport(
            xUserId: any(named: 'xUserId'),
            month: any(named: 'month'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getMonthlyReport(month: '2026-05');

      // Наружу не бросает — заворачивает в Result.failure.
      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => reports.getMonthlyReport(
            xUserId: any(named: 'xUserId'),
            month: any(named: 'month'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.getMonthlyReport(month: '2026-05');

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
