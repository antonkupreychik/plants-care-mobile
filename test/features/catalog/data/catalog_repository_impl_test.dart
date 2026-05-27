import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/species_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/page_response_species_summary_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/species_detail_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/species_summary_dto.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/catalog/data/catalog_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockSpeciesClient extends Mock implements SpeciesClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/species'),
      error: error,
    );

const _page = PageResponseSpeciesSummaryDto(
  items: [SpeciesSummaryDto(id: 1, name: 'Монстера')],
  total: 1,
  offset: 0,
  limit: 20,
);

const _detail = SpeciesDetailDto(id: 5, name: 'Фикус');

void main() {
  late _MockApi api;
  late _MockSpeciesClient species;
  late CatalogRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    species = _MockSpeciesClient();
    when(() => api.species).thenReturn(species);
    repo = CatalogRepositoryImpl(api);
  });

  group('searchSpecies', () {
    test('should_return_success_with_mapped_page_when_client_returns_dto',
        () async {
      when(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _page);

      final result =
          await repo.searchSpecies(query: 'мон', offset: 0, limit: 20);

      final value = (result as Success).value;
      expect(value.items.single.id, 1);
      expect(value.items.single.name, 'Монстера');
      expect(value.total, 1);
    });

    test('should_forward_query_offset_limit_to_client', () async {
      when(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _page);

      await repo.searchSpecies(query: 'фикус', offset: 40, limit: 20);

      verify(() => species.listSpecies(
            q: 'фикус',
            offset: 40,
            limit: 20,
            extras: any(named: 'extras'),
          )).called(1);
    });

    // Auth-слот: публичный справочник НЕ должен утекать X-User-Id/X-Chat-Id.
    // Захватываем extras и проверяем, что scope = none.
    test('should_send_none_authScope_in_extras', () async {
      when(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _page);

      await repo.searchSpecies(query: '', offset: 0, limit: 20);

      final captured = verify(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.none);
    });

    test('should_return_failure_with_ApiError_when_DioException_carries_it',
        () async {
      when(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result =
          await repo.searchSpecies(query: '', offset: 0, limit: 20);

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('plain string'));

      final result =
          await repo.searchSpecies(query: '', offset: 0, limit: 20);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('getSpecies', () {
    test('should_return_success_with_mapped_detail', () async {
      when(() => species.getSpecies(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _detail);

      final result = await repo.getSpecies(5);

      final value = (result as Success).value;
      expect(value.id, 5);
      expect(value.name, 'Фикус');
    });

    test('should_forward_id_to_client', () async {
      when(() => species.getSpecies(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _detail);

      await repo.getSpecies(5);

      verify(() => species.getSpecies(id: 5, extras: any(named: 'extras')))
          .called(1);
    });

    // Auth-слот: деталь вида тоже публичная → scope none.
    test('should_send_none_authScope_in_extras', () async {
      when(() => species.getSpecies(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _detail);

      await repo.getSpecies(5);

      final captured = verify(() => species.getSpecies(
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.none);
    });

    test('should_return_failure_notFound_when_DioException_carries_it',
        () async {
      when(() => species.getSpecies(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.getSpecies(5);

      expect((result as Failure).error, const ApiError.notFound());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => species.getSpecies(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(null));

      final result = await repo.getSpecies(5);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
