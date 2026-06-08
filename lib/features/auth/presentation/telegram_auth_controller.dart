import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../../core/observability/analytics_event.dart';
import '../../../core/observability/observability_providers.dart';
import '../../../core/platform/link_launcher.dart';
import '../data/auth_repository_provider.dart';
import '../domain/telegram_login.dart';
import 'telegram_auth_state.dart';

part 'telegram_auth_controller.g.dart';

/// State-слой экрана 08 «Вход через Telegram».
///
/// Жизненный цикл:
/// 1. `build` → `POST /auth/telegram/start`: создаёт сессию, открывает deep link
///    бота во внешнем приложении ([LinkLauncher]), запускает обратный отсчёт
///    ресенда из `resendAfterSec`. Ошибка старта → фаза `startFailed`.
/// 2. Пользователь вводит цифры ([appendDigit]/[removeDigit]); по заполнению
///    кода контроллер сам зовёт verify ([_verify]).
/// 3. verify-исход ([TelegramVerifyOutcome]) раскладывается:
///    - success → сессия поднята (data-слой), router-guard уводит; состояние не
///      трогаем;
///    - `invalid_code`/`too_many_attempts`/`session_expired` → инлайн-ошибка
///      ([TelegramCodeError]) + сброс буфера; для протухших сессий UI предложит
///      ресенд;
///    - прочее → дженерик-ошибка (как invalidCode по UX: чистим буфер).
///
/// [resend] / [retryStart] перезапускают старт (новый sessionId).
///
/// autoDispose: при уходе с экрана буфер и таймер сбрасываются. Таймер
/// освобождается в `ref.onDispose` (утечка периодического таймера — реальный баг).
///
/// UI читает `ref.watch(telegramAuthControllerProvider)` ([TelegramAuthState]).
@riverpod
class TelegramAuthController extends _$TelegramAuthController {
  Timer? _timer;

  @override
  TelegramAuthState build() {
    ref.onDispose(_cancelTimer);
    // Стартуем после возврата состояния, чтобы build остался синхронным.
    Future.microtask(_start);
    return const TelegramAuthState();
  }

  /// Запустить (или перезапустить) сессию входа: start + открыть deep link.
  Future<void> _start() async {
    _cancelTimer();
    state = state.copyWith(
      phase: TelegramAuthPhase.starting,
      sessionId: null,
      code: '',
      codeError: null,
      startError: null,
      verifying: false,
    );

    final result = await ref.read(authRepositoryProvider).startTelegramLogin();
    // Экран мог быть закрыт за время запроса — не трогаем disposed ref/state.
    if (!ref.mounted) return;
    switch (result) {
      case Success(:final value):
        state = state.copyWith(
          phase: TelegramAuthPhase.entering,
          sessionId: value.sessionId,
          codeLength: value.codeLength,
          resendSeconds: value.resendAfterSec,
          code: '',
          codeError: null,
        );
        _startTimer();
        // Открываем бота во внешнем приложении (best-effort: если не открылось,
        // пользователь всё равно может ввести код вручную из чата).
        await ref.read(linkLauncherProvider).open(value.deepLink);
      case Failure(:final error):
        state = state.copyWith(
          phase: TelegramAuthPhase.startFailed,
          startError: error,
        );
    }
  }

  /// Повторить старт после ошибки (`startFailed`).
  Future<void> retryStart() => _start();

  /// Повторно запросить код: пере-старт сессии (новый sessionId). No-op, если
  /// ресенд недоступен (таймер не досчитал / идёт verify / не в фазе ввода).
  Future<void> resend() async {
    if (!state.canResend) return;
    await _start();
  }

  /// Добавить цифру в код. No-op если идёт verify, код полон, или [d] не цифра.
  /// По заполнению кода автоматически запускает верификацию.
  void appendDigit(String d) {
    if (state.verifying || state.phase != TelegramAuthPhase.entering) return;
    if (state.code.length >= state.codeLength) return;
    if (d.length != 1 || !_isDigit(d)) return;
    // Новый ввод убирает прошлую инлайн-ошибку.
    final next = state.code + d;
    state = state.copyWith(code: next, codeError: null);
    if (next.length == state.codeLength) {
      unawaited(_verify());
    }
  }

  /// Удалить последнюю цифру. No-op во время verify или при пустом буфере.
  void removeDigit() {
    if (state.verifying) return;
    final code = state.code;
    if (code.isEmpty) return;
    state = state.copyWith(
      code: code.substring(0, code.length - 1),
      codeError: null,
    );
  }

  /// Обменять набранный код на сессию.
  Future<void> _verify() async {
    final sessionId = state.sessionId;
    if (sessionId == null || state.verifying) return;
    state = state.copyWith(verifying: true, codeError: null);

    final outcome = await ref.read(authRepositoryProvider).verifyTelegramLogin(
          sessionId: sessionId,
          code: state.code,
        );
    if (!ref.mounted) return;

    switch (outcome) {
      case TelegramVerifySuccess():
        // Сессия поднята в data-слое. Гасим таймер, трекаем, поднимаем флаг
        // succeeded — экран по нему уводит на 09 «С возвращением».
        _cancelTimer();
        ref
            .read(analyticsServiceProvider)
            .track(const UserLoggedIn(method: 'telegram'));
        state = state.copyWith(verifying: false, succeeded: true);
      case TelegramInvalidCode():
        // Сессия жива — чистим буфер, показываем инлайн-ошибку, остаёмся.
        state = state.copyWith(
          verifying: false,
          code: '',
          codeError: TelegramCodeError.invalidCode,
        );
      case TelegramSessionExpired():
        _cancelTimer();
        state = state.copyWith(
          verifying: false,
          code: '',
          resendSeconds: 0,
          codeError: TelegramCodeError.sessionExpired,
        );
      case TelegramTooManyAttempts():
        // Сессия погашена backend — ресенд (новый sessionId) обязателен.
        _cancelTimer();
        state = state.copyWith(
          verifying: false,
          code: '',
          resendSeconds: 0,
          codeError: TelegramCodeError.tooManyAttempts,
        );
      case TelegramUserNotFound():
        // Особый исход: экран по флагу userNotFound уводит на Welcome с текстом
        // про бота (это вход существующих — регистрации в этом флоу нет).
        _cancelTimer();
        state = state.copyWith(
          verifying: false,
          code: '',
          codeError: null,
          userNotFound: true,
        );
      case TelegramVerifyFailure():
        // Дженерик: ведём себя как invalidCode (чистим буфер, инлайн-текст).
        state = state.copyWith(
          verifying: false,
          code: '',
          codeError: TelegramCodeError.invalidCode,
        );
    }
  }

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
    if (state.resendSeconds <= 0) return;
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
