import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/edit_plant_draft.dart';

part 'edit_plant_state.freezed.dart';

/// Статус отправки формы редактирования.
enum SubmitStatus { idle, submitting, success, failure }

/// Состояние экрана «Редактировать растение» (presentation-слой).
///
/// [initial] — исходный черновик (загружен из текущего [PlantDetail]).
/// [draft] — текущий редактируемый черновик.
/// [submitStatus] — статус отправки.
/// [submitError] — ошибка последнего сохранения (`null` — ошибки нет).
///
/// Грязность ([isDirty]) — наличие изменений относительно [initial].
/// «Сохранить» активно только если `isDirty && isNameValid`.
@freezed
abstract class EditPlantState with _$EditPlantState {
  const factory EditPlantState({
    required EditPlantDraft initial,
    required EditPlantDraft draft,
    @Default(SubmitStatus.idle) SubmitStatus submitStatus,
    ApiError? submitError,
  }) = _EditPlantState;

  const EditPlantState._();

  /// Есть ли изменения относительно исходного черновика.
  bool get isDirty =>
      draft.name.trim() != initial.name.trim() ||
      (draft.notes?.trim() ?? '') != (initial.notes?.trim() ?? '') ||
      draft.locationId != initial.locationId ||
      draft.speciesId != initial.speciesId;

  /// Имя валидно: не пустое, не длиннее 100 символов.
  bool get isNameValid =>
      draft.name.trim().isNotEmpty && draft.name.trim().length <= 100;

  /// «Сохранить» активна: есть изменения и имя валидно.
  bool get canSave => isDirty && isNameValid;

  /// Идёт ли отправка.
  bool get isSubmitting => submitStatus == SubmitStatus.submitting;
}
