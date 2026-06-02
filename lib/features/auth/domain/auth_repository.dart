import '../../../core/error/result.dart';

/// Контракт data-слоя авторизации по email magic-link (MADR-008).
///
/// Флоу: [requestMagicLink] шлёт письмо со ссылкой → пользователь открывает
/// ссылку (deep link с `token`) → [verifyMagicLink] обменивает токен на пару
/// JWT и поднимает сессию. [signOut] отзывает refresh и гасит сессию.
///
/// Запросы публичные (без bearer): тело несёт всё нужное. Методы возвращают
/// `Future<Result<void>>` и НЕ бросают наружу — ошибки backend/сети приходят
/// как [ApiError] в `Failure` (MADR-011). [signOut] best-effort и не падает,
/// поэтому без `Result`. Реализация скрыта в data; presentation зависит только
/// от этого интерфейса (MADR-002).
abstract interface class AuthRepository {
  /// Запросить magic link (`POST /auth/email/request`).
  ///
  /// Backend всегда отвечает `202` (анти-enumeration), поэтому success тут не
  /// означает «пользователь существует» — лишь «письмо поставлено в очередь».
  Future<Result<void>> requestMagicLink(String email);

  /// Обменять токен из письма на пару JWT (`POST /auth/email/verify`) и поднять
  /// сессию. По успеху сессия аутентифицирована (токены сохранены, auth-флаг
  /// поднят). Токен одноразовый: повторный обмен вернёт ошибку.
  Future<Result<void>> verifyMagicLink(String token);

  /// Выйти: отозвать refresh-токен (best-effort) и погасить локальную сессию.
  /// Идемпотентно, наружу не бросает — локальная сессия чистится в любом случае.
  Future<void> signOut();
}
