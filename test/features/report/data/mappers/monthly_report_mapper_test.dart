import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/monthly_report_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/weekly_health_bucket.dart'
    as dto;
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/report/data/mappers/monthly_report_mapper.dart';

MonthlyReportResponse _response({
  String month = '2026-05',
  int done = 0,
  int overdue = 0,
  Map<String, int> byType = const {},
  int streak = 0,
  List<dto.WeeklyHealthBucket>? healthTrend,
}) =>
    MonthlyReportResponse(
      month: month,
      done: done,
      overdue: overdue,
      byType: byType,
      streak: streak,
      // Генератор отдаёт required-список; null приходит при «отсутствии» —
      // воспроизводим через явный null-каст ниже в нужном тесте.
      healthTrend: healthTrend ?? const [],
    );

void main() {
  group('MonthlyReportResponseMapper.toDomain byType', () {
    test('should_keep_known_codes_and_drop_unknown', () {
      final domain = _response(
        done: 9,
        byType: const {
          'WATERING': 5,
          'MISTING': 4,
          'TELEPORTATION': 99, // неизвестный код → отбрасывается
        },
      ).toDomain();

      expect(domain.byType[CareTaskType.watering], 5);
      expect(domain.byType[CareTaskType.misting], 4);
      // Неизвестный код не попал в карту и не схлопнулся в unknown.
      expect(domain.byType.containsKey(CareTaskType.unknown), isFalse);
      expect(domain.byType.length, 2);
    });

    test('should_sum_values_when_codes_collide_into_same_type', () {
      // Разный регистр одного кода → один и тот же CareTaskType.watering.
      final domain = _response(
        byType: const {'WATERING': 3, 'watering': 2},
      ).toDomain();

      // Коллизия суммируется, а не перезаписывается.
      expect(domain.byType[CareTaskType.watering], 5);
      expect(domain.byType.length, 1);
    });

    test('should_carry_scalar_fields_verbatim', () {
      final domain = _response(
        month: '2026-04',
        done: 12,
        overdue: 3,
        streak: 7,
      ).toDomain();

      expect(domain.month, '2026-04');
      expect(domain.done, 12);
      expect(domain.overdue, 3);
      expect(domain.streak, 7);
    });
  });

  group('MonthlyReportResponseMapper.toDomain onTimePct clamp', () {
    test('should_clamp_onTimePct_above_one_down_to_one', () {
      final domain = _response(
        healthTrend: const [
          dto.WeeklyHealthBucket(week: '2026-W18', done: 4, onTimePct: 1.7),
        ],
      ).toDomain();

      expect(domain.healthTrend.single.onTimePct, 1.0);
    });

    test('should_clamp_onTimePct_below_zero_up_to_zero', () {
      final domain = _response(
        healthTrend: const [
          dto.WeeklyHealthBucket(week: '2026-W18', done: 4, onTimePct: -0.3),
        ],
      ).toDomain();

      expect(domain.healthTrend.single.onTimePct, 0.0);
    });

    test('should_keep_in_range_onTimePct_untouched', () {
      final domain = _response(
        healthTrend: const [
          dto.WeeklyHealthBucket(week: '2026-W18', done: 4, onTimePct: 0.42),
        ],
      ).toDomain();

      expect(domain.healthTrend.single.onTimePct, 0.42);
      expect(domain.healthTrend.single.week, '2026-W18');
      expect(domain.healthTrend.single.done, 4);
    });
  });

  group('MonthlyReportResponseMapper.toDomain healthTrend', () {
    test('should_map_empty_trend_to_empty_list', () {
      final domain = _response(healthTrend: const []).toDomain();

      expect(domain.healthTrend, isEmpty);
    });
  });
}
