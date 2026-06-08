import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_templates/data/plant_template_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_templates/domain/plant_template.dart';
import 'package:plantcare_mobile/features/plant_templates/domain/plant_template_repository.dart';
import 'package:plantcare_mobile/features/plant_templates/presentation/plant_templates_controller.dart';

class _MockRepo extends Mock implements PlantTemplateRepository {}

// Фабрика тестовых шаблонов с корректным createdAt.
PlantTemplate _t(int id, String name) => PlantTemplate(
      id: id,
      name: name,
      careRules: const [],
      createdAt: DateTime.utc(2026, 1, id),
    );

Plant _plant(int id) => Plant(id: id, name: 'plant$id');

ProviderContainer _container(_MockRepo repo) {
  final container = ProviderContainer(
    overrides: [
      plantTemplateRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  // ─── initial load ────────────────────────────────────────────────────────

  group('initial load', () {
    test('should_expose_list_when_repo_returns_success', () async {
      when(repo.getTemplates).thenAnswer(
        (_) async => Result.success([_t(1, 'Суккулент'), _t(2, 'Фикус')]),
      );
      final container = _container(repo);

      final list = await container.read(plantTemplatesControllerProvider.future);

      expect(list.map((t) => t.name), ['Суккулент', 'Фикус']);
    });

    test('should_expose_AsyncError_with_ApiError_when_repo_fails', () async {
      when(repo.getTemplates)
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);

      final states = <AsyncValue<List<PlantTemplate>>>[];
      final sub = container.listen(
        plantTemplatesControllerProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      addTearDown(sub.close);
      expect(states.first.isLoading, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(plantTemplatesControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error, const ApiError.network());
    });
  });

  // ─── create ──────────────────────────────────────────────────────────────

  group('create', () {
    test('should_return_success_and_refetch_list', () async {
      var calls = 0;
      when(repo.getTemplates).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? Result.success([_t(1, 'Суккулент')])
            : Result.success([_t(1, 'Суккулент'), _t(2, 'Фикус')]);
      });
      when(() => repo.createTemplate(
            name: any(named: 'name'),
            fromPlantId: any(named: 'fromPlantId'),
          )).thenAnswer((_) async => Result.success(_t(2, 'Фикус')));
      final container = _container(repo);
      await container.read(plantTemplatesControllerProvider.future);

      final result = await container
          .read(plantTemplatesControllerProvider.notifier)
          .create(name: 'Фикус');

      expect(result, isA<Success<PlantTemplate>>());
      final list = container.read(plantTemplatesControllerProvider).value;
      expect(list?.length, 2);
    });

    test('should_not_refetch_on_failure', () async {
      when(repo.getTemplates).thenAnswer(
        (_) async => Result.success([_t(1, 'Суккулент')]),
      );
      when(() => repo.createTemplate(
            name: any(named: 'name'),
            fromPlantId: any(named: 'fromPlantId'),
          )).thenAnswer(
        (_) async => const Result.failure(ApiError.badRequest()),
      );
      final container = _container(repo);
      await container.read(plantTemplatesControllerProvider.future);

      final result = await container
          .read(plantTemplatesControllerProvider.notifier)
          .create(name: 'x');

      expect(result, isA<Failure<PlantTemplate>>());
      // getTemplates вызвался только один раз (начальная загрузка).
      verify(repo.getTemplates).called(1);
    });

    test('should_pass_fromPlantId_to_repo', () async {
      when(repo.getTemplates).thenAnswer(
        (_) async => Result.success([_t(1, 'Суккулент')]),
      );
      when(() => repo.createTemplate(
            name: any(named: 'name'),
            fromPlantId: any(named: 'fromPlantId'),
          )).thenAnswer((_) async => Result.success(_t(3, 'С растения')));
      final container = _container(repo);
      await container.read(plantTemplatesControllerProvider.future);

      // Второй вызов getTemplates для рефетча.
      when(repo.getTemplates).thenAnswer(
        (_) async => Result.success([_t(1, 'Суккулент'), _t(3, 'С растения')]),
      );

      await container
          .read(plantTemplatesControllerProvider.notifier)
          .create(name: 'С растения', fromPlantId: 99);

      final captured = verify(() => repo.createTemplate(
            name: captureAny(named: 'name'),
            fromPlantId: captureAny(named: 'fromPlantId'),
          )).captured;
      expect(captured[0], 'С растения');
      expect(captured[1], 99);
    });
  });

  // ─── delete ───────────────────────────────────────────────────────────────

  group('delete', () {
    test('should_return_success_and_refetch_list', () async {
      var calls = 0;
      when(repo.getTemplates).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? Result.success([_t(1, 'Суккулент'), _t(2, 'Фикус')])
            : Result.success([_t(2, 'Фикус')]);
      });
      when(() => repo.deleteTemplate(any())).thenAnswer(
        (_) async => const Result.success(null),
      );
      final container = _container(repo);
      await container.read(plantTemplatesControllerProvider.future);

      final result = await container
          .read(plantTemplatesControllerProvider.notifier)
          .delete(1);

      expect(result, isA<Success<void>>());
      final list = container.read(plantTemplatesControllerProvider).value;
      expect(list?.length, 1);
    });

    test('should_return_failure_notFound_and_not_refetch', () async {
      when(repo.getTemplates).thenAnswer(
        (_) async => Result.success([_t(1, 'Суккулент')]),
      );
      when(() => repo.deleteTemplate(any())).thenAnswer(
        (_) async => const Result.failure(ApiError.notFound()),
      );
      final container = _container(repo);
      await container.read(plantTemplatesControllerProvider.future);

      final result = await container
          .read(plantTemplatesControllerProvider.notifier)
          .delete(999);

      expect((result as Failure).error, const ApiError.notFound());
      // getTemplates вызвался только один раз (начальная загрузка).
      verify(repo.getTemplates).called(1);
    });
  });

  // ─── instantiate ─────────────────────────────────────────────────────────

  group('instantiate', () {
    test('should_return_success_plant_and_not_refetch_templates', () async {
      when(repo.getTemplates).thenAnswer(
        (_) async => Result.success([_t(1, 'Суккулент')]),
      );
      when(() => repo.instantiateTemplate(
            templateId: any(named: 'templateId'),
            plantName: any(named: 'plantName'),
          )).thenAnswer((_) async => Result.success(_plant(42)));
      final container = _container(repo);
      await container.read(plantTemplatesControllerProvider.future);

      final result = await container
          .read(plantTemplatesControllerProvider.notifier)
          .instantiate(templateId: 1, plantName: 'Монстера');

      expect(result, isA<Success<Plant>>());
      expect((result as Success).value.name, 'plant42');
      // Шаблоны не рефетчатся при инстанцировании (шаблон остаётся).
      verify(repo.getTemplates).called(1);
    });

    test('should_pass_templateId_and_plantName_to_repo', () async {
      when(repo.getTemplates).thenAnswer(
        (_) async => Result.success([_t(1, 'Суккулент')]),
      );
      when(() => repo.instantiateTemplate(
            templateId: any(named: 'templateId'),
            plantName: any(named: 'plantName'),
          )).thenAnswer((_) async => Result.success(_plant(5)));
      final container = _container(repo);
      await container.read(plantTemplatesControllerProvider.future);

      await container
          .read(plantTemplatesControllerProvider.notifier)
          .instantiate(templateId: 1, plantName: 'Кактус');

      final captured = verify(() => repo.instantiateTemplate(
            templateId: captureAny(named: 'templateId'),
            plantName: captureAny(named: 'plantName'),
          )).captured;
      expect(captured[0], 1);
      expect(captured[1], 'Кактус');
    });

    test('should_return_failure_when_repo_fails', () async {
      when(repo.getTemplates).thenAnswer(
        (_) async => Result.success([_t(1, 'Суккулент')]),
      );
      when(() => repo.instantiateTemplate(
            templateId: any(named: 'templateId'),
            plantName: any(named: 'plantName'),
          )).thenAnswer(
        (_) async => const Result.failure(ApiError.badRequest()),
      );
      final container = _container(repo);
      await container.read(plantTemplatesControllerProvider.future);

      final result = await container
          .read(plantTemplatesControllerProvider.notifier)
          .instantiate(templateId: 1, plantName: 'Монстера');

      expect(result, isA<Failure<Plant>>());
    });
  });
}
