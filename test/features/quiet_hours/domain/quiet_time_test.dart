import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/quiet_time.dart';

void main() {
  group('QuietTime.parse', () {
    test('should_parse_valid_HH_mm', () {
      final t = QuietTime.parse('22:00');

      expect(t, const QuietTime(hour: 22, minute: 0));
    });

    test('should_parse_boundary_00_00', () {
      expect(QuietTime.parse('00:00'), const QuietTime(hour: 0, minute: 0));
    });

    test('should_parse_boundary_23_59', () {
      expect(QuietTime.parse('23:59'), const QuietTime(hour: 23, minute: 59));
    });

    test('should_accept_single_digit_hour', () {
      expect(QuietTime.parse('8:05'), const QuietTime(hour: 8, minute: 5));
    });

    test('should_trim_surrounding_and_inner_whitespace', () {
      expect(QuietTime.parse(' 22 : 30 '),
          const QuietTime(hour: 22, minute: 30));
    });

    test('should_return_null_when_no_colon', () {
      expect(QuietTime.parse('2200'), isNull);
    });

    test('should_return_null_when_extra_segments', () {
      expect(QuietTime.parse('22:00:00'), isNull);
    });

    test('should_return_null_when_non_numeric', () {
      expect(QuietTime.parse('aa:bb'), isNull);
    });

    test('should_return_null_when_hour_out_of_range_24', () {
      expect(QuietTime.parse('24:00'), isNull);
    });

    test('should_return_null_when_hour_negative', () {
      expect(QuietTime.parse('-1:00'), isNull);
    });

    test('should_return_null_when_minute_out_of_range_60', () {
      expect(QuietTime.parse('10:60'), isNull);
    });
  });

  group('QuietTime.format', () {
    test('should_zero_pad_hour_and_minute', () {
      expect(const QuietTime(hour: 8, minute: 5).format(), '08:05');
    });

    test('should_format_00_00', () {
      expect(const QuietTime(hour: 0, minute: 0).format(), '00:00');
    });

    test('should_format_23_59', () {
      expect(const QuietTime(hour: 23, minute: 59).format(), '23:59');
    });
  });

  group('round-trip', () {
    test('should_round_trip_parse_then_format', () {
      for (final raw in const ['00:00', '08:05', '22:00', '23:59']) {
        expect(QuietTime.parse(raw)!.format(), raw);
      }
    });
  });

  group('QuietTime.clamped', () {
    test('should_keep_values_in_range', () {
      expect(QuietTime.clamped(hour: 10, minute: 30),
          const QuietTime(hour: 10, minute: 30));
    });

    test('should_clamp_hour_above_23_to_23', () {
      expect(QuietTime.clamped(hour: 99, minute: 0).hour, 23);
    });

    test('should_clamp_negative_hour_to_0', () {
      expect(QuietTime.clamped(hour: -5, minute: 0).hour, 0);
    });

    test('should_clamp_minute_above_59_to_59', () {
      expect(QuietTime.clamped(hour: 0, minute: 120).minute, 59);
    });

    test('should_clamp_negative_minute_to_0', () {
      expect(QuietTime.clamped(hour: 0, minute: -1).minute, 0);
    });
  });
}
