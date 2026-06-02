import '../../../core/error/result.dart';
import 'notification_feed.dart';

/// Контракт data-слоя ленты уведомлений (экраны 24 / 32, backend G17).
///
/// Два действия: прочитать страницу ленты (пагинация) и отметить уведомление
/// прочитанным. Возвращают `Future<Result<T>>` и НЕ бросают наружу (MADR-011).
/// Идентичность пользователя backend резолвит из bearer-токена (`sub`) — здесь
/// она не передаётся (см. `AuthInterceptor`, MADR-008).
abstract interface class NotificationsRepository {
  /// Страница ленты (`GET /api/v1/notifications`).
  /// [limit] — размер страницы (backend требует диапазон [1, 100]);
  /// [offset] — сдвиг от начала выборки (≥ 0).
  Future<Result<NotificationFeed>> getFeed({
    int limit,
    int offset,
  });

  /// Отметить уведомление прочитанным (`POST /api/v1/notifications/{id}/read`).
  /// Идемпотентно (повторный вызов — no-op); чужое/несуществующее — 404.
  Future<Result<void>> markRead(int id);
}
