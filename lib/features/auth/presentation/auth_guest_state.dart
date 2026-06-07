import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';

part 'auth_guest_state.freezed.dart';

/// Состояние кнопки «Продолжить без аккаунта».
@freezed
abstract class AuthGuestState with _$AuthGuestState {
  const factory AuthGuestState({
    /// Идёт ли запрос гостевого входа.
    @Default(false) bool isLoading,

    /// Ошибка последней попытки (`null` — ошибки нет).
    ApiError? error,
  }) = _AuthGuestState;
}
