import '../../../core/error/result.dart';
import 'social_auth_outcome.dart';
import 'telegram_login.dart';

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

  /// Войти через Google: получить OIDC `id_token` нативным SDK и обменять его на
  /// пару JWT (`POST /auth/google`), подняв сессию. Не бросает наружу — исход
  /// (успех / отмена / ошибка) виден в [SocialAuthOutcome].
  Future<SocialAuthOutcome> signInWithGoogle();

  /// Войти через Apple (iOS): получить `identityToken` нативным SDK и обменять
  /// его на пару JWT (`POST /auth/apple`), подняв сессию. Не бросает наружу —
  /// исход виден в [SocialAuthOutcome].
  Future<SocialAuthOutcome> signInWithApple();

  /// Выйти: отозвать refresh-токен (best-effort) и погасить локальную сессию.
  /// Идемпотентно, наружу не бросает — локальная сессия чистится в любом случае.
  Future<void> signOut();

  /// Гостевой вход (`POST /auth/guest`).
  ///
  /// Генерирует `deviceId` (UUID v4) если не сохранён, сохраняет в secure
  /// storage по ключу `guest_device_id`, затем вызывает эндпоинт и поднимает
  /// сессию. Повторный вызов использует тот же `deviceId`.
  Future<Result<void>> signInAsGuest();

  /// Восстановить гостевую сессию при запуске.
  ///
  /// Если нет валидных токенов НО есть `guest_device_id` в secure storage —
  /// вызывает `POST /auth/guest { deviceId }` и поднимает сессию.
  /// Возвращает `true` если сессия восстановлена, `false` если не применимо
  /// (нет deviceId или уже есть токены).
  Future<bool> tryRestoreGuestSession();

  /// Конвертировать гостевой аккаунт через email magic-link.
  ///
  /// Вызывает `POST /auth/guest/convert { provider: EMAIL, email }`. Backend
  /// отправит magic-link. После верификации ссылки через [verifyMagicLink]
  /// токены обновятся и `isGuest` станет `false`.
  Future<Result<void>> convertGuestWithEmail(String email);

  /// Конвертировать гостевой аккаунт через Google.
  ///
  /// Получает OIDC id_token нативным SDK и вызывает
  /// `POST /auth/guest/convert { provider: GOOGLE, idToken }`.
  /// По успеху поднимает новую сессию с обновлёнными токенами.
  Future<SocialAuthOutcome> convertGuestWithGoogle();

  /// Конвертировать гостевой аккаунт через Apple.
  ///
  /// Получает identityToken нативным SDK и вызывает
  /// `POST /auth/guest/convert { provider: APPLE, idToken }`.
  /// По успеху поднимает новую сессию с обновлёнными токенами.
  Future<SocialAuthOutcome> convertGuestWithApple();

  /// Начать вход через Telegram (`POST /auth/telegram/start`).
  ///
  /// Создаёт одноразовую сессию входа и возвращает [TelegramStartSession]
  /// (`sessionId`, `deepLink` на бота, `codeLength`, `resendAfterSec`). Сессию
  /// НЕ поднимает — это лишь старт. Публичный запрос (без bearer). При ошибке —
  /// `Result.failure(ApiError)` (наружу не бросает).
  Future<Result<TelegramStartSession>> startTelegramLogin();

  /// Подтвердить код входа Telegram (`POST /auth/telegram/verify`).
  ///
  /// По [sessionId] (из [startTelegramLogin]) и введённому [code] обменивает их
  /// на пару JWT и поднимает сессию. Доменно-значимые ветви backend
  /// (`invalid_code`/`session_expired`/`too_many_attempts`/
  /// `telegram_user_not_found`) возвращаются как [TelegramVerifyOutcome], не
  /// бросаются. По [TelegramVerifySuccess] сессия уже поднята (router-guard
  /// уведёт с экрана входа).
  Future<TelegramVerifyOutcome> verifyTelegramLogin({
    required String sessionId,
    required String code,
  });
}
