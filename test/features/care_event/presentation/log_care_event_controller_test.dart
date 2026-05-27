import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/care_event/data/care_event_repository_provider.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_repository.dart';
import 'package:plantcare_mobile/features/care_event/domain/logged_care_event.dart';
import 'package:plantcare_mobile/features/care_event/presentation/care_event_form_state.dart';
import 'package:plantcare_mobile/features/care_event/presentation/log_care_event_controller.dart';
import 'package:plantcare_mobile/features/home/data/home_repository_provider.dart';
import 'package:plantcare_mobile/features/home/domain/care_task.dart';
import 'package:plantcare_mobile/features/home/domain/home_repository.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/plant_card/data/plant_card_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/plant_card_repository.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';

class _MockCareEventRepo extends Mock implements CareEventRepository {}

class _MockHomeRepo extends Mock implements HomeRepository {}

class _MockPlantCardRepo extends Mock implements PlantCardRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

const _plantId = 42;
final _fixedNow = DateTime.utc(2026, 5, 27, 9);

LoggedCareEvent _logged(String? clientId) => LoggedCareEvent(
      id: 7,
      plantId: _plantId,
      plantName: 'Фикус',
      type: CareEventKind.water,
      performedAtUtc: _fixedNow,
      onTime: true,
      clientId: clientId,
    );

