import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/edit_profile_draft.dart';

part 'edit_profile_state.freezed.dart';

/// Статус отправки формы редактирования профиля.
enum EditProfileSubmitStatus { idle, submitting, success, failure }

/// Состояние экрана «Редактировать профиль».
///
/// [initial] — исходный черновик (загружен из `GET /api/v1/me`).
/// [draft] — текущий редактируемый черновик.
/// [submitStatus] — статус отправки PATCH /me.
/// [submitError] — ошибка последнего сохранения (`null` — ошибки нет).
///
/// «Сохранить» активно только если `isDirty && isValid`.
@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    required EditProfileDraft initial,
    required EditProfileDraft draft,
    @Default(EditProfileSubmitStatus.idle) EditProfileSubmitStatus submitStatus,
    ApiError? submitError,
  }) = _EditProfileState;

  const EditProfileState._();

  /// Есть ли изменения относительно исходного черновика.
  bool get isDirty =>
      draft.quietHoursStart != initial.quietHoursStart ||
      draft.quietHoursEnd != initial.quietHoursEnd ||
      draft.timezone != initial.timezone;

  /// Поля валидны: тихие часы заполнены и корректны (`HH:mm`).
  bool get isValid {
    final timeRe = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
    return timeRe.hasMatch(draft.quietHoursStart) &&
        timeRe.hasMatch(draft.quietHoursEnd) &&
        draft.quietHoursStart != draft.quietHoursEnd &&
        draft.timezone.isNotEmpty;
  }

  /// «Сохранить» активна: есть изменения и данные валидны.
  bool get canSave => isDirty && isValid;

  /// Идёт ли отправка.
  bool get isSubmitting => submitStatus == EditProfileSubmitStatus.submitting;
}
