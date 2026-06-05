import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/catalog/data/catalog_repository_provider.dart';
import 'package:plantcare_mobile/features/catalog/domain/catalog_repository.dart';
import 'package:plantcare_mobile/features/catalog/domain/species.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_page.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/search/presentation/search_providers.dart';

class _MockCatalogRepo extends Mock implements CatalogRepository {}

Plant _plant(int id, String name, {String? location}) =>
    Plant(id: id, name: name, locationName: location);

ProviderContainer _containerWith({
  List<Plant> plants = const [],
  CatalogRepository? repo,
}) {
  final container = ProviderContainer(
    overrides: [
      homePlantsProvider.overrideWith((ref) async => plants),
      if (repo != null) catalogRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('UnifiedSearchQuery', () {
    test('should_start_empty', () {
      final container = _containerWith();
      expect(container.read(unifiedSearchQueryProvider), '');
    });

    test('should_set_trimmed_query', () {
      final container = _containerWith();
      container.read(unifiedSearchQueryProvider.notifier).setQuery('  мон  ');
      expect(container.read(unifiedSearchQueryProvider), 'мон');
    });
  });

  group('plantSearchResultsProvider', () {
    test('should_return_empty_when_query_shorter_than_min_chars', () async {
      final container = _containerWith(
        plants: [_plant(1, 'Монстера'), _plant(2, 'Монарда')],
      );

      final result =
          await container.read(plantSearchResultsProvider('м').future);

      expect(result, isEmpty);
    });

    test('should_filter_by_name_case_insensitive', () async {
      final container = _containerWith(
        plants: [
          _plant(1, 'Монстера'),
          _plant(2, 'Фикус'),
          _plant(3, 'монарда'),
        ],
      );

      final result =
          await container.read(plantSearchResultsProvider('МОН').future);

      expect(result.map((p) => p.id), [1, 3]);
    });

    test('should_match_as_substring_not_only_prefix', () async {
      final container = _containerWith(
        plants: [_plant(1, 'Старая монстера'), _plant(2, 'Фикус')],
      );

      final result =
          await container.read(plantSearchResultsProvider('монс').future);

      expect(result.map((p) => p.id), [1]);
    });

    test('should_cap_results_at_three', () async {
      final container = _containerWith(
        plants: List.generate(10, (i) => _plant(i, 'Растение $i')),
      );

      final result =
          await container.read(plantSearchResultsProvider('раст').future);

      expect(result.length, 3);
    });

    test('should_return_empty_when_nothing_matches', () async {
      final container = _containerWith(
        plants: [_plant(1, 'Монстера')],
      );

      final result =
          await container.read(plantSearchResultsProvider('кактус').future);

      expect(result, isEmpty);
    });
  });

  group('speciesSearchResultsProvider', () {
    late _MockCatalogRepo repo;

    setUp(() => repo = _MockCatalogRepo());

    test('should_return_empty_without_request_when_query_too_short', () async {
      final container = _containerWith(repo: repo);

      final result =
          await container.read(speciesSearchResultsProvider('м').future);

      expect(result, isEmpty);
      verifyNever(() => repo.searchSpecies(
            query: any(named: 'query'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ));
    });

    test('should_request_species_with_limit_5', () async {
      when(() => repo.searchSpecies(
            query: 'мон',
            offset: 0,
            limit: kSearchResultsLimit,
          )).thenAnswer(
        (_) async => Result.success(
          SpeciesPage(
            items: [const Species(id: 7, name: 'Monstera')],
            total: 1,
            offset: 0,
            limit: kSearchResultsLimit,
          ),
        ),
      );
      final container = _containerWith(repo: repo);

      final result =
          await container.read(speciesSearchResultsProvider('мон').future);

      expect(result.map((s) => s.id), [7]);
      verify(() => repo.searchSpecies(
            query: 'мон',
            offset: 0,
            limit: kSearchResultsLimit,
          )).called(1);
    });

    test('should_throw_ApiError_into_AsyncError_on_failure', () async {
      when(() => repo.searchSpecies(
            query: any(named: 'query'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo: repo);

      // Подписка удерживает autoDispose-провайдер живым на время await
      // (иначе он утилизируется в loading и `.future` падает StateError).
      final completer = Completer<Object?>();
      final sub = container.listen(
        speciesSearchResultsProvider('мон'),
        (_, next) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        },
        fireImmediately: true,
      );
      addTearDown(sub.close);

      expect(await completer.future, const ApiError.network());
    });
  });

  group('diseaseSearchResultsProvider (stub до plants-care#225)', () {
    test('should_always_return_empty_list', () async {
      final container = _containerWith();

      final result =
          await container.read(diseaseSearchResultsProvider('клещ').future);

      expect(result, isEmpty);
    });
  });
}
