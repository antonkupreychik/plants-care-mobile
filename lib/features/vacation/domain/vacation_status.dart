import 'package:freezed_annotation/freezed_annotation.dart';

part 'vacation_status.freezed.dart';

/// Состояние режима отпуска (`GET /api/v1/vacation` → `VacationResponse`).
///
/// [active] — режим включён сейчас. [pausedUntil] — момент (UTC), до которого
/// напоминания приостановлены; `null`, если отпуск неактивен. Backend —
/// источник правды: «активен» = `pausedUntil != null && pausedUntil > now`,
/// клиент сам это не пересчитывает (FLUTTER.md «Время»), показывает как пришло.
///
/// Чистый Dart, иммутабелен.
@freezed
abstract class VacationStatus with _$VacationStatus {
  const factory VacationStatus({
    /// Включён ли режим отпуска сейчас.
    required bool active,

    /// Момент окончания паузы (UTC). `null`, если отпуск неактивен.
    DateTime? pausedUntil,
  }) = _VacationStatus;

  const VacationStatus._();

  /// Неактивный режим — удобный конструктор для дефолтного/сброшенного состояния.
  static const VacationStatus inactive = VacationStatus(active: false);
}
