import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/disease_catalog/data/disease_catalog_repository_provider.dart';
import 'package:plantcare_mobile/features/disease_catalog/domain/disease.dart';
import 'package:plantcare_mobile/features/disease_catalog/domain/disease_repository.dart';
import 'package:plantcare_mobile/features/disease_catalog/presentation/disease_catalog_providers.dart';

class _MockRepo extends Mock implements DiseaseCatalogRepository {}

Disease _disease(int id, String name) => Disease(
      id: id,
      name: name,
      symptoms: 's',
      treatment: 't',
      prevention: 'p',
    );

ProviderContainer _containerWith(DiseaseCatalogRepository repo) {
  final container = ProviderContainer(
    overrides: [diseaseCatalogRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}


void main() {
  group('diseaseListProvider', () {
    test('empty_query_calls_getAll', () async {
      final repo = _MockRepo();
      when(repo.getAll)
          .thenAnswer((_) async => Result.success([_disease(1, 'A')]));
      final container = _containerWith(repo);

      final result = await container.read(diseaseListProvider.future);

      expect(result, hasLength(1));
      verify(repo.getAll).called(1);
      verifyNever(() => repo.search(any()));
    });

    test('query_below_min_length_calls_getAll_not_search', () async {
      final repo = _MockRepo();
      when(repo.getAll).thenAnswer((_) async => const Result.success([]));
      final container = _containerWith(repo);

      // 1 символ < kDiseaseSearchMinLength (2) → весь список.
      container.read(diseaseQueryProvider.notifier).setQuery('т');
      await container.read(diseaseListProvider.future);

      verify(repo.getAll).called(1);
      verifyNever(() => repo.search(any()));
    });

    test('query_at_min_length_calls_search', () async {
      final repo = _MockRepo();
      when(() => repo.search('тл'))
          .thenAnswer((_) async => Result.success([_disease(4, 'Тля')]));
      final container = _containerWith(repo);

      container.read(diseaseQueryProvider.notifier).setQuery('тл');
      final result = await container.read(diseaseListProvider.future);

      expect(result.single.name, 'Тля');
      verify(() => repo.search('тл')).called(1);
    });

    test('failure_becomes_AsyncError', () async {
      final repo = _MockRepo();
      when(repo.getAll)
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);

      final completer = Completer<Object?>();
      final sub = container.listen(diseaseListProvider, (_, next) {
        if (next.hasError && !completer.isCompleted) {
          completer.complete(next.error);
        }
      });
      addTearDown(sub.close);
      expect(await completer.future, isA<NetworkError>());
    });
  });

  group('diseaseDetailProvider', () {
    test('returns_disease_on_success', () async {
      final repo = _MockRepo();
      when(() => repo.getById(1))
          .thenAnswer((_) async => Result.success(_disease(1, 'A')));
      final container = _containerWith(repo);

      final result = await container.read(diseaseDetailProvider(1).future);

      expect(result.id, 1);
    });

    test('notFound_failure_becomes_AsyncError', () async {
      final repo = _MockRepo();
      when(() => repo.getById(9))
          .thenAnswer((_) async => const Result.failure(ApiError.notFound()));
      final container = _containerWith(repo);

      final completer = Completer<Object?>();
      final sub = container.listen(diseaseDetailProvider(9), (_, next) {
        if (next.hasError && !completer.isCompleted) {
          completer.complete(next.error);
        }
      });
      addTearDown(sub.close);
      expect(await completer.future, isA<NotFoundError>());
    });
  });
}
