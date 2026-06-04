import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_locale.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_seasonal_mode.dart';
import 'package:plantcare_mobile/features/seasonal/data/mappers/seasonal_settings_mapper.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_mode.dart';

MeResponse _me({
  bool seasonalEnabled = true,
  MeResponseSeasonalMode mode = MeResponseSeasonalMode.multiplier,
}) =>
    MeResponse(
      id: 1,
      emailVerified: true,
      createdAt: DateTime.utc(2026),
      name: 'Test',
      plantsTotal: 3,
      tasksToday: 0,
      notificationsUnread: 0,
      quietHoursStart: '22:00',
      quietHoursEnd: '08:00',
      timezone: 'Europe/Moscow',
      locale: MeResponseLocale.ru,
      seasonalEnabled: seasonalEnabled,
      seasonalMode: mode,
      weatherEnabled: false,
      featureFlags: const <String, dynamic>{},
      appleLinked: false,
      googleLinked: false,
      emailLinked: false,
      telegramLinked: true,
    );

void main() {
  group('MeResponse.toSeasonalSettings', () {
    test('should_map_enabled_and_multiplier_mode', () {
      final s = _me().toSeasonalSettings();

      expect(s.enabled, isTrue);
      expect(s.mode, SeasonalMode.multiplier);
    });

    test('should_map_disabled_and_fixed_mode', () {
      final s = _me(
        seasonalEnabled: false,
        mode: MeResponseSeasonalMode.fixed,
      ).toSeasonalSettings();

      expect(s.enabled, isFalse);
      expect(s.mode, SeasonalMode.fixed);
    });

    test('should_map_unknown_mode_to_unknown', () {
      final s =
          _me(mode: MeResponseSeasonalMode.$unknown).toSeasonalSettings();

      expect(s.mode, SeasonalMode.unknown);
    });
  });
}
