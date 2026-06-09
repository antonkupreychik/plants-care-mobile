import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';

part 'telegram_login.freezed.dart';

/// Результат старта Telegram-входа (`POST /api/v1/auth/telegram/start`).
///
/// Несёт всё, что нужно экрану 08 для шага ввода кода: [sessionId] (пойдёт в
/// verify), [deepLink] на бота (открываем во внешнем приложении), [codeLength]
/// (сколько ячеек рисовать) и [resendAfterSec] (старт обратного отсчёта до
/// повторного запроса кода). Чистый Dart, иммутабелен.
@freezed
abstract class TelegramStartSession with _$TelegramStartSession {
  const factory TelegramStartSession({
    required String sessionId,
    required String deepLink,
    required int codeLength,
    required int resendAfterSec,
  }) = _TelegramStartSession;
}

/// Исход проверки кода Telegram (`POST /api/v1/auth/telegram/verify`).
///
/// Отдельный sealed-тип (а не [Result]/[ApiError]), потому что у verify есть
/// несколько доменно-значимых ветвей, которые экран 08 обрабатывает по-разному
/// (а не «ошибка/успех»): неверный код оставляет на экране и чистит буфер,
/// истёкшая сессия требует пере-старта, «нет аккаунта» уводит на Welcome с
/// текстом про бота. Backend кодирует их в `error.code` (см. `auth.yaml`):
/// `invalid_code` (401), `session_expired` (410), `too_many_attempts` (429),
/// `telegram_user_not_found` (404). [TelegramVerifyFailure] несёт прочие ошибки
/// (сеть/5xx) как [ApiError] для общего текста.
@freezed
sealed class TelegramVerifyOutcome with _$TelegramVerifyOutcome {
  const TelegramVerifyOutcome._();

  /// Код принят, сессия поднята (токены сохранены, auth-флаг выставлен).
  const factory TelegramVerifyOutcome.success() = TelegramVerifySuccess;

  /// `invalid_code` (401) — код не совпал. Сессия жива, можно ввести заново.
  const factory TelegramVerifyOutcome.invalidCode() = TelegramInvalidCode;

  /// `session_expired` (410) — сессия истекла/не существует. Нужен пере-старт.
  const factory TelegramVerifyOutcome.sessionExpired() =
      TelegramSessionExpired;

  /// `too_many_attempts` (429) — лимит попыток исчерпан, сессия погашена.
  const factory TelegramVerifyOutcome.tooManyAttempts() =
      TelegramTooManyAttempts;

  /// `telegram_user_not_found` (404) — к Telegram-аккаунту не привязан юзер.
  const factory TelegramVerifyOutcome.userNotFound() = TelegramUserNotFound;

  /// Прочая ошибка (сеть/5xx/нераспознанная). [error] — для общего текста.
  const factory TelegramVerifyOutcome.failure(ApiError error) =
      TelegramVerifyFailure;
}
