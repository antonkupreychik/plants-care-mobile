import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';

part 'auth_social_state.freezed.dart';

/// Провайдер социального входа, по которому сейчас идёт запрос.
enum SocialProvider { google, apple }

/// Состояние экрана социального входа (кнопки Google / Apple).
///
/// Контракт для ui-builder:
/// - [inProgress] — какой провайдер сейчас в полёте (`null` — простой). UI
///   показывает индикатор на соответствующей кнопке и блокирует обе на время.
/// - [error] — ошибка последней попытки (`null` — ошибки нет). Отмена входа
///   пользователем ошибкой НЕ считается и [error] не выставляет.
@freezed
abstract class AuthSocialState with _$AuthSocialState {
  const factory AuthSocialState({
    /// Провайдер, по которому идёт запрос (`null` — ничего не выполняется).
    SocialProvider? inProgress,

    /// Ошибка последней попытки входа (`null` — ошибки нет).
    ApiError? error,
  }) = _AuthSocialState;

  const AuthSocialState._();

  /// Идёт ли какой-либо запрос (UI блокирует обе кнопки).
  bool get isBusy => inProgress != null;
}
