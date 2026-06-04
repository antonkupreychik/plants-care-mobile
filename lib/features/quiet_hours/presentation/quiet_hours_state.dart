import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/user_settings.dart';

part 'quiet_hours_state.freezed.dart';

/// Состояние экрана «Тихие часы и время» (23).
///
/// Стратегия — «draft + save», как в `edit_schedule`: держим ДВА снимка —
/// [loaded] (последнее подтверждённое backend состояние, база для dirty/отката)
/// и [draft] (текущий редактируемый). UI правит [draft] (пикер времени, выбор
/// таймзоны); «грязность» вычисляется на лету ([isDirty]). По сохранению
/// контроллер PATCH'ит только изменённое и по успеху делает `loaded = ответ
/// сервера` (с серверной нормализацией), грязь исчезает.
///
/// [saving] — идёт PATCH (UI блокирует кнопку/пикер). [saveError] — ошибка
/// последнего сохранения (`null` — нет; напр. backend отверг
/// `quietHoursStart == quietHoursEnd` → `ApiError.badRequest`).
@freezed
abstract class QuietHoursState with _$QuietHoursState {
  const factory QuietHoursState({
    /// Последнее подтверждённое backend состояние (база для dirty/отката).
    required UserSettings loaded,

    /// Текущий редактируемый драфт (то, что показывает UI).
    required UserSettings draft,

    /// Идёт ли сохранение (PATCH в полёте).
    @Default(false) bool saving,

    /// Ошибка последнего сохранения, либо `null`.
    ApiError? saveError,
  }) = _QuietHoursState;

  const QuietHoursState._();

  /// Изменены ли тихие часы в [draft] относительно [loaded].
  bool get isQuietHoursDirty =>
      draft.quietHoursStart != loaded.quietHoursStart ||
      draft.quietHoursEnd != loaded.quietHoursEnd;

  /// Изменена ли таймзона в [draft] относительно [loaded].
  bool get isTimezoneDirty => draft.timezone != loaded.timezone;

  /// Есть ли несохранённые изменения (UI активирует «Сохранить»).
  bool get isDirty => isQuietHoursDirty || isTimezoneDirty;
}
