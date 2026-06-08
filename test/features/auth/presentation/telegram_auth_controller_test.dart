import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/platform/link_launcher.dart';
import 'package:plantcare_mobile/features/auth/data/auth_repository_provider.dart';
import 'package:plantcare_mobile/features/auth/domain/auth_repository.dart';
import 'package:plantcare_mobile/features/auth/domain/telegram_login.dart';
import 'package:plantcare_mobile/features/auth/presentation/telegram_auth_controller.dart';
import 'package:plantcare_mobile/features/auth/presentation/telegram_auth_state.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

class _FakeLinkLauncher implements LinkLauncher {
  final List<String> opened = [];
  @override
  Future<bool> open(String url) async {
    opened.add(url);
    return true;
  }
}

const _session = TelegramStartSession(
  sessionId: 's-1',
  deepLink: 'https://t.me/PlantCareBot?start=auth_s-1',
  codeLength: 6,
  resendAfterSec: 60,
);

ProviderContainer _container(AuthRepository repo, LinkLauncher launcher) {
  final c = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      linkLauncherProvider.overrideWithValue(launcher),
    ],
  );
  addTearDown(c.dispose);
  // Держим autoDispose-контроллер живым на время теста (иначе он диспоузится
  // между read'ами и microtask(_start) бьётся в disposed ref).
  c.listen(telegramAuthControllerProvider, (_, _) {});
  return c;
}

/// Стандартный happy-path старт: repo.start → success(_session).
void _stubStartSuccess(_MockAuthRepo repo) {
  when(repo.startTelegramLogin)
      .thenAnswer((_) async => const Result.success(_session));
}

void _stubVerify(_MockAuthRepo repo, TelegramVerifyOutcome outcome) {
  when(() => repo.verifyTelegramLogin(
        sessionId: any(named: 'sessionId'),
        code: any(named: 'code'),
      )).thenAnswer((_) async => outcome);
}

