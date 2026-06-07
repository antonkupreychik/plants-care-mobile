import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_locale.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_seasonal_mode.dart';
import 'package:plantcare_mobile/features/quiet_hours/data/mappers/user_settings_mapper.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/quiet_time.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_locale.dart';

MeResponse _me({
  String quietStart = '22:00',
  String quietEnd = '08:00',
  String timezone = 'Europe/Moscow',
  MeResponseLocale locale = MeResponseLocale.ru,
}) =>
    MeResponse(
      id: 1,
      emailVerified: true,
      createdAt: DateTime.utc(2026, 1, 1),
      name: 'Test',
      plantsTotal: 0,
      tasksToday: 0,
      totalCareEvents: 0,
      notificationsUnread: 0,
      quietHoursStart: quietStart,
      quietHoursEnd: quietEnd,
      timezone: timezone,
      locale: locale,
      seasonalEnabled: false,
      seasonalMode: MeResponseSeasonalMode.multiplier,
      weatherEnabled: false,
      featureFlags: null,
      appleLinked: false,
      googleLinked: false,
      emailLinked: false,
      telegramLinked: false,
      isGuest: false,
    );

void main() {
  group('toUserSettings', () {
    test('should_map_quiet_hours_timezone_and_locale', () {
      final settings = _me().toUserSettings();

      expect(settings.quietHoursStart, const QuietTime(hour: 22, minute: 0));
      expect(settings.quietHoursEnd, const QuietTime(hour: 8, minute: 0));
      expect(settings.timezone, 'Europe/Moscow');
      expect(settings.locale, UserLocale.ru);
    });

    test('should_map_en_locale', () {
      final settings = _me(locale: MeResponseLocale.en).toUserSettings();

      expect(settings.locale, UserLocale.en);
    });

    test('should_fallback_to_midnight_when_start_unparseable', () {
      final settings = _me(quietStart: 'garbage').toUserSettings();

      // Защита от мусора с backend: невалидное HH:mm → 00:00, не краш.
      expect(settings.quietHoursStart, const QuietTime(hour: 0, minute: 0));
      // Валидный end остаётся как есть.
      expect(settings.quietHoursEnd, const QuietTime(hour: 8, minute: 0));
    });

    test('should_fallback_to_midnight_when_end_unparseable', () {
      final settings = _me(quietEnd: '99:99').toUserSettings();

      expect(settings.quietHoursEnd, const QuietTime(hour: 0, minute: 0));
    });

    test('should_keep_raw_iana_timezone_unmodified', () {
      // Таймзона не из курируемого списка проходит как есть (raw IANA).
      final settings = _me(timezone: 'America/New_York').toUserSettings();

      expect(settings.timezone, 'America/New_York');
    });

    // Не-UTC таймзона: маппинг времени дня НЕ зависит от смещения зоны и от TZ
    // системы-раннера. QuietTime — локальное «HH:mm», не Instant.
    test('should_not_shift_quiet_time_for_non_utc_timezone', () {
      final settings = _me(
        timezone: 'Asia/Almaty', // UTC+5
        quietStart: '22:00',
        quietEnd: '08:00',
      ).toUserSettings();

      // 22:00 остаётся 22:00 независимо от смещения зоны (никакого UTC-сдвига).
      expect(settings.quietHoursStart.hour, 22);
      expect(settings.quietHoursStart.minute, 0);
      expect(settings.quietHoursEnd.hour, 8);
      expect(settings.timezone, 'Asia/Almaty');
    });
  });
}
