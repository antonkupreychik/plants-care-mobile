import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_code_state.dart';

part 'auth_code_controller.g.dart';

/// State-слой экрана 08 «Ввод кода из Telegram» (визуальная заглушка флоу).
///
/// Держит буфер из 6 цифр и обратный отсчёт до повторной отправки кода. Это
/// ЧИСТЫЙ UI-state: никакой верификации кода, сети, токенов или навигации — их
/// делает UI (по [AuthCodeState.isComplete] рисует активный CTA «Продолжить»).
/// autoDispose: при закрытии экрана буфер и таймер сбрасываются.
///
/// UI читает `ref.watch(authCodeControllerProvider)` ([AuthCodeState]) и зовёт:
/// [appendDigit] / [removeDigit] / [resend].
///
/// **Таймер:** один [Timer.periodic] на 1с, декремент вынесен в [_tick] (тест
/// может прогнать его через fakeAsync детерминированно). Таймер обязательно
/// освобождается в `ref.onDispose` — утечка периодического таймера это реальный
/// баг (тикал бы после ухода с экрана).
@riverpod
class AuthCodeController extends _$AuthCodeController {
  Timer? _timer;

  @override
  AuthCodeState build() {
    ref.onDispose(_cancelTimer);
    _startTimer();
    return const AuthCodeState();
  }

  /// Добавить цифру в код, если он ещё не заполнен и [d] — одиночная цифра.
  /// Нецифровые символы / переполнение игнорируются (no-op).
  void appendDigit(String d) {
    if (state.code.length >= kAuthCodeLength) return;
    if (d.length != 1 || !_isDigit(d)) return;
    state = state.copyWith(code: state.code + d);
  }

  /// Удалить последнюю введённую цифру. Пустой буфер — no-op.
  void removeDigit() {
    final code = state.code;
    if (code.isEmpty) return;
    state = state.copyWith(code: code.substring(0, code.length - 1));
  }

  /// Повторно запросить код: сбрасывает отсчёт до [kAuthResendSeconds] и
  /// перезапускает таймер. Введённые цифры НЕ трогаем (UX: пользователь не
  /// теряет частично набранный код). Если ресенд ещё недоступен — no-op.
  void resend() {
    if (!state.canResend) return;
    state = state.copyWith(resendSeconds: kAuthResendSeconds);
    _startTimer();
  }

  /// Один тик таймера: уменьшает [AuthCodeState.resendSeconds] на 1 и
  /// останавливает таймер, когда дошли до нуля. Вынесен отдельно для
  /// детерминированной проверки отсчёта в тестах.
  void _tick() {
    final next = state.resendSeconds - 1;
    if (next <= 0) {
      state = state.copyWith(resendSeconds: 0);
      _cancelTimer();
      return;
    }
    state = state.copyWith(resendSeconds: next);
  }

  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  bool _isDigit(String s) {
    final code = s.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39; // '0'..'9'
  }
}
