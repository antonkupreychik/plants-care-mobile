import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/vacation/data/vacation_repository_provider.dart';
import 'package:plantcare_mobile/features/vacation/domain/vacation_range.dart';
import 'package:plantcare_mobile/features/vacation/domain/vacation_repository.dart';
import 'package:plantcare_mobile/features/vacation/domain/vacation_status.dart';
import 'package:plantcare_mobile/features/vacation/presentation/vacation_controller.dart';

class _MockRepo extends Mock implements VacationRepository {}

class _FakeRange extends Fake implements VacationRange {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

// Фиксируем «сейчас» в UTC; «сегодня» для дефолтного диапазона контроллер
// берёт в локальной зоне теста (`toLocal()`) — поэтому ожидаемую дату считаем
// тем же преобразованием, а не хардкодим (тест-зона может быть не UTC).
final _nowUtc = DateTime.utc(2026, 6, 1, 22);
DateTime get _expectedToday {
  final local = _nowUtc.toLocal();
  return DateTime(local.year, local.month, local.day);
}

ProviderContainer _container(VacationRepository repo) {
  final container = ProviderContainer(
    overrides: [
      vacationRepositoryProvider.overrideWithValue(repo),
      clockProvider.overrideWithValue(_FixedClock(_nowUtc)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRange());
  });

  void stubLoad(_MockRepo repo, VacationStatus status) {
    when(() => repo.getStatus())
        .thenAnswer((_) async => Result.success(status));
  }

  group('build', () {
    test('should_load_status_and_init_default_14_day_range', () async {
      final repo = _MockRepo();
      stubLoad(repo, VacationStatus.inactive);
      final container = _container(repo);

      final state = await container.read(vacationControllerProvider.future);

      expect(state.isActive, isFalse);
      expect(state.range.days, 14);
      expect(state.busy, isFalse);
      expect(state.actionError, isNull);
      // Начало — «сегодня» в локальной зоне теста.
      expect(state.range.from, _expectedToday);
    });

    test('should_reflect_active_status', () async {
      final repo = _MockRepo();
      stubLoad(
        repo,
        VacationStatus(
          active: true,
          pausedUntil: DateTime.utc(2026, 6, 14, 20, 59, 59),
        ),
      );
      final container = _container(repo);

      final state = await container.read(vacationControllerProvider.future);

      expect(state.isActive, isTrue);
      expect(state.status.pausedUntil, DateTime.utc(2026, 6, 14, 20, 59, 59));
    });

    test('should_emit_AsyncError_when_load_fails', () async {
      final repo = _MockRepo();
      when(() => repo.getStatus())
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);

      final completer = Completer<Object?>();
      final sub = container.listen(
        vacationControllerProvider,
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

  group('setFrom / setTo', () {
    test('should_clamp_to_when_from_moves_past_it', () async {
      final repo = _MockRepo();
      stubLoad(repo, VacationStatus.inactive);
      final container = _container(repo);
      await container.read(vacationControllerProvider.future);

      final notifier = container.read(vacationControllerProvider.notifier);
      notifier.setFrom(DateTime(2026, 7, 1)); // далеко за дефолтным `to`

      final state = container.read(vacationControllerProvider).value!;
      expect(state.range.from, DateTime(2026, 7, 1));
      // `to` подтянулся к `from` (диапазон не вывернут).
      expect(state.range.to, DateTime(2026, 7, 1));
    });

    test('should_clamp_from_when_to_moves_before_it', () async {
      final repo = _MockRepo();
      stubLoad(repo, VacationStatus.inactive);
      final container = _container(repo);
      await container.read(vacationControllerProvider.future);

      final notifier = container.read(vacationControllerProvider.notifier);
      notifier.setTo(DateTime(2026, 5, 1)); // раньше `from` (1 июня)

      final state = container.read(vacationControllerProvider).value!;
      expect(state.range.to, DateTime(2026, 5, 1));
      expect(state.range.from, DateTime(2026, 5, 1));
    });

    test('should_drop_time_component', () async {
      final repo = _MockRepo();
      stubLoad(repo, VacationStatus.inactive);
      final container = _container(repo);
      await container.read(vacationControllerProvider.future);

      final notifier = container.read(vacationControllerProvider.notifier);
      notifier.setFrom(DateTime(2026, 6, 5, 17, 42));

      final state = container.read(vacationControllerProvider).value!;
      expect(state.range.from, DateTime(2026, 6, 5));
    });
  });

  group('enable', () {
    test('should_post_range_and_apply_returned_status', () async {
      final repo = _MockRepo();
      stubLoad(repo, VacationStatus.inactive);
      when(() => repo.start(any())).thenAnswer(
        (_) async => Result.success(
          VacationStatus(
            active: true,
            pausedUntil: DateTime.utc(2026, 6, 14, 20, 59, 59),
          ),
        ),
      );
      final container = _container(repo);
      await container.read(vacationControllerProvider.future);

      final notifier = container.read(vacationControllerProvider.notifier);
      final error = await notifier.enable();

      expect(error, isNull);
      final state = container.read(vacationControllerProvider).value!;
      expect(state.isActive, isTrue);
      expect(state.busy, isFalse);
      verify(() => repo.start(any())).called(1);
    });

    test('should_set_actionError_and_keep_inactive_on_failure', () async {
      final repo = _MockRepo();
      stubLoad(repo, VacationStatus.inactive);
      when(() => repo.start(any()))
          .thenAnswer((_) async => const Result.failure(ApiError.badRequest()));
      final container = _container(repo);
      await container.read(vacationControllerProvider.future);

      final notifier = container.read(vacationControllerProvider.notifier);
      final error = await notifier.enable();

      expect(error, const ApiError.badRequest());
      final state = container.read(vacationControllerProvider).value!;
      expect(state.isActive, isFalse);
      expect(state.actionError, const ApiError.badRequest());
      expect(state.busy, isFalse);
    });

    test('should_noop_when_range_invalid', () async {
      final repo = _MockRepo();
      stubLoad(repo, VacationStatus.inactive);
      final container = _container(repo);
      await container.read(vacationControllerProvider.future);

      final notifier = container.read(vacationControllerProvider.notifier);
      // Делаем диапазон невалидным (> 60 дней).
      notifier.setTo(DateTime(2026, 9, 1));
      expect(
        container.read(vacationControllerProvider).value!.range.isValid,
        isFalse,
      );

      final error = await notifier.enable();

      expect(error, isNull);
      verifyNever(() => repo.start(any()));
    });
  });

  group('disable', () {
    test('should_delete_and_set_inactive_status', () async {
      final repo = _MockRepo();
      stubLoad(
        repo,
        VacationStatus(active: true, pausedUntil: DateTime.utc(2026, 6, 14)),
      );
      when(() => repo.end())
          .thenAnswer((_) async => Result.success(VacationStatus.inactive));
      final container = _container(repo);
      await container.read(vacationControllerProvider.future);

      final notifier = container.read(vacationControllerProvider.notifier);
      final error = await notifier.disable();

      expect(error, isNull);
      final state = container.read(vacationControllerProvider).value!;
      expect(state.isActive, isFalse);
      verify(() => repo.end()).called(1);
    });

    test('should_set_actionError_on_failure', () async {
      final repo = _MockRepo();
      stubLoad(
        repo,
        VacationStatus(active: true, pausedUntil: DateTime.utc(2026, 6, 14)),
      );
      when(() => repo.end())
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);
      await container.read(vacationControllerProvider.future);

      final notifier = container.read(vacationControllerProvider.notifier);
      final error = await notifier.disable();

      expect(error, const ApiError.network());
      final state = container.read(vacationControllerProvider).value!;
      // Остаёмся активными — удаление не удалось.
      expect(state.isActive, isTrue);
      expect(state.actionError, const ApiError.network());
    });
  });
}
