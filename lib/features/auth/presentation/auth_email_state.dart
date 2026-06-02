import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';

part 'auth_email_state.freezed.dart';

/// Состояние экрана запроса magic link (ввод email).
///
/// Контракт для ui-builder: рисуем поле по [email], кнопку гейтим по
/// [canSubmit], в полёте — [submitting], при [linkSent] показываем экран
/// «проверьте почту», [error] (если есть) — текст ошибки последней отправки.
@freezed
abstract class AuthEmailState with _$AuthEmailState {
  const factory AuthEmailState({
    @Default('') String email,

    /// Идёт ли запрос magic link (UI блокирует кнопку/поле).
    @Default(false) bool submitting,

    /// Ошибка последней отправки (`null` — ошибки нет).
    ApiError? error,

    /// Письмо отправлено — UI переключается на «проверьте почту».
    @Default(false) bool linkSent,
  }) = _AuthEmailState;

  const AuthEmailState._();

  /// Грубая валидация формата email (не RFC-полная — достаточно для UX-гейта
  /// кнопки; финальную проверку делает backend).
  bool get isValidEmail =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

  /// Можно ли отправлять: валидный email и нет запроса в полёте.
  bool get canSubmit => isValidEmail && !submitting;
}
