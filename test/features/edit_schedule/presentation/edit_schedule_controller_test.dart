import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/edit_schedule/data/edit_schedule_repository_provider.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/care_schedule_unit.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/edit_schedule_repository.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/plant_care_schedule.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/edit_schedule_controller.dart';

class _MockRepo extends Mock implements EditScheduleRepository {}

class _FakeSchedule extends Fake implements PlantCareSchedule {}

const _plantId = 1;

PlantCareSchedule _schedule(
  CareTaskType type,
  String rawType, {
  int every = 7,
  bool enabled = true,
  int? amountMl,
}) =>
    PlantCareSchedule(
      type: type,
      rawType: rawType,
      every: every,
      unit: CareScheduleUnit.day,
      rawUnit: 'DAY',
      amountMl: amountMl,
      enabled: enabled,
    );

final _watering = _schedule(CareTaskType.watering, 'WATERING',
    every: 7, amountMl: 200);
final _misting = _schedule(CareTaskType.misting, 'MISTING', every: 3);
final _fertilizing =
    _schedule(CareTaskType.fertilizing, 'FERTILIZING', every: 30);

ProviderContainer _container(EditScheduleRepository repo) {
  final container = ProviderContainer(
    overrides: [editScheduleRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeSchedule());
  });

  void stubLoad(_MockRepo repo, List<PlantCareSchedule> loaded) {
    when(() => repo.getSchedules(any()))
        .thenAnswer((_) async => Result.success(loaded));
  }

  group('build', () {
    test('should_set_draft_equal_to_loaded_and_not_dirty', () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering, _misting]);
      final container = _container(repo);

      final state = await container
          .read(editScheduleControllerProvider(_plantId).future);

      expect(state.loaded, [_watering, _misting]);
      expect(state.draft, [_watering, _misting]);
      expect(state.isDirty, isFalse);
      expect(state.dirtyTypes, isEmpty);
    });

    test('should_emit_AsyncError_when_load_fails', () async {
      final repo = _MockRepo();
      when(() => repo.getSchedules(any()))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);

      final completer = Completer<Object?>();
      final sub = container.listen(
        editScheduleControllerProvider(_plantId),
        (_, next) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        },
      );
      addTearDown(sub.close);

      // build бросает ApiError → AsyncError(ApiError.network).
      expect(await completer.future, const ApiError.network());
    });
  });

  group('draft edits', () {
    test('should_make_type_dirty_and_flip_enabled_when_toggle', () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering, _misting]);
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      notifier.toggle(CareTaskType.watering);

      final state = container.read(editScheduleControllerProvider(_plantId)).value!;
      expect(state.draftOf(CareTaskType.watering)!.enabled, isFalse);
      expect(state.dirtyTypes, {CareTaskType.watering});
      // Нетронутый тип чистый, loaded не изменился.
      expect(state.loaded.first.enabled, isTrue);
    });

    test('should_set_every_and_make_dirty_when_setEvery', () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering]);
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      notifier.setEvery(CareTaskType.watering, 10);

      final state = container.read(editScheduleControllerProvider(_plantId)).value!;
      expect(state.draftOf(CareTaskType.watering)!.every, 10);
      expect(state.dirtyTypes, {CareTaskType.watering});
    });

    test('should_clamp_every_to_at_least_1_when_setEvery_below_1', () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering]);
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      notifier.setEvery(CareTaskType.watering, 0);
      expect(
        container.read(editScheduleControllerProvider(_plantId)).value!
            .draftOf(CareTaskType.watering)!.every,
        1,
      );

      notifier.setEvery(CareTaskType.watering, -3);
      expect(
        container.read(editScheduleControllerProvider(_plantId)).value!
            .draftOf(CareTaskType.watering)!.every,
        1,
      );
    });

    test('should_set_amountMl_and_make_dirty_when_setAmountMl', () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering]);
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      notifier.setAmountMl(CareTaskType.watering, 350);

      final state = container.read(editScheduleControllerProvider(_plantId)).value!;
      expect(state.draftOf(CareTaskType.watering)!.amountMl, 350);
      expect(state.dirtyTypes, {CareTaskType.watering});
    });

    test('should_become_clean_when_every_reverted_to_loaded_value', () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering]);
      final container = _container(repo);
      final loaded = await container
          .read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);
      final base = loaded.loadedOf(CareTaskType.watering)!;

      // Меняем значение — тип становится грязным.
      notifier.setEvery(CareTaskType.watering, base.every + 3);
      final dirtyState =
          container.read(editScheduleControllerProvider(_plantId)).value!;
      expect(dirtyState.dirtyTypes, {CareTaskType.watering});

      // Возвращаем то же самое значение, что было в loaded.
      notifier.setEvery(CareTaskType.watering, base.every);

      // Грязь считается по значению, а не по факту касания: тип снова чистый.
      final state =
          container.read(editScheduleControllerProvider(_plantId)).value!;
      expect(state.dirtyTypes, isNot(contains(CareTaskType.watering)));
      expect(state.isDirty, isFalse);
    });
  });

  group('reset', () {
    test('should_set_every_from_map_and_not_touch_enabled_or_amountMl',
        () async {
      final repo = _MockRepo();
      // amountMl=200, enabled=true изначально.
      stubLoad(repo, [_watering, _misting]);
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      notifier.reset({CareTaskType.watering: 5});

      final state = container.read(editScheduleControllerProvider(_plantId)).value!;
      final w = state.draftOf(CareTaskType.watering)!;
      expect(w.every, 5);
      // enabled и amountMl сброс НЕ трогает (как задокументировано).
      expect(w.enabled, isTrue);
      expect(w.amountMl, 200);
      // Тип без рекомендации остаётся как был.
      expect(state.draftOf(CareTaskType.misting)!.every, 3);
      expect(state.dirtyTypes, {CareTaskType.watering});
    });
  });

  group('save', () {
    test('should_be_noop_and_return_null_when_no_dirty', () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering, _misting]);
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      final error = await notifier.save();

      expect(error, isNull);
      // Репозиторий по PUT не дёргается, раз грязи нет.
      verifyNever(() => repo.updateSchedule(any(), any()));
    });

    test('should_put_only_dirty_types_and_fix_loaded_on_full_success',
        () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering, _misting, _fertilizing]);
      // updateSchedule отвечает эхом с пересчитанным nextDueAt.
      when(() => repo.updateSchedule(any(), any())).thenAnswer((inv) async {
        final s = inv.positionalArguments[1] as PlantCareSchedule;
        return Result.success(
          s.copyWith(nextDueAt: DateTime.utc(2026, 7, 1)),
        );
      });
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      // Меняем только watering и fertilizing; misting не трогаем.
      notifier.setEvery(CareTaskType.watering, 10);
      notifier.toggle(CareTaskType.fertilizing);

      final error = await notifier.save();

      expect(error, isNull);
      // PUT ушёл по двум грязным типам, по нетронутому misting — нет.
      verify(() => repo.updateSchedule(
            _plantId,
            any(that: isA<PlantCareSchedule>()
                .having((s) => s.type, 'type', CareTaskType.watering)),
          )).called(1);
      verify(() => repo.updateSchedule(
            _plantId,
            any(that: isA<PlantCareSchedule>()
                .having((s) => s.type, 'type', CareTaskType.fertilizing)),
          )).called(1);
      verifyNever(() => repo.updateSchedule(
            any(),
            any(that: isA<PlantCareSchedule>()
                .having((s) => s.type, 'type', CareTaskType.misting)),
          ));

      final state = container.read(editScheduleControllerProvider(_plantId)).value!;
      // Полный успех: грязь исчезла, saving сброшен, ошибки нет.
      expect(state.isDirty, isFalse);
      expect(state.saving, isFalse);
      expect(state.saveError, isNull);
      // loaded зафиксирован ответом сервера (с пересчитанным nextDueAt).
      expect(
        state.loaded.firstWhere((s) => s.type == CareTaskType.watering).every,
        10,
      );
      expect(
        state.loaded
            .firstWhere((s) => s.type == CareTaskType.watering)
            .nextDueAt,
        DateTime.utc(2026, 7, 1),
      );
    });

    test(
        'should_keep_failed_type_dirty_and_set_saveError_on_partial_failure',
        () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering, _misting, _fertilizing]);
      // watering сохранится, fertilizing упадёт. save() PUT'ит грязные в
      // порядке dirtyTypes (по порядку списка): сначала watering (успех),
      // затем fertilizing (ошибка) → останов.
      when(() => repo.updateSchedule(any(), any())).thenAnswer((inv) async {
        final s = inv.positionalArguments[1] as PlantCareSchedule;
        if (s.type == CareTaskType.fertilizing) {
          return const Result.failure(ApiError.conflict());
        }
        return Result.success(s.copyWith(nextDueAt: DateTime.utc(2026, 7, 1)));
      });
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      notifier.setEvery(CareTaskType.watering, 11);
      notifier.setEvery(CareTaskType.fertilizing, 40);

      final error = await notifier.save();

      // Вернулась ошибка первой неудачи.
      expect(error, const ApiError.conflict());

      final state = container.read(editScheduleControllerProvider(_plantId)).value!;
      expect(state.saveError, const ApiError.conflict());
      expect(state.saving, isFalse);
      // Успевший watering зафиксирован в loaded (every=11) → больше не грязный.
      expect(
        state.loaded.firstWhere((s) => s.type == CareTaskType.watering).every,
        11,
      );
      // Упавший fertilizing остаётся грязным (loaded по нему не тронут).
      expect(state.dirtyTypes, {CareTaskType.fertilizing});
      expect(
        state.loaded
            .firstWhere((s) => s.type == CareTaskType.fertilizing)
            .every,
        30,
      );
    });

    test('should_set_saving_true_while_in_flight', () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering]);
      final completer = Completer<Result<PlantCareSchedule>>();
      when(() => repo.updateSchedule(any(), any()))
          .thenAnswer((_) => completer.future);
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      notifier.setEvery(CareTaskType.watering, 9);
      final saveFuture = notifier.save();

      // В полёте: saving == true до завершения PUT.
      expect(
        container.read(editScheduleControllerProvider(_plantId)).value!.saving,
        isTrue,
      );

      completer.complete(Result.success(_watering.copyWith(every: 9)));
      await saveFuture;

      expect(
        container.read(editScheduleControllerProvider(_plantId)).value!.saving,
        isFalse,
      );
    });

    test('should_be_noop_when_save_called_again_while_in_flight', () async {
      final repo = _MockRepo();
      stubLoad(repo, [_watering]);
      final completer = Completer<Result<PlantCareSchedule>>();
      when(() => repo.updateSchedule(any(), any()))
          .thenAnswer((_) => completer.future);
      final container = _container(repo);
      await container.read(editScheduleControllerProvider(_plantId).future);
      final notifier =
          container.read(editScheduleControllerProvider(_plantId).notifier);

      notifier.setEvery(CareTaskType.watering, 9);

      // Первый save в полёте (PUT подвешен Completer'ом, не завершаем).
      final f1 = notifier.save();
      // Повторный save, пока первый ещё летит, — guard `saving` → no-op.
      final r2 = await notifier.save();

      // Второй вызов ничего не делает: возвращает null и (за время полёта)
      // не шлёт второй PUT — ровно один вызов updateSchedule.
      // (verify сбрасывает счётчик mocktail, поэтому проверяем один раз здесь.)
      expect(r2, isNull);
      verify(() => repo.updateSchedule(any(), any())).called(1);

      // Завершаем первый PUT — он доводит сохранение до конца.
      completer.complete(Result.success(_watering.copyWith(every: 9)));
      final r1 = await f1;

      // Завершение Completer'а не может породить новый PUT, поэтому суммарно
      // updateSchedule так и остался вызванным ровно один раз.
      expect(r1, isNull);
      final state =
          container.read(editScheduleControllerProvider(_plantId)).value!;
      expect(state.saving, isFalse);
      expect(state.saveError, isNull);
      expect(state.isDirty, isFalse);
      verifyNever(() => repo.updateSchedule(any(), any()));
    });
  });
}
