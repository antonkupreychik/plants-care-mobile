import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';

part 'social_auth_outcome.freezed.dart';

/// Исход социального входа (Google / Apple).
///
/// Отдельный тип от [Result], потому что у соц-входа три исхода, а не два:
/// **отмена пользователем не равна ошибке** — UI на [SocialAuthCancelled]
/// должен молча вернуться, не показывая сообщение. [SocialAuthSuccess] означает,
/// что сессия уже поднята (токены сохранены, auth-флаг выставлен) — router-guard
/// уведёт с экрана входа. [SocialAuthFailure] несёт [ApiError] для показа.
@freezed
sealed class SocialAuthOutcome with _$SocialAuthOutcome {
  const SocialAuthOutcome._();

  /// Вход успешен, сессия поднята.
  const factory SocialAuthOutcome.success() = SocialAuthSuccess;

  /// Пользователь отменил вход (закрыл системный шит). Не ошибка.
  const factory SocialAuthOutcome.cancelled() = SocialAuthCancelled;

  /// Вход не удался (сеть/backend/SDK). [error] — для показа пользователю.
  const factory SocialAuthOutcome.failure(ApiError error) = SocialAuthFailure;
}
