import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/features/push_priming/data/push_priming_repository_provider.dart';
import 'package:plantcare_mobile/features/push_priming/domain/push_priming_decision.dart';
import 'package:plantcare_mobile/features/push_priming/domain/push_priming_repository.dart';
import 'package:plantcare_mobile/features/push_priming/presentation/push_priming_controller.dart';

class _MockRepo extends Mock implements PushPrimingRepository {}

ProviderContainer _container(PushPrimingRepository repo) {
  final container = ProviderContainer(
    overrides: [pushPrimingRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUpAll(() {
    registerFallbackValue(PushPrimingDecision.notDecided);
  });

  group('build', () {
    test('should_expose_stored_decision', () async {
      final repo = _MockRepo();
      when(repo.getDecision)
          .thenAnswer((_) async => PushPrimingDecision.allowed);

      final container = _container(repo);
      final result =
          await container.read(pushPrimingControllerProvider.future);

      expect(result, PushPrimingDecision.allowed);
    });

    test('should_default_to_notDecided_on_first_run', () async {
      final repo = _MockRepo();
      when(repo.getDecision)
          .thenAnswer((_) async => PushPrimingDecision.notDecided);

      final container = _container(repo);

      expect(
        await container.read(pushPrimingControllerProvider.future),
        PushPrimingDecision.notDecided,
      );
    });
  });

  group('allow', () {
    test('should_set_state_to_allowed_and_persist', () async {
      final repo = _MockRepo();
      when(repo.getDecision)
          .thenAnswer((_) async => PushPrimingDecision.notDecided);
      when(() => repo.saveDecision(any())).thenAnswer((_) async {});

      final container = _container(repo);
      await container.read(pushPrimingControllerProvider.future);

      await container.read(pushPrimingControllerProvider.notifier).allow();

      expect(
        container.read(pushPrimingControllerProvider).value,
        PushPrimingDecision.allowed,
      );
      verify(() => repo.saveDecision(PushPrimingDecision.allowed)).called(1);
    });
  });

  group('postpone', () {
    test('should_set_state_to_postponed_and_persist', () async {
      final repo = _MockRepo();
      when(repo.getDecision)
          .thenAnswer((_) async => PushPrimingDecision.notDecided);
      when(() => repo.saveDecision(any())).thenAnswer((_) async {});

      final container = _container(repo);
      await container.read(pushPrimingControllerProvider.future);

      await container.read(pushPrimingControllerProvider.notifier).postpone();

      expect(
        container.read(pushPrimingControllerProvider).value,
        PushPrimingDecision.postponed,
      );
      verify(() => repo.saveDecision(PushPrimingDecision.postponed)).called(1);
    });
  });
}
