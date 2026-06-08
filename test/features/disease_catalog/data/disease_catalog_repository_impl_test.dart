import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/diseases_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/disease_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/page_response_disease_dto.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/disease_catalog/data/disease_catalog_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockDiseasesClient extends Mock implements DiseasesClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/diseases'),
      error: error,
    );

const _pageOne = PageResponseDiseaseDto(
  items: [
    DiseaseDto(
      id: 1,
      name: 'Паутинный клещ',
      latinName: 'Tetranychus urticae',
      symptoms: 'Пятна',
      treatment: 'Акарицид',
      prevention: 'Влажность',
    ),
  ],
  total: 1,
  offset: 0,
  limit: 100,
);

const _detailDto = DiseaseDto(
  id: 3,
  name: 'Мучнистый червец',
  symptoms: 'Белый налёт',
  treatment: 'Спирт',
  prevention: 'Не переувлажнять',
);

void main() {
  late _MockApi api;
  late _MockDiseasesClient diseases;
  late DiseaseCatalogRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    diseases = _MockDiseasesClient();
    when(() => api.diseases).thenReturn(diseases);
    repo = DiseaseCatalogRepositoryImpl(api);
  });

  group('getAll', () {
    test('returns_success_with_mapped_list', () async {
      when(() => diseases.listDiseases(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _pageOne);

      final result = await repo.getAll();

      final value = (result as Success).value;
      expect(value.single.id, 1);
      expect(value.single.name, 'Паутинный клещ');
      expect(value.single.latinName, 'Tetranychus urticae');
    });

    test('sends_empty_q_and_limit100', () async {
      when(() => diseases.listDiseases(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _pageOne);

      await repo.getAll();

      verify(() => diseases.listDiseases(
            q: '',
            offset: 0,
            limit: 100,
            extras: any(named: 'extras'),
          )).called(1);
    });

    test('sends_none_authScope', () async {
      when(() => diseases.listDiseases(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _pageOne);

      await repo.getAll();

      final captured = verify(() => diseases.listDiseases(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.none);
    });

    test('returns_failure_with_ApiError_from_DioException', () async {
      when(() => diseases.listDiseases(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getAll();

      expect((result as Failure).error, const ApiError.network());
    });

    test('returns_failure_unknown_when_DioException_error_is_not_ApiError',
        () async {
      when(() => diseases.listDiseases(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('plain string'));

      final result = await repo.getAll();

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('search', () {
    test('forwards_query_to_server_q_parameter', () async {
      when(() => diseases.listDiseases(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _pageOne);

      await repo.search('клещ');

      verify(() => diseases.listDiseases(
            q: 'клещ',
            offset: 0,
            limit: 100,
            extras: any(named: 'extras'),
          )).called(1);
    });

    test('returns_success_with_mapped_list', () async {
      when(() => diseases.listDiseases(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _pageOne);

      final result = await repo.search('клещ');

      expect((result as Success).value, hasLength(1));
    });

    test('returns_failure_on_DioException', () async {
      when(() => diseases.listDiseases(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.unknown()));

      final result = await repo.search('тля');

      expect(result, isA<Failure>());
    });
  });

  group('getById', () {
    test('returns_success_with_mapped_disease', () async {
      when(() => diseases.getDiseaseById(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _detailDto);

      final result = await repo.getById(3);

      final value = (result as Success).value;
      expect(value.id, 3);
      expect(value.name, 'Мучнистый червец');
    });

    test('forwards_id_to_client', () async {
      when(() => diseases.getDiseaseById(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _detailDto);

      await repo.getById(3);

      verify(() => diseases.getDiseaseById(
            id: 3,
            extras: any(named: 'extras'),
          )).called(1);
    });

    test('sends_none_authScope', () async {
      when(() => diseases.getDiseaseById(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _detailDto);

      await repo.getById(3);

      final captured = verify(() => diseases.getDiseaseById(
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.none);
    });

    test('returns_failure_notFound_on_DioException', () async {
      when(() => diseases.getDiseaseById(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.getById(999);

      expect((result as Failure).error, const ApiError.notFound());
    });

    test('returns_failure_unknown_when_DioException_error_is_not_ApiError',
        () async {
      when(() => diseases.getDiseaseById(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(null));

      final result = await repo.getById(999);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