ProviderContainer _container(_MockCareEventRepo repo) {
  final container = ProviderContainer(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
      careEventRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Подписки на зависимые провайдеры — держат AutoDispose-провайдеры живыми,
/// чтобы инвалидация вызвала повторный fetch (а не диспоуз).
void _keepAlive(ProviderContainer container) {
  void noop(Object? prev, Object? next) {}
  for (final sub in [
    container.listen(homeTasksProvider, noop),
    container.listen(plantDetailProvider(_plantId), noop),
    container.listen(plantHistoryProvider(_plantId), noop),
    container.listen(plantStreakProvider(_plantId), noop),
  ]) {
    addTearDown(sub.close);
  }
}

/// Ждёт завершения всех зависимых futures (успех ИЛИ ошибка — оба завершают).
Future<void> _settle(ProviderContainer container) async {
  Future<void> swallow(Future<Object?> f) => f.then<void>((_) {}, onError: (_) {});

  await swallow(container.read(homeTasksProvider.future));
  await swallow(container.read(plantDetailProvider(_plantId).future));
  await swallow(container.read(plantHistoryProvider(_plantId).future));
  await swallow(container.read(plantStreakProvider(_plantId).future));
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      CareEventDraft(
        plantId: 0,
        type: CareEventKind.water,
        performedAtUtc: DateTime.utc(2026),
      ),
    );
  });

  late _MockCareEventRepo repo;

  setUp(() => repo = _MockCareEventRepo());

  group('initial state', () {
    test('should_apply_preset_water', () {
      final container = _container(repo);

      final state = container.read(logCareEventControllerProvider(
        _plantId,
        presetType: CareEventKind.water,
      ));

      expect(state.type, CareEventKind.water);
      expect(state.performedAtUtc, _fixedNow);
      expect(state.status, const CareEventSubmitStatus.idle());
    });

    test('should_apply_preset_spray', () {
      final container = _container(repo);

      final state = container.read(logCareEventControllerProvider(
        _plantId,
        presetType: CareEventKind.spray,
      ));

      expect(state.type, CareEventKind.spray);
    });

    test('should_apply_preset_fertilize', () {
      final container = _container(repo);

      final state = container.read(logCareEventControllerProvider(
        _plantId,
        presetType: CareEventKind.fertilize,
      ));

      expect(state.type, CareEventKind.fertilize);
    });

    test('should_default_to_water_when_preset_unknown', () {
      final container = _container(repo);

      final state = container.read(logCareEventControllerProvider(
        _plantId,
        presetType: CareEventKind.unknown,
      ));

      expect(state.type, CareEventKind.water);
    });

    test('should_default_to_water_when_preset_null', () {
      final container = _container(repo);

      final state = container.read(logCareEventControllerProvider(_plantId));

      expect(state.type, CareEventKind.water);
    });
  });

  group('setters', () {
    test('should_change_type_when_setType_called', () {
      final container = _container(repo);
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      notifier.setType(CareEventKind.fertilize);

      expect(
        container.read(logCareEventControllerProvider(_plantId)).type,
        CareEventKind.fertilize,
      );
    });

    test('should_ignore_setType_when_unknown', () {
      final container = _container(repo);
      final notifier = container.read(
          logCareEventControllerProvider(_plantId, presetType: CareEventKind.spray)
              .notifier);

      notifier.setType(CareEventKind.unknown);

      expect(
        container
            .read(logCareEventControllerProvider(_plantId,
                presetType: CareEventKind.spray))
            .type,
        CareEventKind.spray,
      );
    });

    test('should_store_performedAt_as_utc_when_setPerformedAt_called', () {
      final container = _container(repo);
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);
      final local = DateTime(2026, 5, 20, 14, 30);

      notifier.setPerformedAt(local);

      final stored =
          container.read(logCareEventControllerProvider(_plantId)).performedAtUtc;
      expect(stored.isUtc, isTrue);
      expect(stored, local.toUtc());
    });

    test('should_trim_and_set_note_when_setNote_called', () {
      final container = _container(repo);
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      notifier.setNote('  полил  ');

      expect(
        container.read(logCareEventControllerProvider(_plantId)).note,
        'полил',
      );
    });

    test('should_set_note_null_when_blank', () {
      final container = _container(repo);
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      notifier.setNote('   ');

      expect(
        container.read(logCareEventControllerProvider(_plantId)).note,
        isNull,
      );
    });
  });

  group('canSubmit', () {
    test('should_be_true_for_valid_type_and_idle', () {
      final container = _container(repo);

      final state = container.read(logCareEventControllerProvider(_plantId));

      expect(state.canSubmit, isTrue);
    });

    test('should_be_false_while_submitting', () {
      final state = CareEventFormState(
        plantId: _plantId,
        type: CareEventKind.water,
        performedAtUtc: _fixedNow,
        status: const CareEventSubmitStatus.submitting(),
      );

      expect(state.canSubmit, isFalse);
    });

    test('should_be_false_when_type_unknown', () {
      final state = CareEventFormState(
        plantId: _plantId,
        type: CareEventKind.unknown,
        performedAtUtc: _fixedNow,
      );

      expect(state.canSubmit, isFalse);
    });
  });

  group('submit success', () {
    test('should_transition_submitting_then_success_and_call_usecase_with_draft',
        () async {
      when(() => repo.logCareEvent(any()))
          .thenAnswer((_) async => Result.success(_logged('uuid')));
      final container = _container(repo);
      final notifier = container.read(
          logCareEventControllerProvider(_plantId, presetType: CareEventKind.spray)
              .notifier);
      notifier.setNote('заметка');

      final statuses = <CareEventSubmitStatus>[];
      final sub = container.listen(
        logCareEventControllerProvider(_plantId, presetType: CareEventKind.spray)
            .select((s) => s.status),
        (_, next) => statuses.add(next),
        fireImmediately: true,
      );
      addTearDown(sub.close);

      final ok = await notifier.submit();

      expect(ok, isTrue);
      expect(statuses.first, const CareEventSubmitStatus.idle());
      expect(statuses, contains(const CareEventSubmitStatus.submitting()));
      expect(statuses.last, const CareEventSubmitStatus.success());

      final draft =
          verify(() => repo.logCareEvent(captureAny())).captured.single
              as CareEventDraft;
      expect(draft.plantId, _plantId);
      expect(draft.type, CareEventKind.spray);
      expect(draft.note, 'заметка');
      expect(draft.clientId, isNotNull);
    });

    test('should_not_call_usecase_second_time_while_first_submit_in_flight',
        () async {
      // Первый submit «висит» (Completer не завершён) → state == submitting →
      // canSubmit == false → второй submit обязан вернуть false и НЕ звать репо.
      final completer = Completer<Result<LoggedCareEvent>>();
      when(() => repo.logCareEvent(any())).thenAnswer((_) => completer.future);
      final container = _container(repo);
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      final first = notifier.submit(); // не ждём — остаётся submitting
      final second = await notifier.submit();

      expect(second, isFalse);
      verify(() => repo.logCareEvent(any())).called(1);

      completer.complete(Result.success(_logged('uuid')));
      await first;
    });
  });

  group('submit failure', () {
    test('should_set_failure_status_with_ApiError', () async {
      when(() => repo.logCareEvent(any()))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      final ok = await notifier.submit();

      expect(ok, isFalse);
      final status =
          container.read(logCareEventControllerProvider(_plantId)).status;
      expect(status, const CareEventSubmitStatus.failure(ApiError.network()));
    });
  });

  group('clientId idempotency', () {
    test('should_reuse_same_clientId_on_retry_after_failure', () async {
      // Первая попытка падает, вторая — успех. clientId обязан совпасть.
      var calls = 0;
      when(() => repo.logCareEvent(any())).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Result.failure(ApiError.network())
            : Result.success(_logged('uuid'));
      });
      final container = _container(repo);
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      await notifier.submit();
      await notifier.submit();

      final drafts = verify(() => repo.logCareEvent(captureAny())).captured
          .cast<CareEventDraft>();
      expect(drafts, hasLength(2));
      expect(drafts[0].clientId, isNotNull);
      expect(drafts[1].clientId, drafts[0].clientId);
    });

    test('should_generate_new_clientId_after_form_edit_resets_attempt',
        () async {
      var calls = 0;
      when(() => repo.logCareEvent(any())).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Result.failure(ApiError.network())
            : Result.success(_logged('uuid'));
      });
      final container = _container(repo);
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      await notifier.submit();
      notifier.setNote('изменил'); // сброс идемпотентности — новая попытка
      await notifier.submit();

      final drafts = verify(() => repo.logCareEvent(captureAny())).captured
          .cast<CareEventDraft>();
      expect(drafts[1].clientId, isNot(drafts[0].clientId));
    });
  });

  group('timezone', () {
    test('should_submit_performedAt_as_utc_when_set_from_local_non_utc', () async {
      when(() => repo.logCareEvent(any()))
          .thenAnswer((_) async => Result.success(_logged('uuid')));
      final container = _container(repo);
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      // Пользователь выбрал локальное время (как из date/time picker).
      final local = DateTime(2026, 5, 26, 23, 15);
      notifier.setPerformedAt(local);

      await notifier.submit();

      final draft =
          verify(() => repo.logCareEvent(captureAny())).captured.single
              as CareEventDraft;
      expect(draft.performedAtUtc.isUtc, isTrue);
      expect(draft.performedAtUtc, local.toUtc());
    });
  });

  group('dispose during in-flight submit', () {
    test('should_not_throw_when_provider_disposed_while_submit_in_flight',
        () async {
      // Регрессия: autoDispose-провайдер sheet диспоузится (sheet смахнули) во
      // время in-flight POST. После await submit() обращается к ref/state — без
      // guard `if (!ref.mounted)` это кинуло бы StateError.
      final completer = Completer<Result<LoggedCareEvent>>();
      when(() => repo.logCareEvent(any())).thenAnswer((_) => completer.future);
      // Контейнер БЕЗ addTearDown(dispose): диспоузим вручную ниже.
      final container = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
          careEventRepositoryProvider.overrideWithValue(repo),
        ],
      );
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      final future = notifier.submit(); // не ждём — POST «висит»
      expect(
        container.read(logCareEventControllerProvider(_plantId)).status,
        const CareEventSubmitStatus.submitting(),
      );

      // Симуляция смахивания sheet: диспоуз контейнера = диспоуз notifier'а
      // (как при autoDispose, когда снята последняя подписка).
      container.dispose();
      completer.complete(Result.success(_logged('uuid')));

      final ok = await future;

      expect(ok, isFalse); // guard сработал — вышли до state/invalidate
    });

    test('should_not_throw_when_provider_disposed_during_failing_submit',
        () async {
      final completer = Completer<Result<LoggedCareEvent>>();
      when(() => repo.logCareEvent(any())).thenAnswer((_) => completer.future);
      final container = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
          careEventRepositoryProvider.overrideWithValue(repo),
        ],
      );
      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);

      final future = notifier.submit();
      expect(
        container.read(logCareEventControllerProvider(_plantId)).status,
        const CareEventSubmitStatus.submitting(),
      );

      container.dispose();
      completer.complete(const Result.failure(ApiError.network()));

      final ok = await future;

      expect(ok, isFalse);
    });
  });

  group('invalidation after success', () {
    test('should_refetch_dependent_providers_after_successful_submit',
        () async {
      when(() => repo.logCareEvent(any()))
          .thenAnswer((_) async => Result.success(_logged('uuid')));

      final homeRepo = _MockHomeRepo();
      final cardRepo = _MockPlantCardRepo();
      when(homeRepo.getTodayTasks).thenAnswer(
        (_) async => const Result<List<CareTask>>.success(<CareTask>[]),
      );
      when(() => cardRepo.getHistory(_plantId)).thenAnswer(
        (_) async =>
            const Result<List<CareHistoryEntry>>.success(<CareHistoryEntry>[]),
      );
      when(() => cardRepo.getStreak(_plantId)).thenAnswer(
        (_) async =>
            const Result<Streak>.success(Streak(plantId: _plantId, count: 0)),
      );
      when(() => cardRepo.getPlant(_plantId)).thenAnswer(
        (_) async => const Result<Plant>.success(Plant(id: _plantId, name: 'x')),
      );

      final container = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
          careEventRepositoryProvider.overrideWithValue(repo),
          homeRepositoryProvider.overrideWithValue(homeRepo),
          plantCardRepositoryProvider.overrideWithValue(cardRepo),
        ],
      );
      addTearDown(container.dispose);

      // Держим подписки, чтобы AutoDispose-провайдеры не диспоузились между
      // первым чтением и инвалидацией (иначе invalidate просто их удалит, а не
      // перезапросит).
      _keepAlive(container);

      // Первичная загрузка зависимых провайдеров — каждый репо вызван 1 раз.
      await _settle(container);
      verify(homeRepo.getTodayTasks).called(1);
      verify(() => cardRepo.getHistory(_plantId)).called(1);
      verify(() => cardRepo.getStreak(_plantId)).called(1);
      verify(() => cardRepo.getPlant(_plantId)).called(1);

      final notifier =
          container.read(logCareEventControllerProvider(_plantId).notifier);
      await notifier.submit();

      // После success контроллер инвалидирует чтения → повторный fetch.
      await _settle(container);

      verify(homeRepo.getTodayTasks).called(1);
      verify(() => cardRepo.getHistory(_plantId)).called(1);
      verify(() => cardRepo.getStreak(_plantId)).called(1);
      verify(() => cardRepo.getPlant(_plantId)).called(1);
    });
  });
}
