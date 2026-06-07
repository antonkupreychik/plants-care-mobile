import '../../../core/error/result.dart';
import 'edit_profile_draft.dart';
import 'profile_summary.dart';

/// Доступ к шапке/статистике профиля (`GET /api/v1/me`) и удалению аккаунта
/// (`DELETE /api/v1/me`).
///
/// Возвращает `Result` (MADR-011), наружу не бросает. Реализация — в `data/`.
abstract interface class ProfileRepository {
  /// Загружает сводку профиля текущего пользователя.
  Future<Result<ProfileSummary>> getSummary();

  /// Загружает черновик редактирования профиля из `GET /api/v1/me`.
  ///
  /// Возвращает поля, доступные для редактирования (тихие часы, таймзона),
  /// и отображаемое имя (read-only).
  Future<Result<EditProfileDraft>> getEditDraft();

  /// Обновляет настройки профиля (`PATCH /api/v1/me`).
  ///
  /// PATCH-семантика: обновляются только переданные поля. Возвращает
  /// обновлённую [ProfileSummary] для последующей инвалидации провайдера.
  Future<Result<ProfileSummary>> updateProfile(EditProfileDraft draft);

  /// Необратимо удаляет аккаунт текущего пользователя и все связанные данные.
  ///
  /// `DELETE /api/v1/me` идемпотентен (повторный вызов с токеном удалённого
  /// юзера возвращает 204). Caller обязан очистить локальные данные и выйти
  /// на Welcome-экран после успешного вызова.
  Future<Result<void>> deleteAccount();
}
