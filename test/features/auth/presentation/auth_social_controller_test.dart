import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/features/auth/data/auth_repository_provider.dart';
import 'package:plantcare_mobile/features/auth/domain/auth_repository.dart';
import 'package:plantcare_mobile/features/auth/domain/social_auth_outcome.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_social_controller.dart';
import 'package:plantcare_mobile/features/auth/presentation/auth_social_state.dart';

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

  group('initial', () {
    test('should_start_idle_without_progress_or_error', () {
      final container = _container(repo);

      final state = container.read(authSocialControllerProvider);

      expect(state.inProgress, isNull);
      expect(state.error, isNull);
      expect(state.isBusy, isFalse);
    });
  });

  group('google', () {
    test('should_clear_progress_and_keep_error_null_on_success', () async {
      when(() => repo.signInWithGoogle())
          .thenAnswer((_) async => const SocialAuthOutcome.success());
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      await notifier.google();

      final state = container.read(authSocialControllerProvider);
      expect(state.inProgress, isNull);
      expect(state.error, isNull);
      verify(() => repo.signInWithGoogle()).called(1);
    });

    test('should_stay_silent_on_cancelled', () async {
      when(() => repo.signInWithGoogle())
          .thenAnswer((_) async => const SocialAuthOutcome.cancelled());
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      await notifier.google();

      final state = container.read(authSocialControllerProvider);
      // Отмена — не ошибка: error остаётся null, прогресс погашен.
      expect(state.error, isNull);
      expect(state.inProgress, isNull);
    });

    test('should_surface_error_on_failure', () async {
      when(() => repo.signInWithGoogle()).thenAnswer(
          (_) async => const SocialAuthOutcome.failure(ApiError.network()));
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      await notifier.google();

      final state = container.read(authSocialControllerProvider);
      expect(state.error, const ApiError.network());
      expect(state.inProgress, isNull);
    });

    test('should_mark_google_in_progress_and_busy_while_running', () async {
      final completer = Completer<SocialAuthOutcome>();
      when(() => repo.signInWithGoogle()).thenAnswer((_) => completer.future);
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      final pending = notifier.google();

      final mid = container.read(authSocialControllerProvider);
      expect(mid.inProgress, SocialProvider.google);
      expect(mid.isBusy, isTrue);

      completer.complete(const SocialAuthOutcome.success());
      await pending;

      expect(container.read(authSocialControllerProvider).isBusy, isFalse);
    });

    test('should_be_noop_when_already_busy', () async {
      final completer = Completer<SocialAuthOutcome>();
      when(() => repo.signInWithGoogle()).thenAnswer((_) => completer.future);
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      final first = notifier.google();
      // Второй вызов пока первый в полёте — должен быть проигнорирован.
      await notifier.google();

      verify(() => repo.signInWithGoogle()).called(1);

      completer.complete(const SocialAuthOutcome.success());
      await first;
    });
  });

  group('apple', () {
    test('should_clear_progress_and_keep_error_null_on_success', () async {
      when(() => repo.signInWithApple())
          .thenAnswer((_) async => const SocialAuthOutcome.success());
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      await notifier.apple();

      final state = container.read(authSocialControllerProvider);
      expect(state.inProgress, isNull);
      expect(state.error, isNull);
      verify(() => repo.signInWithApple()).called(1);
    });

    test('should_stay_silent_on_cancelled', () async {
      when(() => repo.signInWithApple())
          .thenAnswer((_) async => const SocialAuthOutcome.cancelled());
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      await notifier.apple();

      final state = container.read(authSocialControllerProvider);
      expect(state.error, isNull);
      expect(state.inProgress, isNull);
    });

    test('should_surface_error_on_failure', () async {
      when(() => repo.signInWithApple()).thenAnswer((_) async =>
          const SocialAuthOutcome.failure(ApiError.badRequest(message: 'x')));
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      await notifier.apple();

      final state = container.read(authSocialControllerProvider);
      expect(state.error, const ApiError.badRequest(message: 'x'));
      expect(state.inProgress, isNull);
    });

    test('should_mark_apple_in_progress_and_busy_while_running', () async {
      final completer = Completer<SocialAuthOutcome>();
      when(() => repo.signInWithApple()).thenAnswer((_) => completer.future);
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      final pending = notifier.apple();

      final mid = container.read(authSocialControllerProvider);
      expect(mid.inProgress, SocialProvider.apple);
      expect(mid.isBusy, isTrue);

      completer.complete(const SocialAuthOutcome.success());
      await pending;

      expect(container.read(authSocialControllerProvider).isBusy, isFalse);
    });

    test('should_be_noop_when_already_busy', () async {
      final completer = Completer<SocialAuthOutcome>();
      when(() => repo.signInWithApple()).thenAnswer((_) => completer.future);
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);

      final first = notifier.apple();
      await notifier.apple();

      verify(() => repo.signInWithApple()).called(1);

      completer.complete(const SocialAuthOutcome.success());
      await first;
    });

    test('should_clear_previous_error_when_new_attempt_starts', () async {
      // Сначала ошибка...
      when(() => repo.signInWithApple()).thenAnswer((_) async =>
          const SocialAuthOutcome.failure(ApiError.network()));
      final container = _container(repo);
      final notifier = container.read(authSocialControllerProvider.notifier);
      await notifier.apple();
      expect(container.read(authSocialControllerProvider).error, isNotNull);

      // ...затем успешный повтор — старая ошибка должна уйти.
      when(() => repo.signInWithApple())
          .thenAnswer((_) async => const SocialAuthOutcome.success());
      await notifier.apple();

      expect(container.read(authSocialControllerProvider).error, isNull);
    });
  });
}
