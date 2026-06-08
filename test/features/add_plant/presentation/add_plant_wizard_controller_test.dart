import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/add_plant/data/add_plant_repository_provider.dart';
import 'package:plantcare_mobile/features/add_plant/domain/add_plant_repository.dart';
import 'package:plantcare_mobile/features/add_plant/domain/species_summary.dart';
import 'package:plantcare_mobile/features/add_plant/domain/window_side.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_controller.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_state.dart';
import 'package:plantcare_mobile/features/edit_schedule/data/edit_schedule_repository_provider.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/care_schedule_unit.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/edit_schedule_repository.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/plant_care_schedule.dart';
import 'package:plantcare_mobile/features/home/data/home_repository_provider.dart';
import 'package:plantcare_mobile/features/home/domain/home_repository.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';

class _MockAddPlantRepo extends Mock implements AddPlantRepository {}

class _MockScheduleRepo extends Mock implements EditScheduleRepository {}

class _MockHomeRepo extends Mock implements HomeRepository {}

// Вид с двумя пунктами плана ухода: полив 7 дн., удобрение 30 дн.
const _speciesWithPlan = SpeciesSummary(
  id: 7,
  name: 'Фикус',
  wateringDays: 7,
  fertilizingDays: 30,
);

// Вид без плана ухода (нет интервалов)
const _speciesNoPlan = SpeciesSummary(id: 8, name: 'Кактус');

// Вид только с поливом
const _speciesWatering = SpeciesSummary(id: 9, name: 'Алоэ', wateringDays: 14);

