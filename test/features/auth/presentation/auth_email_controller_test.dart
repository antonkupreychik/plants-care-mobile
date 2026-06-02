import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/auth/data/auth_repository_provider.dart';
import 'package:plantcare_mobile/features/auth/domain/auth_repository.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_email_controller.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

ProviderContainer _container(AuthRepository repo) {
  final c = ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  late _MockAuthRepo repo;

  setUp(() {
    repo = _MockAuthRepo();
  });

  group('email validation', () {
    test('should_start_with_empty_invalid_state', () {
      final container = _container(repo);

      final state = container.read(authEmailControllerProvider);

      expect(state.email, '');
      expect(state.isValidEmail, isFalse);
      expect(state.canSubmit, isFalse);
      expect(state.linkSent, isFalse);
    });

    test('should_reject_malformed_and_accept_well_formed_email', () {
      final container = _container(repo);
      final notifier = container.read(authEmailControllerProvider.notifier);

      notifier.setEmail('not-an-email');
      expect(container.read(authEmailControllerProvider).isValidEmail, isFalse);
      expect(container.read(authEmailControllerProvider).canSubmit, isFalse);

      notifier.setEmail('user@example.com');
      expect(container.read(authEmailControllerProvider).isValidEmail, isTrue);
      expect(container.read(authEmailControllerProvider).canSubmit, isTrue);
    });

    test('should_clear_previous_error_when_email_re_entered', () async {
      when(() => repo.requestMagicLink(any()))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);
      final notifier = container.read(authEmailControllerProvider.notifier);

      notifier.setEmail('user@example.com');
      await notifier.submit();
      expect(container.read(authEmailControllerProvider).error, isNotNull);

      // Новый ввод — повод повторить: ошибка сбрасывается.
      notifier.setEmail('user2@example.com');
      expect(container.read(authEmailControllerProvider).error, isNull);
    });
  });

  group('submit', () {
    test('should_set_linkSent_when_request_succeeds', () async {
      when(() => repo.requestMagicLink(any()))
          .thenAnswer((_) async => const Result.success(null));
      final container = _container(repo);
      final notifier = container.read(authEmailControllerProvider.notifier);

      notifier.setEmail('user@example.com');
      await notifier.submit();

      final state = container.read(authEmailControllerProvider);
      expect(state.linkSent, isTrue);
      expect(state.submitting, isFalse);
      expect(state.error, isNull);
      verify(() => repo.requestMagicLink('user@example.com')).called(1);
    });

    test('should_set_error_and_not_linkSent_when_request_fails', () async {
      when(() => repo.requestMagicLink(any()))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);
      final notifier = container.read(authEmailControllerProvider.notifier);

      notifier.setEmail('user@example.com');
      await notifier.submit();

      final state = container.read(authEmailControllerProvider);
      expect(state.error, const ApiError.network());
      expect(state.linkSent, isFalse);
      expect(state.submitting, isFalse);
    });

    test('should_be_noop_when_email_invalid', () async {
      final container = _container(repo);
      final notifier = container.read(authEmailControllerProvider.notifier);

      // Невалидный email → submit ничего не делает, репозиторий не зван.
      notifier.setEmail('broken');
      await notifier.submit();

      verifyNever(() => repo.requestMagicLink(any()));
      expect(container.read(authEmailControllerProvider).linkSent, isFalse);
      expect(container.read(authEmailControllerProvider).submitting, isFalse);
    });
  });
}
