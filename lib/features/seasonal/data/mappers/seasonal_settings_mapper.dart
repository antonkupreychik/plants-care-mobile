import '../../../../core/api/generated/models/me_update_request.dart';
import '../../../../core/api/generated/models/season.dart';
import '../../../../core/api/generated/models/season_settings.dart';
import '../../../../core/api/generated/models/seasonal_settings_response.dart';
import '../../../../core/api/generated/models/seasonal_settings_update_request.dart';
import '../../domain/seasonal_mode.dart';
import '../../domain/seasonal_settings.dart';

/// Маппинг `SeasonalSettingsResponse` → domain [SeasonalSettings] (MADR-002/007).
/// Делаем руками — сгенерированный код не правим.
///
/// Парсит список `seasons` и находит SUMMER/WINTER. Если сезон отсутствует в
/// списке — поле остаётся `null`.
extension SeasonalSettingsResponseMapper on SeasonalSettingsResponse {
  SeasonalSettings toDomain() {
    final summerDto =
        seasons.where((s) => s.season == Season.summer).firstOrNull;
    final winterDto =
        seasons.where((s) => s.season == Season.winter).firstOrNull;

    return SeasonalSettings(
      enabled: enabled,
      mode: SeasonalMode.fromApi(mode.json),
      summer: summerDto?.toDomain(),
      winter: winterDto?.toDomain(),
    );
  }
}

/// Маппинг `SeasonSettings` → domain [SeasonSetting].
extension SeasonSettingsDtoMapper on SeasonSettings {
  SeasonSetting toDomain() => SeasonSetting(
        multiplier: multiplier,
        intervalDays: intervalDays,
      );
}

/// Строит [SeasonalSettingsUpdateRequest] для PATCH /me/seasonal.
SeasonalSettingsUpdateRequest buildUpdateRequest({
  required String seasonApiValue,
  double? multiplier,
  int? intervalDays,
}) =>
    SeasonalSettingsUpdateRequest(
      season: Season.fromJson(seasonApiValue),
      multiplier: multiplier,
      intervalDays: intervalDays,
    );

/// Строит [MeUpdateRequest] для PATCH /me (только поле seasonalEnabled).
MeUpdateRequest buildEnabledRequest(bool enabled) =>
    MeUpdateRequest(seasonalEnabled: enabled);
