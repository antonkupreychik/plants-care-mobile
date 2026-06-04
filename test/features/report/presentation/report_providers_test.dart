import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/report/data/reports_repository_provider.dart';
import 'package:plantcare_mobile/features/report/domain/monthly_report.dart';
import 'package:plantcare_mobile/features/report/domain/reports_repository.dart';
import 'package:plantcare_mobile/features/report/presentation/report_providers.dart';

class _MockRepo extends Mock implements ReportsRepository {}

/// Фиксированные «часы» — отдают заданный UTC-момент вместо реального времени
/// (паттерн _FixedClock из home/schedule-тестов).
class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

/// Ожидаемая строка `YYYY-MM` из локальной даты — независимая копия формулы
/// прод-кода (чтобы проверка была честной, а не тавтологией).
String _expectedMonth(DateTime local) =>
    '${local.year}-${local.month.toString().padLeft(2, '0')}';

ProviderContainer _containerAt(DateTime nowUtc) {
  final container = ProviderContainer(
    overrides: [clockProvider.overrideWithValue(_FixedClock(nowUtc))],
  );
  addTearDown(container.dispose);
  return container;
}

ProviderContainer _containerWithRepo(ReportsRepository repo) {
  final container = ProviderContainer(
    overrides: [reportsRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

MonthlyReport _report(String month) => MonthlyReport(
      month: month,
      done: 5,
      overdue: 1,
      byType: const {CareTaskType.watering: 5},
      streak: 3,
      healthTrend: const [],
    );

void main() {
  group('currentReportMonthProvider', () {
    test('should_use_clockProvider_not_real_now', () {
      // «Исторический» момент: если код возьмёт DateTime.now(), результат уедет
      // на текущий месяц и assert упадёт.
      final nowUtc = DateTime.utc(2026, 5, 15, 12);
      final container = _containerAt(nowUtc);

      final month = container.read(currentReportMonthProvider);

      expect(month, _expectedMonth(nowUtc.toLocal()));
    });

    test('should_format_with_zero_padded_month', () {
      // Январь → «01», не «1». Полдень, чтобы TZ-сдвиг не перенёс на декабрь.
      final nowUtc = DateTime.utc(2026, 1, 15, 12);
      final container = _containerAt(nowUtc);

      final month = container.read(currentReportMonthProvider);

      expect(month, _expectedMonth(nowUtc.toLocal()));
      expect(month.split('-')[1].length, 2);
    });

    // Не-UTC таймзона: выбираем UTC-момент у границы месяца так, чтобы после
    // .toLocal() (host-TZ) локальный месяц ГАРАНТИРОВАННО отличался от UTC-месяца
    // независимо от знака смещения хоста:
    //   - host восточнее UTC (offset > 0): берём конец апреля 23:30Z → локально
    //     уже май;
    //   - host западнее UTC (offset < 0): берём начало мая 00:30Z → локально ещё
    //     апрель;
    //   - host == UTC: тест помечает себя skip (воспроизвести сдвиг нельзя).
    // Провайдер обязан взять месяц из ЛОКАЛЬНОЙ даты — ловит регрессию «месяц по
    // UTC» в TZ, отличной от UTC.
    test('should_take_month_from_local_date_not_utc_under_nonUtc_tz', () {
      final offset = DateTime.now().timeZoneOffset;
      final nowUtc = offset.isNegative
          ? DateTime.utc(2026, 5, 1, 0, 30) // начало мая по UTC
          : DateTime.utc(2026, 4, 30, 23, 30); // конец апреля по UTC
      final container = _containerAt(nowUtc);

      final month = container.read(currentReportMonthProvider);
      final local = nowUtc.toLocal();
      final utcMonth = '${nowUtc.year}-${nowUtc.month.toString().padLeft(2, '0')}';

      // Месяц взят из локальной даты пользователя, а не из UTC.
      expect(month, _expectedMonth(local));
      // Подтверждаем, что сдвиг действительно перевёл календарный месяц.
      expect(local.month, isNot(nowUtc.month));
      expect(month, isNot(utcMonth));
    }, skip: DateTime.now().timeZoneOffset == Duration.zero
        ? 'host TZ == UTC: сдвиг месяца воспроизвести нельзя'
        : false);
  });

  group('monthlyReportProvider', () {
    test('should_forward_month_and_emit_mapped_data', () async {
      final repo = _MockRepo();
      when(() => repo.getMonthlyReport(month: any(named: 'month')))
          .thenAnswer((_) async => Result.success(_report('2026-04')));
      final container = _containerWithRepo(repo);

      final report =
          await container.read(monthlyReportProvider('2026-04').future);

      expect(report.month, '2026-04');
      expect(report.done, 5);
      // Месяц проброшен в репозиторий ровно как пришёл во family.
      verify(() => repo.getMonthlyReport(month: '2026-04')).called(1);
    });

    test('should_throw_ApiError_into_AsyncError_when_repo_fails', () async {
      final repo = _MockRepo();
      when(() => repo.getMonthlyReport(month: any(named: 'month')))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWithRepo(repo);

      final completer = Completer<Object?>();
      final sub = container.listen(
        monthlyReportProvider('2026-05'),
        (_, next) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        },
      );
      addTearDown(sub.close);

      expect(await completer.future, const ApiError.network());
    });
  });
}
