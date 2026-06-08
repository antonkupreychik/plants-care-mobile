import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/seasonal/data/seasonal_settings_repository_provider.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_mode.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_settings.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_settings_repository.dart';
import 'package:plantcare_mobile/features/seasonal/presentation/seasonal_controller.dart';

class _MockRepo extends Mock implements SeasonalSettingsRepository {}

SeasonalSettings _settings({
  bool enabled = false,
  SeasonalMode mode = SeasonalMode.multiplier,
}) =>
    SeasonalSettings(enabled: enabled, mode: mode);

ProviderContainer _container(SeasonalSettingsRepository repo) {
  final container = ProviderContainer(
    overrides: [seasonalSettingsRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  void stubLoad(_MockRepo repo, SeasonalSettings loaded) {
    when(() => repo.getSettings())
        .thenAnswer((_) async => Result.success(loaded));
  }

  group('build', () {
    test('should_load_settings_into_state', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings(enabled: true));
      final container = _container(repo);

      final state = await container.read(seasonalControllerProvider.future);

      expect(state.settings.enabled, isTrue);
      expect(state.settings.mode, SeasonalMode.multiplier);
      expect(state.saving, isFalse);
      expect(state.saveError, isNull);
    });

    test('should_emit_AsyncError_when_load_fails', () async {
      final repo = _MockRepo();
      when(() => repo.getSettings())
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);

      // Ловим ошибку через подписку (а не await .future): иначе провайдер
      // диспознется в loading-состоянии до проброса ошибки.
      final completer = Completer<Object?>();
      final sub = container.listen(
        seasonalControllerProvider,
        (_, next) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        },
      );
      addTearDown(sub.close);

      expect(await completer.future, const ApiError.network());
    });
  });

  group('toggle', () {
    test('should_commit_server_state_on_success', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings(enabled: false));
      when(() => repo.setEnabled(true))
          .thenAnswer((_) async => Result.success(_settings(enabled: true)));
      final container = _container(repo);
      await container.read(seasonalControllerProvider.future);

      final error = await container
          .read(seasonalControllerProvider.notifier)
          .toggle(true);

      expect(error, isNull);
      final state = container.read(seasonalControllerProvider).requireValue;
      expect(state.settings.enabled, isTrue);
      expect(state.saving, isFalse);
      expect(state.saveError, isNull);
      verify(() => repo.setEnabled(true)).called(1);
    });

    test('should_rollback_and_set_error_on_failure', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings(enabled: false));
      when(() => repo.setEnabled(true))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);
      await container.read(seasonalControllerProvider.future);

      final error = await container
          .read(seasonalControllerProvider.notifier)
          .toggle(true);

      expect(error, isA<ApiError>());
      final state = container.read(seasonalControllerProvider).requireValue;
      // Откат к прежнему значению (выключено) и saveError выставлен.
      expect(state.settings.enabled, isFalse);
      expect(state.saving, isFalse);
      expect(state.saveError, isA<ApiError>());
    });

    test('should_be_noop_when_value_unchanged', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings(enabled: true));
      final container = _container(repo);
      await container.read(seasonalControllerProvider.future);

      final error = await container
          .read(seasonalControllerProvider.notifier)
          .toggle(true);

      expect(error, isNull);
      verifyNever(() => repo.setEnabled(any()));
    });
  });

  group('resetSeason', () {
    test('should_commit_server_state_on_success', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings(enabled: true));
      when(() => repo.resetSeason(seasonApiValue: 'SUMMER'))
          .thenAnswer((_) async => Result.success(_settings(enabled: true)));
      final container = _container(repo);
      await container.read(seasonalControllerProvider.future);

      final error = await container
          .read(seasonalControllerProvider.notifier)
          .resetSeason('SUMMER');

      expect(error, isNull);
      final state = container.read(seasonalControllerProvider).requireValue;
      expect(state.saving, isFalse);
      expect(state.saveError, isNull);
      verify(() => repo.resetSeason(seasonApiValue: 'SUMMER')).called(1);
    });

    test('should_rollback_and_set_error_on_failure', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings(enabled: true));
      when(() => repo.resetSeason(seasonApiValue: 'WINTER'))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);
      await container.read(seasonalControllerProvider.future);

      final error = await container
          .read(seasonalControllerProvider.notifier)
          .resetSeason('WINTER');

      expect(error, isA<ApiError>());
      final state = container.read(seasonalControllerProvider).requireValue;
      expect(state.saving, isFalse);
      expect(state.saveError, isA<ApiError>());
    });

    test('should_be_noop_when_saving', () async {
      final repo = _MockRepo();
      stubLoad(repo, _settings(enabled: true));
      final container = _container(repo);
      // Manually set saving=true via toggle (block with a never-completing future).
      when(() => repo.setEnabled(false))
          .thenAnswer((_) async {
        await Future<void>.delayed(const Duration(seconds: 10));
        return const Result.failure(ApiError.network());
      });
      await container.read(seasonalControllerProvider.future);

      // Start toggle (sets saving=true).
      unawaited(
        container.read(seasonalControllerProvider.notifier).toggle(false),
      );

      // resetSeason should be no-op while saving.
      final error = await container
          .read(seasonalControllerProvider.notifier)
          .resetSeason('SUMMER');

      expect(error, isNull);
      verifyNever(() => repo.resetSeason(seasonApiValue: any(named: 'seasonApiValue')));
    });
  });
}