ProviderContainer _makeContainer({
  _MockAddPlantRepo? addPlantRepo,
  _MockScheduleRepo? scheduleRepo,
  _MockHomeRepo? homeRepo,
}) {
  final plantRepo = addPlantRepo ?? _MockAddPlantRepo();
  final container = ProviderContainer(
    overrides: [
      addPlantRepositoryProvider.overrideWithValue(plantRepo),
      if (scheduleRepo != null)
        editScheduleRepositoryProvider.overrideWithValue(scheduleRepo),
      if (homeRepo != null) homeRepositoryProvider.overrideWithValue(homeRepo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const PlantCareSchedule(
        type: CareTaskType.watering,
        rawType: 'WATERING',
        every: 1,
        unit: CareScheduleUnit.day,
        rawUnit: 'DAY',
        enabled: true,
      ),
    );
  });

  group('initial state', () {
    test('should_start_idle_with_empty_draft_and_canSubmit_false', () {
      final container = _makeContainer();

      final state = container.read(addPlantWizardControllerProvider);

      expect(state.status, const AddPlantSubmitStatus.idle());
      expect(state.draft.name, '');
      expect(state.draft.species, isNull);
      expect(state.draft.locationId, isNull);
      expect(state.canSubmit, isFalse);
    });
  });

  group('selectSpecies', () {
    test('should_prefill_name_when_name_empty', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.selectSpecies(_speciesWithPlan);

      final draft = container.read(addPlantWizardControllerProvider).draft;
      expect(draft.species, _speciesWithPlan);
      expect(draft.name, 'Фикус');
    });

    test('should_not_overwrite_manually_entered_name', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Моё растение');

      notifier.selectSpecies(_speciesWithPlan);

      final draft = container.read(addPlantWizardControllerProvider).draft;
      expect(draft.species, _speciesWithPlan);
      expect(draft.name, 'Моё растение');
    });
  });

  group('setters', () {
    test('should_update_name', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setName('Алоэ');

      expect(
          container.read(addPlantWizardControllerProvider).draft.name, 'Алоэ');
    });

    test('should_update_location', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setLocation(42);

      expect(
        container.read(addPlantWizardControllerProvider).draft.locationId,
        42,
      );
    });

    test('should_store_notes_and_trim', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setNotes('  на окне  ');

      expect(
        container.read(addPlantWizardControllerProvider).draft.notes,
        'на окне',
      );
    });

    test('should_set_notes_null_when_blank', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setNotes('   ');

      expect(
        container.read(addPlantWizardControllerProvider).draft.notes,
        isNull,
      );
    });
  });

  group('canSubmit', () {
    test('should_be_false_when_name_invalid', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setName('   ');

      expect(
          container.read(addPlantWizardControllerProvider).canSubmit, isFalse);
    });

    test('should_be_true_when_name_valid_and_idle', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setName('Фикус');

      expect(
          container.read(addPlantWizardControllerProvider).canSubmit, isTrue);
    });
  });

  group('submit success', () {
    test('should_call_repo_with_trimmed_draft_and_set_success_status',
        () async {
      final addRepo = _MockAddPlantRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async => const Result.success(99));
      final container = _makeContainer(addPlantRepo: addRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('  Фикус  ');
      notifier.setLocation(3);
      notifier.setNotes('на окне');

      final statuses = <AddPlantSubmitStatus>[];
      final sub = container.listen(
        addPlantWizardControllerProvider.select((s) => s.status),
        (_, next) => statuses.add(next),
        fireImmediately: true,
      );
      addTearDown(sub.close);

      final id = await notifier.submit();

      expect(id, 99);
      expect(statuses.first, const AddPlantSubmitStatus.idle());
      expect(statuses, contains(const AddPlantSubmitStatus.submitting()));
      expect(statuses.last, const AddPlantSubmitStatus.success(99));

      verify(() => addRepo.createPlant(
            name: 'Фикус',
            locationId: 3,
            notes: 'на окне',
          )).called(1);
    });

    test('should_not_call_repo_when_canSubmit_false', () async {
      final addRepo = _MockAddPlantRepo();
      final container = _makeContainer(addPlantRepo: addRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      final id = await notifier.submit();

      expect(id, isNull);
      verifyNever(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          ));
    });

    test('should_not_call_repo_second_time_while_first_submit_in_flight',
        () async {
      final addRepo = _MockAddPlantRepo();
      final completer = Completer<Result<int>>();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) => completer.future);
      final container = _makeContainer(addPlantRepo: addRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Фикус');

      final first = notifier.submit();
      final second = await notifier.submit();

      expect(second, isNull);
      verify(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).called(1);

      completer.complete(const Result.success(1));
      await first;
    });
  });

  group('submit speciesId propagation', () {
    test('should_pass_selected_species_id_when_species_chosen', () async {
      final addRepo = _MockAddPlantRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer((_) async => const Result.success(99));
      final container = _makeContainer(addPlantRepo: addRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesWithPlan);

      await notifier.submit();

      final speciesId = verify(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: captureAny(named: 'speciesId'),
          )).captured.single;
      expect(speciesId, _speciesWithPlan.id);
      expect(speciesId, 7);
    });

    test('should_pass_null_species_id_when_no_species_chosen', () async {
      final addRepo = _MockAddPlantRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer((_) async => const Result.success(99));
      final container = _makeContainer(addPlantRepo: addRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Безымянное');

      await notifier.submit();

      final speciesId = verify(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: captureAny(named: 'speciesId'),
          )).captured.single;
      expect(speciesId, isNull);
    });
  });

  group('resetStatus', () {
    test('should_reset_conflict_failure_to_idle_and_reenable_submit', () async {
      final addRepo = _MockAddPlantRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer(
        (_) async => const Result.failure(ApiError.conflict()),
      );
      final container = _makeContainer(addPlantRepo: addRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Фикус');

      await notifier.submit();

      // После ConflictError — failure-статус, canSubmit true (обычная ошибка
      // не блокирует кнопку: пользователь может изменить данные и повторить).
      expect(
        container.read(addPlantWizardControllerProvider).status,
        const AddPlantSubmitStatus.failure(ApiError.conflict()),
      );
      expect(
          container.read(addPlantWizardControllerProvider).canSubmit, isTrue);

      // Вызываем resetStatus (из диалога дедупа).
      notifier.resetStatus();

      // Статус сброшен в idle.
      expect(
        container.read(addPlantWizardControllerProvider).status,
        const AddPlantSubmitStatus.idle(),
      );
      expect(
          container.read(addPlantWizardControllerProvider).canSubmit, isTrue);
    });
  });

  group('submit failure', () {
    test('should_set_failure_status_and_allow_retry', () async {
      final addRepo = _MockAddPlantRepo();
      var calls = 0;
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Result.failure(ApiError.network())
            : const Result.success(5);
      });
      final container = _makeContainer(addPlantRepo: addRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Фикус');

      final firstId = await notifier.submit();

      expect(firstId, isNull);
      expect(
        container.read(addPlantWizardControllerProvider).status,
        const AddPlantSubmitStatus.failure(ApiError.network()),
      );
      expect(
          container.read(addPlantWizardControllerProvider).canSubmit, isTrue);

      final secondId = await notifier.submit();

      expect(secondId, 5);
      verify(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).called(2);
    });
  });

  group('home invalidation after success', () {
    test('should_refetch_homePlants_after_successful_submit', () async {
      final addRepo = _MockAddPlantRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async => const Result.success(99));

      final homeRepo = _MockHomeRepo();
      when(homeRepo.getPlants).thenAnswer(
        (_) async => const Result<List<Plant>>.success(<Plant>[]),
      );

      final container = ProviderContainer(
        overrides: [
          addPlantRepositoryProvider.overrideWithValue(addRepo),
          homeRepositoryProvider.overrideWithValue(homeRepo),
        ],
      );
      addTearDown(container.dispose);

      final keep = container.listen(homePlantsProvider, (_, _) {});
      addTearDown(keep.close);

      await container.read(homePlantsProvider.future);
      verify(homeRepo.getPlants).called(1);

      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Фикус');
      await notifier.submit();

      await container.read(homePlantsProvider.future);
      verify(homeRepo.getPlants).called(1);
    });
  });

  // ===== Новые тесты для setIntervalOverride и submit с PUT-фазой =====

  group('setIntervalOverride', () {
    test('should_store_override_when_value_differs_from_species_default', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesWithPlan); // watering 7, fertilizing 30

      notifier.setIntervalOverride(CareTaskType.watering, 10);

      final overrides =
          container.read(addPlantWizardControllerProvider).draft.intervalOverrides;
      expect(overrides[CareTaskType.watering], 10);
    });

    test(
        'should_remove_override_when_value_equals_species_default_to_skip_unnecessary_put',
        () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesWithPlan); // watering default = 7

      // Сначала ставим оверрайд
      notifier.setIntervalOverride(CareTaskType.watering, 10);
      // Потом возвращаем к дефолту — оверрайд должен исчезнуть
      notifier.setIntervalOverride(CareTaskType.watering, 7);

      final overrides =
          container.read(addPlantWizardControllerProvider).draft.intervalOverrides;
      expect(overrides.containsKey(CareTaskType.watering), isFalse);
    });

    test('should_clamp_to_1_when_called_with_0', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesNoPlan); // без плана → нет дефолта

      notifier.setIntervalOverride(CareTaskType.watering, 0);

      final overrides =
          container.read(addPlantWizardControllerProvider).draft.intervalOverrides;
      expect(overrides[CareTaskType.watering], 1);
    });

    test('should_clamp_to_1_when_called_with_negative', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesNoPlan);

      notifier.setIntervalOverride(CareTaskType.misting, -5);

      final overrides =
          container.read(addPlantWizardControllerProvider).draft.intervalOverrides;
      expect(overrides[CareTaskType.misting], 1);
    });

    test('should_reset_overrides_when_selectSpecies_is_called', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesWithPlan);
      notifier.setIntervalOverride(CareTaskType.watering, 21);

      // Смена вида → оверрайды сбрасываются
      notifier.selectSpecies(_speciesNoPlan);

      final overrides =
          container.read(addPlantWizardControllerProvider).draft.intervalOverrides;
      expect(overrides, isEmpty);
    });
  });

  group('submit — schedule PUT phase', () {
    test(
        'should_not_call_updateSchedule_when_intervalOverrides_is_empty',
        () async {
      final addRepo = _MockAddPlantRepo();
      final scheduleRepo = _MockScheduleRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer((_) async => const Result.success(42));

      final container =
          _makeContainer(addPlantRepo: addRepo, scheduleRepo: scheduleRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesWithPlan);
      // Не меняем интервалы → intervalOverrides пустой

      final id = await notifier.submit();

      expect(id, 42);
      verifyNever(() =>
          scheduleRepo.updateSchedule(any(), any()));
    });

    test(
        'should_call_updateSchedule_once_with_correct_plantId_and_every_and_transition_to_success',
        () async {
      final addRepo = _MockAddPlantRepo();
      final scheduleRepo = _MockScheduleRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer((_) async => const Result.success(55));

      final updatedSchedule = const PlantCareSchedule(
        type: CareTaskType.watering,
        rawType: 'WATERING',
        every: 14,
        unit: CareScheduleUnit.day,
        rawUnit: 'DAY',
        enabled: true,
      );
      when(() => scheduleRepo.updateSchedule(any(), any()))
          .thenAnswer((_) async => Result.success(updatedSchedule));

      final container =
          _makeContainer(addPlantRepo: addRepo, scheduleRepo: scheduleRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesWatering); // watering default = 14
      // Меняем полив с 14 на 21 → оверрайд
      notifier.setIntervalOverride(CareTaskType.watering, 21);

      final id = await notifier.submit();

      expect(id, 55);
      expect(
        container.read(addPlantWizardControllerProvider).status,
        const AddPlantSubmitStatus.success(55),
      );

      final captured = verify(
          () => scheduleRepo.updateSchedule(captureAny(), captureAny()))
          .captured;
      expect(captured[0], 55); // plantId
      final schedule = captured[1] as PlantCareSchedule;
      expect(schedule.type, CareTaskType.watering);
      expect(schedule.every, 21);
      expect(schedule.rawType, 'WATERING');
    });

    test(
        'should_transition_to_scheduleFailure_when_updateSchedule_fails_and_not_call_remaining_puts',
        () async {
      final addRepo = _MockAddPlantRepo();
      final scheduleRepo = _MockScheduleRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer((_) async => const Result.success(77));

      // Первый PUT падает
      when(() => scheduleRepo.updateSchedule(any(), any()))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      final container =
          _makeContainer(addPlantRepo: addRepo, scheduleRepo: scheduleRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      // Вид с двумя оверрайдами
      notifier.selectSpecies(
        const SpeciesSummary(
          id: 10,
          name: 'Тест',
          wateringDays: 7,
          fertilizingDays: 30,
        ),
      );
      notifier.setIntervalOverride(CareTaskType.watering, 14);
      notifier.setIntervalOverride(CareTaskType.fertilizing, 60);

      final id = await notifier.submit();

      expect(id, isNull);
      final status =
          container.read(addPlantWizardControllerProvider).status;
      expect(status, isA<AddPlantScheduleFailure>());
      final failure = status as AddPlantScheduleFailure;
      expect(failure.plantId, 77);
      expect(failure.error, const ApiError.network());
      // После первой ошибки второй PUT не делался — только 1 вызов
      verify(() => scheduleRepo.updateSchedule(any(), any())).called(1);
    });

    test('should_have_canSubmit_false_during_savingSchedules_state', () async {
      final addRepo = _MockAddPlantRepo();
      final scheduleRepo = _MockScheduleRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer((_) async => const Result.success(88));

      final scheduleCompleter = Completer<Result<PlantCareSchedule>>();
      when(() => scheduleRepo.updateSchedule(any(), any()))
          .thenAnswer((_) => scheduleCompleter.future);

      final container =
          _makeContainer(addPlantRepo: addRepo, scheduleRepo: scheduleRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesWatering);
      notifier.setIntervalOverride(CareTaskType.watering, 21);

      final submitFuture = notifier.submit(); // POST завершится, начнётся PUT

      // Ждём пока POST завершится и статус станет savingSchedules
      await Future<void>.microtask(() {});
      await Future<void>.microtask(() {});

      // В момент ожидания PUT canSubmit должен быть false
      final stateInFlight =
          container.read(addPlantWizardControllerProvider);
      expect(stateInFlight.status, isA<AddPlantSavingSchedules>());
      expect(stateInFlight.canSubmit, isFalse);

      scheduleCompleter.complete(
        Result.success(
          const PlantCareSchedule(
            type: CareTaskType.watering,
            rawType: 'WATERING',
            every: 21,
            unit: CareScheduleUnit.day,
            rawUnit: 'DAY',
            enabled: true,
          ),
        ),
      );
      await submitFuture;
    });

    test(
        'should_not_call_updateSchedule_at_all_when_post_plant_fails',
        () async {
      final addRepo = _MockAddPlantRepo();
      final scheduleRepo = _MockScheduleRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer(
              (_) async => const Result.failure(ApiError.network()));

      final container =
          _makeContainer(addPlantRepo: addRepo, scheduleRepo: scheduleRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_speciesWatering);
      notifier.setIntervalOverride(CareTaskType.watering, 21);

      final id = await notifier.submit();

      expect(id, isNull);
      expect(
        container.read(addPlantWizardControllerProvider).status,
        const AddPlantSubmitStatus.failure(ApiError.network()),
      );
      verifyNever(() => scheduleRepo.updateSchedule(any(), any()));
    });
  });

  group('setWindowSide (step 04c)', () {
    test('should_set_window_side_when_selected', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setWindowSide(WindowSide.south);

      expect(
        container.read(addPlantWizardControllerProvider).draft.windowSide,
        WindowSide.south,
      );
    });

    test('should_clear_window_side_when_same_side_tapped_again', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setWindowSide(WindowSide.west);
      notifier.setWindowSide(WindowSide.west);

      expect(
        container.read(addPlantWizardControllerProvider).draft.windowSide,
        isNull,
      );
    });

    test('should_replace_window_side_when_different_side_tapped', () {
      final container = _makeContainer();
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setWindowSide(WindowSide.east);
      notifier.setWindowSide(WindowSide.north);

      expect(
        container.read(addPlantWizardControllerProvider).draft.windowSide,
        WindowSide.north,
      );
    });

    test('should_not_send_window_side_to_createPlant_ui_only', () async {
      final addRepo = _MockAddPlantRepo();
      when(() => addRepo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer((_) async => const Result.success(1));

      final container = _makeContainer(addPlantRepo: addRepo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Моника');
      notifier.setWindowSide(WindowSide.south);

      await notifier.submit();

      // Сторона окна — UI-only: backend поля нет, в POST /plants не уходит.
      // createPlant вызывается без параметра стороны окна (его в сигнатуре нет).
      verify(() => addRepo.createPlant(
            name: 'Моника',
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).called(1);
    });
  });
}
