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
  /// отправка не идёт. Единственное место правды о готовности к сабмиту.
  bool get canSubmit => draft.isNameValid && status is! AddPlantSubmitting;
}

/// Статус сабмита мастера (sealed — UI матчит по типу, README §5/MADR-011).
@freezed
sealed class AddPlantSubmitStatus with _$AddPlantSubmitStatus {
  /// Ничего не отправляли / можно редактировать.
  const factory AddPlantSubmitStatus.idle() = AddPlantIdle;

  /// Идёт `POST /plants` — UI блокирует кнопку, показывает прогресс.
  const factory AddPlantSubmitStatus.submitting() = AddPlantSubmitting;

  /// Успех — UI закрывает мастер и навигирует. [plantId] — id созданной записи.
  const factory AddPlantSubmitStatus.success(int plantId) = AddPlantSuccess;

  /// Ошибка — UI рисует баннер/тост по типу [error] (текст через l10n).
  const factory AddPlantSubmitStatus.failure(ApiError error) = AddPlantFailure;
}
