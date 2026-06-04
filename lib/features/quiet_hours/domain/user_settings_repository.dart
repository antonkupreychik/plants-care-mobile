import '../../../core/error/result.dart';
import 'quiet_time.dart';
import 'user_settings.dart';

/// Контракт data-слоя фичи «Тихие часы и время» (экраны 23/36/37).
///
/// User-scoped (`/api/v1/me`, `Authorization: Bearer` через `AuthSession`).
/// Возвращает `Future<Result<T>>` и НЕ бросает наружу (MADR-011). Все методы
/// записи отдают актуальный [UserSettings] из ответа backend — клиент берёт
/// серверное состояние как источник правды (backend мог пересчитать/нормализовать).
abstract interface class UserSettingsRepository {
  /// Текущие настройки (`GET /api/v1/me` → подмножество для экрана 23).
  Future<Result<UserSettings>> getSettings();

  /// Обновляет тихие часы (`PATCH /api/v1/me`, поля `quietHoursStart`/
  /// `quietHoursEnd`).
  ///
  /// Передаём только изменённые поля (PATCH-семантика): `null`-аргумент =
  /// «не трогать». Backend отклоняет `quietHoursStart == quietHoursEnd` (`400`,
  /// в т.ч. с учётом текущего значения, если передано одно поле) — приходит как
  /// `Result.failure(ApiError)`.
  Future<Result<UserSettings>> updateQuietHours({
    QuietTime? start,
    QuietTime? end,
  });

  /// Обновляет таймзону (`PATCH /api/v1/me`, поле `timezone`).
  ///
  /// [iana] — IANA-идентификатор (`Europe/Moscow`). Невалидный → `400`
  /// (`Result.failure`). Backend сам пересчитывает `next_run_at` расписаний —
  /// клиенту делать ничего не нужно.
  Future<Result<UserSettings>> updateTimezone(String iana);
}
