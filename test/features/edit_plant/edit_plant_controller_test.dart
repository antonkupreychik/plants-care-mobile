import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/edit_plant/data/edit_plant_repository_provider.dart';
import 'package:plantcare_mobile/features/edit_plant/domain/edit_plant_draft.dart';
import 'package:plantcare_mobile/features/edit_plant/domain/edit_plant_repository.dart';
import 'package:plantcare_mobile/features/edit_plant/presentation/edit_plant_controller.dart';
import 'package:plantcare_mobile/features/edit_plant/presentation/edit_plant_state.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/data/plant_card_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/plant_card_repository.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';

class _MockPlantCardRepo extends Mock implements PlantCardRepository {}

class _MockEditPlantRepo extends Mock implements EditPlantRepository {}

class _FakeEditPlantDraft extends Fake implements EditPlantDraft {}

const _plant = Plant(
  id: 42,
  name: 'Монстера',
  notes: 'Стоит у окна',
  locationId: 7,
  speciesId: null,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeEditPlantDraft());
  });

  late _MockPlantCardRepo plantCardRepo;
  late _MockEditPlantRepo editPlantRepo;

  setUp(() {
    plantCardRepo = _MockPlantCardRepo();
    editPlantRepo = _MockEditPlantRepo();

    // Дефолт: успешная загрузка растения.
    when(() => plantCardRepo.getPlant(any())).thenAnswer(
      (_) async => const Result.success(_plant),
    );
    when(() => plantCardRepo.getHistory(any())).thenAnswer(
      (_) async => const Result.success(<CareHistoryEntry>[]),
    );
    when(() => plantCardRepo.getStreak(any())).thenAnswer(
      (_) async =>
          const Result.success(Streak(plantId: 42, count: 0)),
    );
    when(() => plantCardRepo.getPlantHealth(any())).thenAnswer(
      (_) async => throw UnimplementedError(),
    );
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        plantCardRepositoryProvider.overrideWithValue(plantCardRepo),
        editPlantRepositoryProvider.overrideWithValue(editPlantRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('build', () {
    test('загружает данные растения и инициализирует черновик', () async {
      final container = makeContainer();

      // Ждём загрузки.
      final state = await container
          .read(editPlantControllerProvider(42).future);

      expect(state.draft.name, equals('Монстера'));
      expect(state.draft.notes, equals('Стоит у окна'));
      expect(state.draft.locationId, equals(7));
      expect(state.isDirty, isFalse);
    });

    test('переходит в AsyncError(ApiError) при ошибке загрузки', () async {
      when(() => plantCardRepo.getPlant(any())).thenAnswer(
        (_) async => const Result.failure(ApiError.notFound()),
      );
      final container = makeContainer();

      // Подписываемся, чтобы provider не был dispose'н, и сохраняем
      // SubscriptionHandle, чтобы подписка жила до конца теста.
      final states = <AsyncValue<EditPlantState>>[];
      final sub = container.listen(
        editPlantControllerProvider(42),
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      addTearDown(sub.close);

      // Ждём завершения (loading → error).
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final last = container.read(editPlantControllerProvider(42));
      expect(last.hasError, isTrue);
      expect(last.error, isA<ApiError>());
    });
  });

  group('dirty flag', () {
    test('isDirty = false при исходных данных', () async {
      final container = makeContainer();
      final state =
          await container.read(editPlantControllerProvider(42).future);
      expect(state.isDirty, isFalse);
    });

    test('isDirty = true после изменения имени', () async {
      final container = makeContainer();
      await container.read(editPlantControllerProvider(42).future);

      container
          .read(editPlantControllerProvider(42).notifier)
          .setName('Монстера 2');

      final updated = container.read(editPlantControllerProvider(42)).value!;
      expect(updated.isDirty, isTrue);
    });

    test('isDirty = false если имя вернули к исходному', () async {
      final container = makeContainer();
      await container.read(editPlantControllerProvider(42).future);

      container
          .read(editPlantControllerProvider(42).notifier)
          .setName('Монстера 2');
      container
          .read(editPlantControllerProvider(42).notifier)
          .setName('Монстера');

      final updated = container.read(editPlantControllerProvider(42)).value!;
      expect(updated.isDirty, isFalse);
    });

    test('isDirty = true после изменения заметки', () async {
      final container = makeContainer();
      await container.read(editPlantControllerProvider(42).future);

      container
          .read(editPlantControllerProvider(42).notifier)
          .setNotes('Новая заметка');

      final updated = container.read(editPlantControllerProvider(42)).value!;
      expect(updated.isDirty, isTrue);
    });

    test('isDirty = true после изменения локации', () async {
      final container = makeContainer();
      await container.read(editPlantControllerProvider(42).future);

      container
          .read(editPlantControllerProvider(42).notifier)
          .setLocation(99);

      final updated = container.read(editPlantControllerProvider(42)).value!;
      expect(updated.isDirty, isTrue);
    });
  });

  group('name validation', () {
    test('isNameValid = false для пустого имени', () async {
      final container = makeContainer();
      await container.read(editPlantControllerProvider(42).future);

      container
          .read(editPlantControllerProvider(42).notifier)
          .setName('');

      final updated = container.read(editPlantControllerProvider(42)).value!;
      expect(updated.isNameValid, isFalse);
      expect(updated.canSave, isFalse);
    });

    test('isNameValid = false для имени из пробелов', () async {
      final container = makeContainer();
      await container.read(editPlantControllerProvider(42).future);

      container
          .read(editPlantControllerProvider(42).notifier)
          .setName('   ');

      final updated = container.read(editPlantControllerProvider(42)).value!;
      expect(updated.isNameValid, isFalse);
    });

    test('isNameValid = true для валидного имени', () async {
      final container = makeContainer();
      final state =
          await container.read(editPlantControllerProvider(42).future);
      expect(state.isNameValid, isTrue);
    });
  });

  group('submit', () {
    test('успешный submit: статус success, провайдеры инвалидируются', () async {
      // Мокаем updatePlant — возвращаем обновлённое растение.
      when(
        () => editPlantRepo.updatePlant(any(), any()),
      ).thenAnswer(
        (_) async => const Result.success(
          Plant(id: 42, name: 'Монстера 2'),
        ),
      );

      final container = makeContainer();
      await container.read(editPlantControllerProvider(42).future);

      // Делаем dirty.
      container
          .read(editPlantControllerProvider(42).notifier)
          .setName('Монстера 2');

      // Вызываем submit.
      await container
          .read(editPlantControllerProvider(42).notifier)
          .submit();

      final updated = container.read(editPlantControllerProvider(42)).value!;
      expect(updated.submitStatus, equals(SubmitStatus.success));
      expect(updated.submitError, isNull);
    });

    test('submit не вызывает API если данные не изменены (canSave = false)',
        () async {
      final container = makeContainer();
      await container.read(editPlantControllerProvider(42).future);

      // Данные не изменены — canSave = false.
      await container
          .read(editPlantControllerProvider(42).notifier)
          .submit();

      // API вызван не должен быть.
      verifyNever(() => editPlantRepo.updatePlant(any(), any()));
    });

    test('submit при ошибке API: статус failure, submitError заполнен',
        () async {
      when(() => editPlantRepo.updatePlant(any(), any())).thenAnswer(
        (_) async => const Result.failure(ApiError.network()),
      );

      final container = makeContainer();
      await container.read(editPlantControllerProvider(42).future);

      // Делаем dirty.
      container
          .read(editPlantControllerProvider(42).notifier)
          .setName('Монстера 2');

      await container
          .read(editPlantControllerProvider(42).notifier)
          .submit();

      final updated = container.read(editPlantControllerProvider(42)).value!;
      expect(updated.submitStatus, equals(SubmitStatus.failure));
      expect(updated.submitError, isA<ApiError>());
    });
  });
}
