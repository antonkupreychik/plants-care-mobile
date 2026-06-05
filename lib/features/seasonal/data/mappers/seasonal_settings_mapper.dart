import '../../../../core/api/generated/models/me_response.dart';
import '../../domain/seasonal_mode.dart';
import '../../domain/seasonal_settings.dart';

/// Маппинг `MeResponse` → domain [SeasonalSettings] (MADR-002/007). Делаем
/// руками — сгенерированный код не правим.
///
/// Берёт ТОЛЬКО подмножество `/me`, нужное экрану 35: `seasonalEnabled` (флаг
/// авто-подстройки) и `seasonalMode` (enum → доменный [SeasonalMode]).
/// Остальные поля `MeResponse` (счётчики, тихие часы, погода, *Linked)
/// игнорируются.
extension MeResponseSeasonalMapper on MeResponse {
  SeasonalSettings toSeasonalSettings() => SeasonalSettings(
        enabled: seasonalEnabled,
        // `seasonalMode` — сгенерированный enum; берём backend-строку через
        // `.json` (null для `$unknown` → доменный unknown).
        mode: SeasonalMode.fromApi(seasonalMode.json),
      );
}
