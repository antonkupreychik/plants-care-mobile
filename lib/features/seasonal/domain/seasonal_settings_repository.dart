import '../../../core/error/result.dart';
import 'seasonal_settings.dart';

/// Контракт data-слоя фичи «Сезонные интервалы» (экран 35).
///
/// User-scoped (`/api/v1/me`, `Authorization: Bearer` через `AuthSession`).
/// Возвращает `Future<Result<T>>` и НЕ бросает наружу (MADR-011). Запись отдаёт
/// актуальный [SeasonalSettings] из ответа backend — клиент берёт серверное
/// состояние как источник правды (backend мог нормализовать).
abstract interface class SeasonalSettingsRepository {
  /// Текущие сезонные настройки (`GET /api/v1/me` → подмножество для экрана 35).
  Future<Result<SeasonalSettings>> getSettings();

  /// Включает/выключает авто-подстройку по сезонам (`PATCH /api/v1/me`, поле
  /// `seasonalEnabled`). Остальные поля `/me` не трогаются (PATCH-семантика).
  Future<Result<SeasonalSettings>> setEnabled(bool enabled);
}
