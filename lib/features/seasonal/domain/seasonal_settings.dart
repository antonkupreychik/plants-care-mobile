import 'package:freezed_annotation/freezed_annotation.dart';

import 'seasonal_mode.dart';

part 'seasonal_settings.freezed.dart';

/// Доменная модель глобальных настроек авто-подстройки по сезонам (экран 35).
///
/// Источник — `GET /api/v1/me` (`MeResponse`); записываемое подмножество —
/// `PATCH /api/v1/me` (`MeUpdateRequest.seasonalEnabled`). В объёме этой фичи
/// редактируется только тумблер [enabled]; [mode] read-only (показывается как
/// пояснение к тумблеру, отдельной записи режима экран не делает).
///
/// Per-plant сезонные интервалы (`summerIntervalDays`/`winterIntervalDays` из
/// `CareScheduleDto.seasonal`) сюда НЕ входят: они зависят от конкретного
/// растения и его расписания, а это глобальный экран настроек. Интервалы
/// считает backend — клиент их НЕ пересчитывает (FLUTTER.md «Время»).
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
  }) = _SeasonalSettings;

  const SeasonalSettings._();
}
