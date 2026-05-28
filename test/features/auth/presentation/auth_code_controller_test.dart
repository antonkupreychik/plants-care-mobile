import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_code_controller.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_code_state.dart';

/// Создаёт контейнер с авто-диспоузом по завершении теста. Использовать ВНУТРИ
/// `fakeAsync`-зоны для таймерных кейсов: build() контроллера стартует
/// `Timer.periodic`, который иначе зависнет реальный event loop.
ProviderContainer _container() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

AuthCodeState _read(ProviderContainer c) =>
    c.read(authCodeControllerProvider);

AuthCodeController _notifier(ProviderContainer c) =>
    c.read(authCodeControllerProvider.notifier);

void main() {
  group('appendDigit', () {
    test('should_grow_code_when_single_digit_appended', () {
      fakeAsync((_) {
        final c = _container();

        _notifier(c)
          ..appendDigit('1')
          ..appendDigit('2')
          ..appendDigit('3');

        expect(_read(c).code, '123');
        expect(_read(c).isComplete, isFalse);
      });
    });

    test('should_set_isComplete_when_six_digits_entered', () {
      fakeAsync((_) {
        final c = _container();
        final n = _notifier(c);

        for (final d in const ['1', '2', '3', '4', '5', '6']) {
          n.appendDigit(d);
        }

        expect(_read(c).code, '123456');
        expect(_read(c).isComplete, isTrue);
      });
    });

    test('should_ignore_seventh_digit_when_already_full', () {
      fakeAsync((_) {
        final c = _container();
        final n = _notifier(c);
        for (final d in const ['1', '2', '3', '4', '5', '6']) {
          n.appendDigit(d);
        }

        n.appendDigit('7');

        expect(_read(c).code, '123456');
        expect(_read(c).isComplete, isTrue);
      });
    });

    test('should_be_noop_when_non_digit_char', () {
      fakeAsync((_) {
        final c = _container();

        _notifier(c).appendDigit('a');

        expect(_read(c).code, '');
      });
    });

    test('should_be_noop_when_multi_char_string', () {
      fakeAsync((_) {
        final c = _container();

        _notifier(c).appendDigit('12');

        expect(_read(c).code, '');
      });
    });
  });

  group('removeDigit', () {
    test('should_drop_last_digit', () {
      fakeAsync((_) {
        final c = _container();
        final n = _notifier(c)
          ..appendDigit('1')
          ..appendDigit('2');

        n.removeDigit();

        expect(_read(c).code, '1');
      });
    });

    test('should_be_noop_when_code_empty', () {
      fakeAsync((_) {
        final c = _container();

        _notifier(c).removeDigit();

        expect(_read(c).code, '');
      });
    });
  });

  group('resend timer', () {
    test('should_start_at_full_seconds_and_block_resend', () {
      fakeAsync((_) {
        final c = _container();

        final state = _read(c);

        expect(state.resendSeconds, kAuthResendSeconds);
        expect(state.canResend, isFalse);
      });
    });

    test('should_decrement_each_second', () {
      fakeAsync((async) {
        final c = _container();
        // Подписка нужна, чтобы AutoDispose-нотифаер жил, пока крутим таймер.
        final sub = c.listen(authCodeControllerProvider, (_, _) {});
        addTearDown(sub.close);

        async.elapse(const Duration(seconds: 3));

        expect(_read(c).resendSeconds, kAuthResendSeconds - 3);
        expect(_read(c).canResend, isFalse);
      });
    });

    test('should_reach_zero_and_allow_resend_after_full_countdown', () {
      fakeAsync((async) {
        final c = _container();
        final sub = c.listen(authCodeControllerProvider, (_, _) {});
        addTearDown(sub.close);

        async.elapse(const Duration(seconds: kAuthResendSeconds));

        expect(_read(c).resendSeconds, 0);
        expect(_read(c).canResend, isTrue);
      });
    });

    test('should_not_go_below_zero_when_elapsed_beyond_countdown', () {
      fakeAsync((async) {
        final c = _container();
        final sub = c.listen(authCodeControllerProvider, (_, _) {});
        addTearDown(sub.close);

        async.elapse(const Duration(seconds: kAuthResendSeconds + 30));

        expect(_read(c).resendSeconds, 0);
      });
    });

    test('should_reset_countdown_when_resend_while_allowed', () {
      fakeAsync((async) {
        final c = _container();
        final sub = c.listen(authCodeControllerProvider, (_, _) {});
        addTearDown(sub.close);
        async.elapse(const Duration(seconds: kAuthResendSeconds));
        expect(_read(c).canResend, isTrue);

        _notifier(c).resend();

        expect(_read(c).resendSeconds, kAuthResendSeconds);
        expect(_read(c).canResend, isFalse);

        // И таймер снова тикает после ресенда.
        async.elapse(const Duration(seconds: 1));
        expect(_read(c).resendSeconds, kAuthResendSeconds - 1);
      });
    });

    test('should_be_noop_when_resend_called_before_countdown_ends', () {
      fakeAsync((async) {
        final c = _container();
        final sub = c.listen(authCodeControllerProvider, (_, _) {});
        addTearDown(sub.close);
        async.elapse(const Duration(seconds: 5));
        expect(_read(c).canResend, isFalse);
        final before = _read(c).resendSeconds;

        _notifier(c).resend();

        // Отсчёт не подскочил обратно к 60.
        expect(_read(c).resendSeconds, before);
        expect(before, lessThan(kAuthResendSeconds));
      });
    });
  });

  group('dispose', () {
    test('should_stop_timer_and_not_throw_after_container_disposed', () {
      fakeAsync((async) {
        final container = ProviderContainer();
        final sub = container.listen(authCodeControllerProvider, (_, _) {});
        async.elapse(const Duration(seconds: 2));
        expect(
          container.read(authCodeControllerProvider).resendSeconds,
          kAuthResendSeconds - 2,
        );

        sub.close();
        container.dispose();

        // Таймер отменён в onDispose: дальнейший elapse не должен ни тикать,
        // ни кидать (нет утечки периодического таймера).
        expect(() => async.elapse(const Duration(seconds: 5)), returnsNormally);
      });
    });
  });
}
