import 'package:freezed_annotation/freezed_annotation.dart';

import 'seasonal_mode.dart';

part 'seasonal_settings.freezed.dart';

/// Доменная модель настроек одного сезона (лето/зима).
///
/// [multiplier] — коэффициент к базовому интервалу (0.50..1.50).
/// [intervalDays] — фиксированный интервал в днях; `null` означает «не задан,
/// используется базовый интервал растения».
@freezed
abstract class SeasonSetting with _$SeasonSetting {
  const factory SeasonSetting({
    /// Коэффициент к базовому интервалу. Применяется в режиме multiplier.
    required double multiplier,

    /// Фиксированный интервал в днях. `null` — интервал не задан (дефолт).
    int? intervalDays,
  }) = _SeasonSetting;

  const SeasonSetting._();
}

/// Доменная модель глобальных настроек авто-подстройки по сезонам (экран 35).
///
/// Источник — `GET /api/v1/me/seasonal` (`SeasonalSettingsResponse`);
/// тумблер включения меняется через `PATCH /api/v1/me` (`seasonalEnabled`),
/// per-season настройки — через `PATCH /api/v1/me/seasonal`.
/// Сброс сезона к дефолту — `DELETE /api/v1/me/seasonal/{season}`.
///
/// Чистый Dart, иммутабельна.
@freezed
abstract class SeasonalSettings with _$SeasonalSettings {
  const factory SeasonalSettings({
    /// Включена ли авто-подстройка частоты ухода по сезонам (глобально для
    /// пользователя). Тумблер экрана 35.
    required bool enabled,

    /// Режим сезонности (read-only в этой фиче): множитель к интервалу или
    /// фиксированные интервалы на сезон.
    required SeasonalMode mode,

    /// Настройки летнего сезона. Если `null`, то backend не вернул данных для
    /// этого сезона (неожиданный ответ).
    SeasonSetting? summer,

    /// Настройки зимнего сезона. Если `null`, то backend не вернул данных для
    /// этого сезона.
    SeasonSetting? winter,
  }) = _SeasonalSettings;

  const SeasonalSettings._();
}
