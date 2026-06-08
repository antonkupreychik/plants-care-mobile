import '../../../core/error/result.dart';
import 'seasonal_settings.dart';

/// Контракт data-слоя фичи «Сезонные настройки» (экран 35).
///
/// User-scoped (`/api/v1/me/seasonal`, `Authorization: Bearer`).
/// Возвращает `Future<Result<T>>` и НЕ бросает наружу (MADR-011). Запись отдаёт
/// актуальный [SeasonalSettings] из ответа backend — клиент берёт серверное
/// состояние как источник правды (backend мог нормализовать).
abstract interface class SeasonalSettingsRepository {
  /// Текущие сезонные настройки (`GET /api/v1/me/seasonal`).
  Future<Result<SeasonalSettings>> getSettings();

  /// Включает/выключает авто-подстройку по сезонам (`PATCH /api/v1/me`, поле
  /// `seasonalEnabled`). Остальные поля `/me` не трогаются (PATCH-семантика).
  Future<Result<SeasonalSettings>> setEnabled(bool enabled);

  /// Устанавливает multiplier и/или intervalDays для сезона
  /// (`PATCH /api/v1/me/seasonal`).
  ///
  /// [seasonApiValue] — 'SUMMER' | 'WINTER' (значение из API).
  /// [multiplier] и [intervalDays] — опциональны (null = не трогать).
  Future<Result<SeasonalSettings>> updateSeason({
    required String seasonApiValue,
    double? multiplier,
    int? intervalDays,
  });

  /// Сбрасывает фиксированный интервал сезона в `null`
  /// (`DELETE /api/v1/me/seasonal/{season}`).
  ///
  /// [seasonApiValue] — 'SUMMER' | 'WINTER' (значение из API).
  Future<Result<SeasonalSettings>> resetSeason({required String seasonApiValue});
}
