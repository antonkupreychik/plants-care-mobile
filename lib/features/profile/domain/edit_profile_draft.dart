import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_draft.freezed.dart';

/// Черновик редактирования профиля пользователя.
///
/// Поля, доступные через `PATCH /api/v1/me`. Имя (`name`) обновляется через
/// отдельный механизм (не через этот эндпоинт), поэтому здесь оно read-only —
/// показываем текущее, но не отправляем. На данный момент через PATCH /me
/// доступны: тихие часы, таймзона, locale.
///
/// Чистый Dart, иммутабельна.
@freezed
abstract class EditProfileDraft with _$EditProfileDraft {
  const factory EditProfileDraft({
    /// Имя — только для отображения (read-only на форме, PATCH /me не меняет имя).
    String? displayName,

    /// Начало тихих часов в формате `HH:mm`.
    required String quietHoursStart,

    /// Конец тихих часов в формате `HH:mm`.
    required String quietHoursEnd,

    /// IANA-идентификатор таймзоны пользователя (например, `Europe/Moscow`).
    required String timezone,
  }) = _EditProfileDraft;
}
