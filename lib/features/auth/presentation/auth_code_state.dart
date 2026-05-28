import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_code_state.freezed.dart';

/// Длина кода подтверждения из Telegram.
const int kAuthCodeLength = 6;

/// Стартовое значение обратного отсчёта до повторной отправки кода (секунды).
const int kAuthResendSeconds = 60;

/// UI-состояние экрана 08 «Ввод кода из Telegram» (визуальная заглушка).
///
/// Держит только буфер введённых цифр ([code]) и обратный отсчёт до ресенда
/// ([resendSeconds]). Никакого auth/сети/токена — это чистый UI-таймер плюс
/// буфер ввода; верификацию/переходы делает не этот слой (см.
/// `AuthCodeController`). freezed-immutable, мутируется только через контроллер.
@freezed
abstract class AuthCodeState with _$AuthCodeState {
  const factory AuthCodeState({
    /// Введённые цифры, длина 0..[kAuthCodeLength]. Только символы '0'..'9'.
    @Default('') String code,

    /// Секунд до возможности нажать «Отправить снова». 0 → можно ресендить.
    @Default(kAuthResendSeconds) int resendSeconds,
  }) = _AuthCodeState;

  const AuthCodeState._();

  /// Код введён полностью — UI показывает активный CTA «Продолжить».
  bool get isComplete => code.length == kAuthCodeLength;

  /// Можно повторно запросить код (таймер досчитал до нуля).
  bool get canResend => resendSeconds == 0;
}
