import '../../../core/error/result.dart';
import 'vacation_range.dart';
import 'vacation_status.dart';

/// Контракт data-слоя фичи «Режим отпуска» (экран 25).
///
/// User-scoped (`/api/v1/vacation`, `Authorization: Bearer` через `AuthSession`,
/// MADR-006/008). Возвращает `Future<Result<T>>` и НЕ бросает наружу (MADR-011).
/// Методы записи отдают актуальный [VacationStatus] из ответа backend — клиент
/// берёт серверное состояние как источник правды.
abstract interface class VacationRepository {
  /// Текущее состояние режима отпуска (`GET /api/v1/vacation`).
  Future<Result<VacationStatus>> getStatus();

  /// Включает режим отпуска (`POST /api/v1/vacation` `{from, to}`).
  ///
  /// Идемпотентно: повторный вызов перезаписывает период (продление). Backend
  /// отвергает `to < from` и длительность > 60 дней → `Result.failure`
  /// (`ApiError.badRequest`). Дедлайны backend НЕ переносит — просроченное
  /// копится и показывается в сводке «С возвращением!» (см. спеку).
  Future<Result<VacationStatus>> start(VacationRange range);

  /// Досрочно выключает режим отпуска (`DELETE /api/v1/vacation`).
  ///
  /// Идемпотентно: если отпуск уже неактивен, backend отдаёт `204` без ошибки.
  /// По успеху возвращает неактивный [VacationStatus].
  Future<Result<VacationStatus>> end();
}
