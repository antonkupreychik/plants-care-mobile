import '../../../core/error/result.dart';
import 'profile_summary.dart';

/// Доступ к шапке/статистике профиля (`GET /api/v1/me`).
///
/// Возвращает `Result` (MADR-011), наружу не бросает. Реализация — в `data/`.
abstract interface class ProfileRepository {
  /// Загружает сводку профиля текущего пользователя.
  Future<Result<ProfileSummary>> getSummary();
}
