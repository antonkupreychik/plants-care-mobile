import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/season.dart';
import 'package:plantcare_mobile/core/api/generated/models/season_settings.dart';
import 'package:plantcare_mobile/core/api/generated/models/seasonal_settings_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/seasonal_settings_response_mode.dart';
import 'package:plantcare_mobile/features/seasonal/data/mappers/seasonal_settings_mapper.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_mode.dart';

SeasonalSettingsResponse _response({
  bool enabled = true,
  SeasonalSettingsResponseMode mode = SeasonalSettingsResponseMode.multiplier,
  double summerMultiplier = 1.2,
  int? summerInterval,
  double winterMultiplier = 0.7,
  int? winterInterval,
}) =>
    SeasonalSettingsResponse(
      enabled: enabled,
      mode: mode,
      seasons: [
        SeasonSettings(
          season: Season.summer,
          multiplier: summerMultiplier,
          intervalDays: summerInterval,
        ),
        SeasonSettings(
          season: Season.winter,
          multiplier: winterMultiplier,
          intervalDays: winterInterval,
        ),
      ],
    );

void main() {
  group('SeasonalSettingsResponse.toDomain', () {
    test('should_map_enabled_and_multiplier_mode', () {
      final s = _response().toDomain();

      expect(s.enabled, isTrue);
      expect(s.mode, SeasonalMode.multiplier);
    });

    test('should_map_disabled_and_fixed_mode', () {
      final s = _response(
        enabled: false,
        mode: SeasonalSettingsResponseMode.fixed,
      ).toDomain();

      expect(s.enabled, isFalse);
      expect(s.mode, SeasonalMode.fixed);
    });

    test('should_map_unknown_mode_to_unknown', () {
      final s = _response(
        mode: SeasonalSettingsResponseMode.$unknown,
      ).toDomain();

      expect(s.mode, SeasonalMode.unknown);
    });

    test('should_map_summer_multiplier_and_interval', () {
      final s = _response(
        summerMultiplier: 1.3,
        summerInterval: 7,
      ).toDomain();

      expect(s.summer?.multiplier, 1.3);
      expect(s.summer?.intervalDays, 7);
    });

    test('should_map_winter_multiplier_with_null_interval', () {
      final s = _response(winterMultiplier: 0.6).toDomain();

      expect(s.winter?.multiplier, 0.6);
      expect(s.winter?.intervalDays, isNull);
    });

    test('should_have_null_summer_when_season_missing', () {
      final response = SeasonalSettingsResponse(
        enabled: true,
        mode: SeasonalSettingsResponseMode.multiplier,
        // Only winter, no summer
        seasons: [
          const SeasonSettings(
            season: Season.winter,
            multiplier: 0.8,
          ),
        ],
      );

      final s = response.toDomain();

      expect(s.summer, isNull);
      expect(s.winter, isNotNull);
    });
  });

  group('buildUpdateRequest', () {
    test('should_build_summer_request_with_multiplier', () {
      final req = buildUpdateRequest(
        seasonApiValue: 'SUMMER',
        multiplier: 1.25,
      );

      expect(req.season, Season.summer);
      expect(req.multiplier, 1.25);
      expect(req.intervalDays, isNull);
    });

    test('should_build_winter_request_with_interval', () {
      final req = buildUpdateRequest(
        seasonApiValue: 'WINTER',
        intervalDays: 14,
      );

      expect(req.season, Season.winter);
      expect(req.multiplier, isNull);
      expect(req.intervalDays, 14);
    });

    test('unknown_season_value_maps_to_unknown', () {
      final req = buildUpdateRequest(
        seasonApiValue: 'SPRING',
      );

      expect(req.season, Season.$unknown);
    });
  });

  group('buildEnabledRequest', () {
    test('should_set_seasonalEnabled_true', () {
      final req = buildEnabledRequest(true);
      expect(req.seasonalEnabled, isTrue);
    });

    test('should_set_seasonalEnabled_false', () {
      final req = buildEnabledRequest(false);
      expect(req.seasonalEnabled, isFalse);
    });
  });
}
