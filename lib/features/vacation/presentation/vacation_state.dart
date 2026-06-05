import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/vacation_range.dart';
import '../domain/vacation_status.dart';

part 'vacation_state.freezed.dart';

/// Состояние экрана 25 «Режим отпуска».
///
/// [status] — подтверждённое backend состояние (`GET /api/v1/vacation`): уже
/// включён отпуск или нет. [range] — выбранный пользователем диапазон дат для
/// включения (редактируемый драфт; при активном отпуске UI показывает текущий
/// период из [status], а [range] — пресет для нового включения).
///
/// [busy] — идёт `POST`/`DELETE` (UI блокирует кнопку). [actionError] — ошибка
/// последнего действия (`null` — нет; напр. backend отверг диапазон → `400`).
@freezed
abstract class VacationState with _$VacationState {
  const factory VacationState({
    /// Подтверждённое backend состояние режима отпуска.
    required VacationStatus status,

    /// Редактируемый диапазон дат для включения отпуска.
    required VacationRange range,

    /// Идёт ли запись (POST/DELETE в полёте).
    @Default(false) bool busy,

    /// Ошибка последнего действия, либо `null`.
    ApiError? actionError,
  }) = _VacationState;

  const VacationState._();

  /// Активен ли режим отпуска сейчас (по данным backend).
  bool get isActive => status.active;

  /// Можно ли отправить выбранный диапазон (предвалидация перед сетью).
  bool get canEnable => range.isValid && !busy;
}
