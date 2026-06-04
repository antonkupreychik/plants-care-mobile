import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/known_timezone.dart';

void main() {
  group('gmtLabel', () {
    test('should_render_positive_whole_hour_offset', () {
      const tz = KnownTimezone(
        ianaId: 'Europe/Moscow',
        city: 'Москва',
        offsetMinutes: 180,
      );

      expect(tz.gmtLabel, 'GMT+3');
    });

    test('should_render_negative_offset_with_minus', () {
      const tz = KnownTimezone(
        ianaId: 'X',
        city: 'X',
        offsetMinutes: -60,
      );

      expect(tz.gmtLabel, 'GMT-1');
    });

    test('should_show_zero_padded_minutes_when_nonzero', () {
      const tz = KnownTimezone(
        ianaId: 'Asia/Kolkata',
        city: 'X',
        offsetMinutes: 330, // +5:30
      );

      expect(tz.gmtLabel, 'GMT+5:30');
    });

    test('should_omit_minutes_when_zero', () {
      const tz = KnownTimezone(
        ianaId: 'X',
        city: 'X',
        offsetMinutes: 600,
      );

      expect(tz.gmtLabel, 'GMT+10');
    });

    test('should_render_GMT_plus_0_for_utc', () {
      const tz = KnownTimezone(ianaId: 'UTC', city: 'X', offsetMinutes: 0);

      expect(tz.gmtLabel, 'GMT+0');
    });
  });

  group('kKnownTimezones', () {
    test('should_have_unique_iana_ids', () {
      final ids = kKnownTimezones.map((tz) => tz.ianaId).toList();

      expect(ids.toSet().length, ids.length);
    });

    test('should_render_expected_gmt_label_for_each_curated_zone', () {
      // Зоны России без DST — метка детерминирована из offsetMinutes.
      const expected = {
        'Europe/Moscow': 'GMT+3',
        'Europe/Kaliningrad': 'GMT+2',
        'Europe/Samara': 'GMT+4',
        'Asia/Yekaterinburg': 'GMT+5',
        'Asia/Novosibirsk': 'GMT+7',
        'Asia/Vladivostok': 'GMT+10',
      };

      for (final tz in kKnownTimezones) {
        expect(tz.gmtLabel, expected[tz.ianaId],
            reason: 'label mismatch for ${tz.ianaId}');
      }
    });

    test('should_list_moscow_first_as_default', () {
      expect(kKnownTimezones.first.ianaId, 'Europe/Moscow');
    });
  });

  group('knownTimezoneById', () {
    test('should_find_existing_zone', () {
      final tz = knownTimezoneById('Asia/Yekaterinburg');

      expect(tz, isNotNull);
      expect(tz!.city, 'Екатеринбург');
      expect(tz.offsetMinutes, 300);
    });

    test('should_return_null_for_unknown_zone', () {
      expect(knownTimezoneById('America/New_York'), isNull);
    });

    test('should_return_null_for_empty_string', () {
      expect(knownTimezoneById(''), isNull);
    });
  });
}
