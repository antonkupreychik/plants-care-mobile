import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plant_templates_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_template_care_rule_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_template_care_rule_dto_care_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_template_create_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_template_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_template_instantiate_request.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/plant_templates/data/plant_template_repository_impl.dart';
import 'package:plantcare_mobile/features/plant_templates/domain/plant_template.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockPlantTemplatesClient extends Mock implements PlantTemplatesClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/plant-templates'),
      error: error,
    );

/// Фабрика тестового DTO шаблона.
PlantTemplateDto _templateDto({
  int id = 1,
  String name = 'Суккулент',
  List<PlantTemplateCareRuleDto> careRules = const [],
}) =>
    PlantTemplateDto(
      id: id,
      name: name,
      careRules: careRules,
      createdAt: DateTime.utc(2026, 1, 1),
    );

PlantTemplateCareRuleDto _ruleDto(
  PlantTemplateCareRuleDtoCareType careType,
  int intervalDays,
) =>
    PlantTemplateCareRuleDto(careType: careType, intervalDays: intervalDays);

void main() {
  setUpAll(() {
    registerFallbackValue(const PlantTemplateCreateRequest(name: 'x'));
    registerFallbackValue(const PlantTemplateInstantiateRequest(name: 'x'));
  });

  late _MockApi api;
  late _MockPlantTemplatesClient client;
  late PlantTemplateRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    client = _MockPlantTemplatesClient();
    when(() => api.plantTemplates).thenReturn(client);
    repo = PlantTemplateRepositoryImpl(api);
  });

  // ─── getTemplates ─────────────────────────────────────────────────────────

  group('getTemplates', () {
    test(
        'should_return_success_with_mapped_templates_when_client_returns_dtos',
        () async {
      final ruleDto = _ruleDto(
        PlantTemplateCareRuleDtoCareType.watering,
        7,
      );
      when(() => client.listPlantTemplates(
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => [_templateDto(id: 1, name: 'Тест', careRules: [ruleDto])],
      );

      final result = await repo.getTemplates();

      final list = (result as Success).value;
      expect(list, hasLength(1));
      expect(list.first.id, 1);
      expect(list.first.name, 'Тест');
      expect(list.first.careRules, hasLength(1));
      expect(
          list.first.careRules.first.careType, PlantTemplateCareType.watering);
      expect(list.first.careRules.first.intervalDays, 7);
    });

    test('should_return_empty_list_when_client_returns_empty', () async {
      when(() => client.listPlantTemplates(
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => []);

      final result = await repo.getTemplates();

      expect((result as Success).value, isEmpty);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.listPlantTemplates(
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => []);

      await repo.getTemplates();

      final captured = verify(() => client.listPlantTemplates(
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_network_when_DioException_carries_it',
        () async {
      when(() => client.listPlantTemplates(
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getTemplates();

      expect((result as Failure).error, const ApiError.network());
    });

    test(
        'should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => client.listPlantTemplates(
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('plain string'));

      final result = await repo.getTemplates();

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  // ─── createTemplate ───────────────────────────────────────────────────────

  group('createTemplate', () {
    test('should_return_success_and_pass_name_to_client', () async {
      when(() => client.createPlantTemplate(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _templateDto(id: 5, name: 'Фикус'));

      final result = await repo.createTemplate(name: 'Фикус');

      final created = (result as Success).value;
      expect(created.id, 5);
      expect(created.name, 'Фикус');

      final body = verify(() => client.createPlantTemplate(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as PlantTemplateCreateRequest;
      expect(body.name, 'Фикус');
      expect(body.fromPlantId, isNull);
    });

    test('should_pass_fromPlantId_when_provided', () async {
      when(() => client.createPlantTemplate(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _templateDto(id: 6, name: 'Монстера'));

      await repo.createTemplate(name: 'Монстера', fromPlantId: 42);

      final body = verify(() => client.createPlantTemplate(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as PlantTemplateCreateRequest;
      expect(body.fromPlantId, 42);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.createPlantTemplate(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _templateDto());

      await repo.createTemplate(name: 'x');

      final captured = verify(() => client.createPlantTemplate(
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_badRequest_on_name_limit_exceeded', () async {
      when(() => client.createPlantTemplate(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(
        _dioWith(const ApiError.badRequest(message: 'name too long')),
      );

      final result = await repo.createTemplate(name: 'x' * 41);

      expect(
        (result as Failure).error,
        const ApiError.badRequest(message: 'name too long'),
      );
    });
  });

  // ─── deleteTemplate ───────────────────────────────────────────────────────

  group('deleteTemplate', () {
    test('should_return_success_when_client_completes', () async {
      when(() => client.deletePlantTemplate(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      final result = await repo.deleteTemplate(7);

      expect(result, isA<Success<void>>());
    });

    test('should_pass_id_to_client', () async {
      when(() => client.deletePlantTemplate(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      await repo.deleteTemplate(7);

      final captured = verify(() => client.deletePlantTemplate(
            id: captureAny(named: 'id'),
            extras: any(named: 'extras'),
          )).captured.single as int;
      expect(captured, 7);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.deletePlantTemplate(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      await repo.deleteTemplate(7);

      final captured = verify(() => client.deletePlantTemplate(
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_notFound_when_DioException_carries_it',
        () async {
      when(() => client.deletePlantTemplate(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.deleteTemplate(999);

      expect((result as Failure).error, const ApiError.notFound());
    });
  });

  // ─── instantiateTemplate ─────────────────────────────────────────────────

  group('instantiateTemplate', () {
    test('should_return_success_with_plant_when_client_returns_dto', () async {
      const plantDto = PlantDto(id: 10, name: 'Монстера', archived: false);
      when(() => client.instantiatePlantTemplate(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => plantDto);

      final result = await repo.instantiateTemplate(
        templateId: 1,
        plantName: 'Монстера',
      );

      final plant = (result as Success).value;
      expect(plant.id, 10);
      expect(plant.name, 'Монстера');
    });

    test('should_pass_templateId_and_plantName_to_client', () async {
      const plantDto = PlantDto(id: 10, name: 'Кактус', archived: false);
      when(() => client.instantiatePlantTemplate(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => plantDto);

      await repo.instantiateTemplate(templateId: 3, plantName: 'Кактус');

      final capturedList = verify(() => client.instantiatePlantTemplate(
            id: captureAny(named: 'id'),
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured;
      expect(capturedList[0], 3);
      expect((capturedList[1] as PlantTemplateInstantiateRequest).name, 'Кактус');
    });

    test('should_send_user_authScope_in_extras', () async {
      const plantDto = PlantDto(id: 10, name: 'x', archived: false);
      when(() => client.instantiatePlantTemplate(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => plantDto);

      await repo.instantiateTemplate(templateId: 1, plantName: 'x');

      final captured = verify(() => client.instantiatePlantTemplate(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_badRequest_on_server_error', () async {
      when(() => client.instantiatePlantTemplate(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(
        _dioWith(const ApiError.badRequest(message: 'too many plants')),
      );

      final result = await repo.instantiateTemplate(
        templateId: 1,
        plantName: 'Монстера',
      );

      expect(
        (result as Failure).error,
        const ApiError.badRequest(message: 'too many plants'),
      );
    });
  });

  // ─── mapper: care type ────────────────────────────────────────────────────

  group('care type mapper', () {
    test('should_map_all_known_care_types_correctly', () async {
      final dtos = PlantTemplateCareRuleDtoCareType.$valuesDefined.map(
        (t) => _ruleDto(t, 1),
      );
      when(() => client.listPlantTemplates(
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => [_templateDto(careRules: dtos.toList())],
      );

      final result = await repo.getTemplates();
      final rules = (result as Success).value.first.careRules;

      final types = rules.map((r) => r.careType).toList();
      expect(types, contains(PlantTemplateCareType.watering));
      expect(types, contains(PlantTemplateCareType.misting));
      expect(types, contains(PlantTemplateCareType.fertilizing));
      expect(types, contains(PlantTemplateCareType.soilCheck));
    });

    test('should_map_unknown_care_type_to_domain_unknown', () async {
      final ruleDto =
          _ruleDto(PlantTemplateCareRuleDtoCareType.$unknown, 3);
      when(() => client.listPlantTemplates(
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => [_templateDto(careRules: [ruleDto])],
      );

      final result = await repo.getTemplates();
      final rule = (result as Success).value.first.careRules.first;

      expect(rule.careType, PlantTemplateCareType.unknown);
    });
  });
}
