import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/auth/data/auth_repository_provider.dart';
import 'package:plantcare_mobile/features/auth/domain/auth_repository.dart';
import 'package:plantcare_mobile/features/profile/data/profile_repository_provider.dart';
import 'package:plantcare_mobile/features/profile/domain/profile_repository.dart';
import 'package:plantcare_mobile/features/profile/presentation/delete_account_notifier.dart';

class _MockProfileRepo extends Mock implements ProfileRepository {}

class _MockAuthRepo extends Mock implements AuthRepository {}

ProviderContainer _container(
  ProfileRepository profileRepo,
  AuthRepository authRepo,
) {
  final container = ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(profileRepo),
      authRepositoryProvider.overrideWithValue(authRepo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('DeleteAccountNotifier', () {
    test('should_start_with_AsyncData_null', () {
      final container = _container(_MockProfileRepo(), _MockAuthRepo());
      final state = container.read(deleteAccountProvider);
      expect(state, const AsyncData<void>(null));
    });

    test('should_call_signOut_after_successful_deleteAccount', () async {
      final profileRepo = _MockProfileRepo();
      final authRepo = _MockAuthRepo();

      when(profileRepo.deleteAccount)
          .thenAnswer((_) async => const Result.success(null));
      when(authRepo.signOut).thenAnswer((_) async {});

      final container = _container(profileRepo, authRepo);
      final notifier =
          container.read(deleteAccountProvider.notifier);

      await notifier.deleteAccount();

      verify(profileRepo.deleteAccount).called(1);
      verify(authRepo.signOut).called(1);
    });

    test('should_emit_AsyncData_after_success', () async {
      final profileRepo = _MockProfileRepo();
      final authRepo = _MockAuthRepo();

      when(profileRepo.deleteAccount)
          .thenAnswer((_) async => const Result.success(null));
      when(authRepo.signOut).thenAnswer((_) async {});

      final container = _container(profileRepo, authRepo);
      final notifier =
          container.read(deleteAccountProvider.notifier);

      await notifier.deleteAccount();

      final state = container.read(deleteAccountProvider);
      expect(state, isA<AsyncData<void>>());
      expect(state.hasError, isFalse);
    });

    test('should_emit_AsyncError_on_network_failure', () async {
      final profileRepo = _MockProfileRepo();
      final authRepo = _MockAuthRepo();

      when(profileRepo.deleteAccount).thenAnswer(
        (_) async => const Result.failure(ApiError.network()),
      );

      final container = _container(profileRepo, authRepo);
      final notifier =
          container.read(deleteAccountProvider.notifier);

      await notifier.deleteAccount();

      final state = container.read(deleteAccountProvider);
      expect(state.hasError, isTrue);
      expect(state.error, const ApiError.network());
    });

    test('should_NOT_call_signOut_when_deleteAccount_fails', () async {
      final profileRepo = _MockProfileRepo();
      final authRepo = _MockAuthRepo();

      when(profileRepo.deleteAccount).thenAnswer(
        (_) async => const Result.failure(ApiError.unauthorized()),
      );

      final container = _container(profileRepo, authRepo);
      final notifier =
          container.read(deleteAccountProvider.notifier);

      await notifier.deleteAccount();

      verifyNever(authRepo.signOut);
    });

    test('should_emit_AsyncLoading_during_operation', () async {
      final profileRepo = _MockProfileRepo();
      final authRepo = _MockAuthRepo();

      // Delayed response to observe the loading state
      when(profileRepo.deleteAccount).thenAnswer(
        (_) async {
          // Will be observed via listener
          return const Result.success(null);
        },
      );
      when(authRepo.signOut).thenAnswer((_) async {});

      final container = _container(profileRepo, authRepo);
      final notifier =
          container.read(deleteAccountProvider.notifier);

      final states = <AsyncValue<void>>[];
      final sub =
          container.listen(deleteAccountProvider, (_, s) => states.add(s));
      addTearDown(sub.close);

      await notifier.deleteAccount();

      // Состояния: loading → data
      expect(states.any((s) => s.isLoading), isTrue);
      expect(states.last, isA<AsyncData<void>>());
    });

    test(
        'should_emit_AsyncError_and_not_hang_in_loading_when_signOut_throws',
        () async {
      // Регрессионный тест: до фикса #144, если signOut() кидал исключение,
      // state застревал в AsyncLoading — экран зависал навсегда.
      final profileRepo = _MockProfileRepo();
      final authRepo = _MockAuthRepo();

      when(profileRepo.deleteAccount)
          .thenAnswer((_) async => const Result.success(null));
      when(authRepo.signOut)
          .thenThrow(StateError('storage unavailable'));

      final container = _container(profileRepo, authRepo);
      final notifier = container.read(deleteAccountProvider.notifier);

      await notifier.deleteAccount();

      final state = container.read(deleteAccountProvider);
      // Не должно быть AsyncLoading — экран обязан выйти из зависания.
      expect(state.isLoading, isFalse);
      // Должно быть AsyncError — UI покажет снэкбар об ошибке.
      expect(state.hasError, isTrue);
    });
  });
}
