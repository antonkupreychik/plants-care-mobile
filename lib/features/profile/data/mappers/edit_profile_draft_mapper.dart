import '../../../../core/api/generated/models/me_response.dart';
import '../../domain/edit_profile_draft.dart';

/// Маппинг `MeResponse` → domain [EditProfileDraft] (MADR-002/007).
///
/// Извлекает поля, доступные для редактирования через `PATCH /api/v1/me`:
/// тихие часы и таймзону. Имя — только для отображения, не отправляется.
extension MeResponseEditProfileMapper on MeResponse {
  EditProfileDraft toEditProfileDraft() => EditProfileDraft(
        displayName: name,
        quietHoursStart: quietHoursStart,
        quietHoursEnd: quietHoursEnd,
        timezone: timezone,
      );
}
