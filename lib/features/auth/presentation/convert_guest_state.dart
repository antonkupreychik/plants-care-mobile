import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';

part 'convert_guest_state.freezed.dart';

/// Провайдер конвертации, по которому сейчас идёт запрос.
enum ConvertProvider { email, google, apple }

/// Статус конвертации гостевого аккаунта.
enum ConvertStatus {
  /// Начальное состояние — ничего не происходит.
  idle,

  /// Email magic-link отправлен — показываем состояние «проверьте почту».
  emailSent,

  /// Конвертация завершена (GOOGLE/APPLE).
  converted,
}

/// Состояние экрана конвертации гостевого аккаунта.
@freezed
abstract class ConvertGuestState with _$ConvertGuestState {
  const factory ConvertGuestState({
    /// Провайдер, по которому сейчас идёт запрос (`null` — простой).
    ConvertProvider? inProgress,

    /// Статус конвертации.
    @Default(ConvertStatus.idle) ConvertStatus status,

    /// Email, введённый пользователем (для отображения «письмо отправлено на…»).
    @Default('') String email,

    /// Ошибка последней попытки (`null` — ошибки нет).
    ApiError? error,
  }) = _ConvertGuestState;

  const ConvertGuestState._();

  /// Идёт ли какой-либо запрос.
  bool get isBusy => inProgress != null;
}
