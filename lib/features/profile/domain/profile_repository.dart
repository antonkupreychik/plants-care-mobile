import '../../../core/error/result.dart';
import 'profile_summary.dart';

/// Доступ к шапке/статистике профиля (`GET /api/v1/me`) и удалению аккаунта
/// (`DELETE /api/v1/me`).
///
/// Возвращает `Result` (MADR-011), наружу не бросает. Реализация — в `data/`.
abstract interface class ProfileRepository {
  /// Загружает сводку профиля текущего пользователя.
  Future<Result<ProfileSummary>> getSummary();

  /// Необратимо удаляет аккаунт текущего пользователя и все связанные данные.
  ///
  /// `DELETE /api/v1/me` идемпотентен (повторный вызов с токеном удалённого
  /// юзера возвращает 204). Caller обязан очистить локальные данные и выйти
  /// на Welcome-экран после успешного вызова.
  Future<Result<void>> deleteAccount();
}
