import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/new_plant_draft.dart';

part 'add_plant_wizard_state.freezed.dart';

/// UI-состояние мастера добавления растения (экран 04).
///
/// Держит данные черновика ([draft]) и статус сабмита ([status]). Текущий шаг
/// (страница) держит UI/PageController — здесь только данные и статус отправки.
/// freezed-immutable, мутируется только через `AddPlantWizardController`.
@freezed
abstract class AddPlantWizardState with _$AddPlantWizardState {
  const factory AddPlantWizardState({
    @Default(NewPlantDraft()) NewPlantDraft draft,
    @Default(AddPlantSubmitStatus.idle()) AddPlantSubmitStatus status,
  }) = _AddPlantWizardState;

  const AddPlantWizardState._();

  /// Можно ли отправлять: имя валидно (правило в [NewPlantDraft.isNameValid]) и
  /// нет активной отправки. Единственное место правды о готовности к сабмиту.
  bool get canSubmit =>
      draft.isNameValid &&
      status is! AddPlantSubmitting &&
      status is! AddPlantSavingSchedules;
}

/// Статус сабмита мастера (sealed — UI матчит по типу, README §5/MADR-011).
@freezed
sealed class AddPlantSubmitStatus with _$AddPlantSubmitStatus {
  /// Ничего не отправляли / можно редактировать.
  const factory AddPlantSubmitStatus.idle() = AddPlantIdle;

  /// Идёт `POST /plants` — UI блокирует кнопку, показывает прогресс.
  const factory AddPlantSubmitStatus.submitting() = AddPlantSubmitting;

  /// `POST /plants` прошёл, идут `PUT /schedules` для изменённых интервалов.
  const factory AddPlantSubmitStatus.savingSchedules() = AddPlantSavingSchedules;

  /// Успех — UI навигирует на экран расписания. [plantId] — id созданной записи.
  const factory AddPlantSubmitStatus.success(int plantId) = AddPlantSuccess;

  /// Ошибка `POST /plants` — растение не создано.
  const factory AddPlantSubmitStatus.failure(ApiError error) = AddPlantFailure;

  /// Ошибка `PUT /schedules` — растение создано ([plantId]), но интервалы не
  /// применились. UI навигирует на editSchedule, где пользователь настроит их.
  const factory AddPlantSubmitStatus.scheduleFailure({
    required int plantId,
    required ApiError error,
  }) = AddPlantScheduleFailure;
}
