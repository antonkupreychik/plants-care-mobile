import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/propagation_method.dart';

part 'take_cutting_state.freezed.dart';

/// UI-состояние мастера «Взять черенок» (экран 18).
///
/// Держит введённые пользователем данные ростка ([name], [method], [cutAt]) и
/// статус сабмита ([status]). freezed-immutable, мутируется только через
/// `TakeCuttingController`.
///
/// На сервер из этих полей уходит только имя (плюс `parentPlantId` из
/// аргумента контроллера) — [method] и [cutAt] UI-only (backend-полей пока нет,
/// см. [PropagationMethod]).
@freezed
abstract class TakeCuttingState with _$TakeCuttingState {
  const factory TakeCuttingState({
    /// Имя ростка. Валидируется [isNameValid].
    @Default('') String name,

    /// Выбранный способ размножения (по умолчанию — «в воду»).
    @Default(PropagationMethod.water) PropagationMethod method,

    /// Дата среза черенка (по умолчанию — сегодня, ставится контроллером).
    DateTime? cutAt,

    @Default(TakeCuttingSubmitStatus.idle()) TakeCuttingSubmitStatus status,
  }) = _TakeCuttingState;

  const TakeCuttingState._();

  /// Минимальная длина имени (без учёта пробелов по краям).
  static const int nameMinLength = 1;

  /// Максимальная длина имени (ограничение backend `PlantCreateRequest.name`).
  static const int nameMaxLength = 100;

  /// Имя после trim — то, что уйдёт в `POST /plants`.
  String get trimmedName => name.trim();

  /// Единственное место правды о валидности имени: непустое после trim и
  /// в пределах [nameMinLength]..[nameMaxLength].
  bool get isNameValid {
    final length = trimmedName.length;
    return length >= nameMinLength && length <= nameMaxLength;
  }

  /// Можно ли отправлять: имя валидно и нет активной отправки.
  bool get canSubmit => isNameValid && status is! TakeCuttingSubmitting;
}

/// Статус сабмита мастера (sealed — UI матчит по типу, MADR-011).
@freezed
sealed class TakeCuttingSubmitStatus with _$TakeCuttingSubmitStatus {
  /// Ничего не отправляли / можно редактировать.
  const factory TakeCuttingSubmitStatus.idle() = TakeCuttingIdle;

  /// Идёт `POST /plants` — UI блокирует кнопку, показывает прогресс.
  const factory TakeCuttingSubmitStatus.submitting() = TakeCuttingSubmitting;

  /// Успех — UI навигирует на карточку ростка. [plantId] — id созданной записи.
  const factory TakeCuttingSubmitStatus.success(int plantId) =
      TakeCuttingSuccess;

  /// Ошибка `POST /plants` — росток не создан.
  const factory TakeCuttingSubmitStatus.failure(ApiError error) =
      TakeCuttingFailure;
}