/// Вводит цифры [code] (по одной), прогоняя микротаски между ними.
Future<void> _enter(
  TelegramAuthController notifier,
  String code,
) async {
  for (final ch in code.split('')) {
    notifier.appendDigit(ch);
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late _MockAuthRepo repo;
  late _FakeLinkLauncher launcher;

  setUp(() {
    repo = _MockAuthRepo();
    launcher = _FakeLinkLauncher();
  });

  group('start', () {
    test('should_enter_code_phase_and_open_deep_link_on_start_success',
        () async {
      _stubStartSuccess(repo);
      final container = _container(repo, launcher);
      // Триггерим build контроллера (он сам стартует _start через microtask).
      container.read(telegramAuthControllerProvider.notifier);

      // Дать microtask(_start) отработать.
      await Future<void>.delayed(Duration.zero);

      final s = container.read(telegramAuthControllerProvider);
      expect(s.phase, TelegramAuthPhase.entering);
      expect(s.sessionId, 's-1');
      expect(s.codeLength, 6);
      expect(s.resendSeconds, 60);
      expect(launcher.opened, contains(_session.deepLink));
    });

    test('should_enter_start_failed_phase_on_start_error', () async {
      when(repo.startTelegramLogin)
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo, launcher);
      container.read(telegramAuthControllerProvider.notifier);

      await Future<void>.delayed(Duration.zero);

      final s = container.read(telegramAuthControllerProvider);
      expect(s.phase, TelegramAuthPhase.startFailed);
      expect(s.startError, const ApiError.network());
      expect(launcher.opened, isEmpty);
    });

    test('should_restart_session_on_retryStart', () async {
      when(repo.startTelegramLogin)
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo, launcher);
      final notifier = container.read(telegramAuthControllerProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(telegramAuthControllerProvider).phase,
          TelegramAuthPhase.startFailed);

      _stubStartSuccess(repo);
      await notifier.retryStart();

      expect(container.read(telegramAuthControllerProvider).phase,
          TelegramAuthPhase.entering);
    });
  });

  group('verify branches', () {
    Future<(ProviderContainer, TelegramAuthController)> ready(
      TelegramVerifyOutcome outcome,
    ) async {
      _stubStartSuccess(repo);
      _stubVerify(repo, outcome);
      final container = _container(repo, launcher);
      final notifier = container.read(telegramAuthControllerProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      return (container, notifier);
    }

    test('should_set_succeeded_on_success', () async {
      final (container, notifier) =
          await ready(const TelegramVerifyOutcome.success());

      await _enter(notifier, '123456');

      final s = container.read(telegramAuthControllerProvider);
      expect(s.succeeded, isTrue);
      expect(s.verifying, isFalse);
      verify(() => repo.verifyTelegramLogin(sessionId: 's-1', code: '123456'))
          .called(1);
    });

    test('should_clear_code_and_flag_invalidCode_on_invalid_code', () async {
      final (container, notifier) =
          await ready(const TelegramVerifyOutcome.invalidCode());

      await _enter(notifier, '000000');

      final s = container.read(telegramAuthControllerProvider);
      expect(s.codeError, TelegramCodeError.invalidCode);
      expect(s.code, isEmpty);
      expect(s.succeeded, isFalse);
    });

    test('should_flag_sessionExpired_and_allow_resend', () async {
      final (container, notifier) =
          await ready(const TelegramVerifyOutcome.sessionExpired());

      await _enter(notifier, '111111');

      final s = container.read(telegramAuthControllerProvider);
      expect(s.codeError, TelegramCodeError.sessionExpired);
      expect(s.resendSeconds, 0);
      expect(s.canResend, isTrue);
    });

    test('should_flag_tooManyAttempts_and_allow_resend', () async {
      final (container, notifier) =
          await ready(const TelegramVerifyOutcome.tooManyAttempts());

      await _enter(notifier, '222222');

      final s = container.read(telegramAuthControllerProvider);
      expect(s.codeError, TelegramCodeError.tooManyAttempts);
      expect(s.canResend, isTrue);
    });

    test('should_set_userNotFound_on_telegram_user_not_found', () async {
      final (container, notifier) =
          await ready(const TelegramVerifyOutcome.userNotFound());

      await _enter(notifier, '333333');

      final s = container.read(telegramAuthControllerProvider);
      expect(s.userNotFound, isTrue);
      expect(s.succeeded, isFalse);
    });

    test('should_treat_generic_failure_like_invalidCode', () async {
      final (container, notifier) = await ready(
          const TelegramVerifyOutcome.failure(ApiError.unknown()));

      await _enter(notifier, '444444');

      final s = container.read(telegramAuthControllerProvider);
      expect(s.codeError, TelegramCodeError.invalidCode);
      expect(s.code, isEmpty);
    });

    test('should_clear_inline_error_when_typing_resumes', () async {
      final (container, notifier) =
          await ready(const TelegramVerifyOutcome.invalidCode());
      await _enter(notifier, '000000');
      expect(container.read(telegramAuthControllerProvider).codeError,
          isNotNull);

      notifier.appendDigit('7');
      await Future<void>.delayed(Duration.zero);

      expect(
          container.read(telegramAuthControllerProvider).codeError, isNull);
      expect(container.read(telegramAuthControllerProvider).code, '7');
    });
  });

  group('digit input', () {
    test('should_ignore_non_digits_and_overflow', () async {
      _stubStartSuccess(repo);
      _stubVerify(repo, const TelegramVerifyOutcome.invalidCode());
      final container = _container(repo, launcher);
      final notifier = container.read(telegramAuthControllerProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      notifier.appendDigit('a');
      notifier.appendDigit('!');
      expect(container.read(telegramAuthControllerProvider).code, isEmpty);
    });

    test('should_remove_last_digit_on_removeDigit', () async {
      _stubStartSuccess(repo);
      final container = _container(repo, launcher);
      final notifier = container.read(telegramAuthControllerProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      notifier.appendDigit('1');
      notifier.appendDigit('2');
      notifier.removeDigit();

      expect(container.read(telegramAuthControllerProvider).code, '1');
    });
  });

  group('resend timer', () {
    test('should_count_down_from_resendAfterSec_to_zero', () {
      fakeAsync((async) {
        _stubStartSuccess(repo);
        final container = _container(repo, launcher);
        container.read(telegramAuthControllerProvider.notifier);
        // microtask(_start) + завершение мокнутого старта.
        async.flushMicrotasks();

        expect(container.read(telegramAuthControllerProvider).resendSeconds, 60);
        expect(container.read(telegramAuthControllerProvider).canResend, isFalse);

        async.elapse(const Duration(seconds: 60));

        final s = container.read(telegramAuthControllerProvider);
        expect(s.resendSeconds, 0);
        expect(s.canResend, isTrue);
      });
    });

    test('should_be_noop_resend_before_timer_elapses', () async {
      _stubStartSuccess(repo);
      final container = _container(repo, launcher);
      final notifier = container.read(telegramAuthControllerProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      // Таймер ещё идёт (60с) — resend игнорируется (старт не зовётся повторно).
      await notifier.resend();

      verify(repo.startTelegramLogin).called(1);
    });
  });
}
