import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/add_plant/data/add_plant_repository_provider.dart';
import 'package:plantcare_mobile/features/add_plant/domain/add_plant_repository.dart';
import 'package:plantcare_mobile/features/add_plant/domain/species_summary.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_controller.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_state.dart';
import 'package:plantcare_mobile/features/home/data/home_repository_provider.dart';
import 'package:plantcare_mobile/features/home/domain/home_repository.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';

class _MockRepo extends Mock implements AddPlantRepository {}

class _MockHomeRepo extends Mock implements HomeRepository {}

const _species = SpeciesSummary(id: 7, name: 'Фикус', wateringDays: 7);

ProviderContainer _container(_MockRepo repo) {
  final container = ProviderContainer(
    overrides: [addPlantRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  group('initial state', () {
    test('should_start_idle_with_empty_draft_and_canSubmit_false', () {
      final container = _container(repo);

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
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.selectSpecies(_species);

      final draft = container.read(addPlantWizardControllerProvider).draft;
      expect(draft.species, _species);
      expect(draft.name, 'Фикус');
    });

    test('should_not_overwrite_manually_entered_name', () {
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Моё растение');

      notifier.selectSpecies(_species);

      final draft = container.read(addPlantWizardControllerProvider).draft;
      expect(draft.species, _species);
      expect(draft.name, 'Моё растение');
    });
  });

  group('setters', () {
    test('should_update_name', () {
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setName('Алоэ');

      expect(container.read(addPlantWizardControllerProvider).draft.name, 'Алоэ');
    });

    test('should_update_location', () {
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setLocation(42);

      expect(
        container.read(addPlantWizardControllerProvider).draft.locationId,
        42,
      );
    });

    test('should_store_notes_and_trim', () {
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setNotes('  на окне  ');

      expect(
        container.read(addPlantWizardControllerProvider).draft.notes,
        'на окне',
      );
    });

    test('should_set_notes_null_when_blank', () {
      final container = _container(repo);
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
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setName('   ');

      expect(container.read(addPlantWizardControllerProvider).canSubmit, isFalse);
    });

    test('should_be_true_when_name_valid_and_idle', () {
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);

      notifier.setName('Фикус');

      expect(container.read(addPlantWizardControllerProvider).canSubmit, isTrue);
    });
  });

  group('submit success', () {
    test('should_call_repo_with_trimmed_draft_and_set_success_status',
        () async {
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async => const Result.success(99));
      final container = _container(repo);
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

      verify(() => repo.createPlant(
            name: 'Фикус',
            locationId: 3,
            notes: 'на окне',
          )).called(1);
    });

    test('should_not_call_repo_when_canSubmit_false', () async {
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      // Имя пустое → canSubmit false.

      final id = await notifier.submit();

      expect(id, isNull);
      verifyNever(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          ));
    });

    test('should_not_call_repo_second_time_while_first_submit_in_flight',
        () async {
      final completer = Completer<Result<int>>();
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) => completer.future);
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Фикус');

      final first = notifier.submit(); // submitting, не ждём
      final second = await notifier.submit();

      expect(second, isNull);
      verify(() => repo.createPlant(
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
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer((_) async => const Result.success(99));
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.selectSpecies(_species); // id == 7, префиллит имя

      await notifier.submit();

      // G13a: id выбранного вида уходит в репозиторий.
      final speciesId = verify(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: captureAny(named: 'speciesId'),
          )).captured.single;
      expect(speciesId, _species.id);
      expect(speciesId, 7);
    });

    test('should_pass_null_species_id_when_no_species_chosen', () async {
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
          )).thenAnswer((_) async => const Result.success(99));
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Безымянное'); // вид не выбран → draft.species == null

      await notifier.submit();

      final speciesId = verify(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: captureAny(named: 'speciesId'),
          )).captured.single;
      expect(speciesId, isNull);
    });
  });

  group('submit failure', () {
    test('should_set_failure_status_and_allow_retry', () async {
      var calls = 0;
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Result.failure(ApiError.network())
            : const Result.success(5);
      });
      final container = _container(repo);
      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Фикус');

      final firstId = await notifier.submit();

      expect(firstId, isNull);
      expect(
        container.read(addPlantWizardControllerProvider).status,
        const AddPlantSubmitStatus.failure(ApiError.network()),
      );
      // После failure canSubmit снова true → повторный submit возможен.
      expect(container.read(addPlantWizardControllerProvider).canSubmit, isTrue);

      final secondId = await notifier.submit();

      expect(secondId, 5);
      verify(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).called(2);
    });
  });

  group('home invalidation after success', () {
    test('should_refetch_homePlants_after_successful_submit', () async {
      when(() => repo.createPlant(
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
          addPlantRepositoryProvider.overrideWithValue(repo),
          homeRepositoryProvider.overrideWithValue(homeRepo),
        ],
      );
      addTearDown(container.dispose);

      // Держим подписку, чтобы AutoDispose homePlants не диспоузился между
      // первичным чтением и инвалидацией (тогда invalidate перезапросит).
      final keep = container.listen(homePlantsProvider, (_, _) {});
      addTearDown(keep.close);

      // Первичная загрузка сада.
      await container.read(homePlantsProvider.future);
      verify(homeRepo.getPlants).called(1);

      final notifier =
          container.read(addPlantWizardControllerProvider.notifier);
      notifier.setName('Фикус');
      await notifier.submit();

      // Контроллер инвалидировал homePlants → повторный fetch.
      await container.read(homePlantsProvider.future);
      verify(homeRepo.getPlants).called(1);
    });
  });
}
