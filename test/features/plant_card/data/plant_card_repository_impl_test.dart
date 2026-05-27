import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plant_history_client.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plants_client.dart';
import 'package:plantcare_mobile/core/api/generated/clients/stats_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_history_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/streak_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/plant_card/data/plant_card_repository_impl.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockPlantsClient extends Mock implements PlantsClient {}

class _MockPlantHistoryClient extends Mock implements PlantHistoryClient {}

class _MockStatsClient extends Mock implements StatsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      error: error,
    );

void main() {
  late _MockApi api;
  late _MockPlantsClient plants;
  late _MockPlantHistoryClient history;
  late _MockStatsClient stats;
  late PlantCardRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    plants = _MockPlantsClient();
    history = _MockPlantHistoryClient();
    stats = _MockStatsClient();

    when(() => api.plants).thenReturn(plants);
    when(() => api.plantHistory).thenReturn(history);
    when(() => api.stats).thenReturn(stats);

    repo = PlantCardRepositoryImpl(api);
  });

  group('getPlant', () {
    test('should_return_success_with_mapped_plant_when_client_returns_dto',
        () async {
      when(() => plants.getPlant(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PlantDto(
          id: 42,
          name: 'Фикус',
          archived: false,
          speciesName: 'Ficus',
        ),
      );

      final result = await repo.getPlant(42);

      final plant = (result as Success).value;
      expect(plant.id, 42);
      expect(plant.name, 'Фикус');
      expect(plant.speciesName, 'Ficus');
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => plants.getPlant(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PlantDto(id: 42, name: 'x', archived: false),
      );

      await repo.getPlant(42);

      final captured = verify(() => plants.getPlant(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_notFound_when_DioException_carries_ApiError',
        () async {
      when(() => plants.getPlant(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.getPlant(42);

      expect((result as Failure).error, const ApiError.notFound());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => plants.getPlant(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('plain string'));

      final result = await repo.getPlant(42);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('getHistory', () {
    PlantHistoryResponse responseWith(List<CareEventResponse> items) =>
        PlantHistoryResponse(
          items: items,
          total: items.length,
          limit: 10,
          offset: 0,
        );

    test('should_return_success_with_mapped_entries', () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => responseWith([
          CareEventResponse(
            id: 1,
            plantId: 42,
            plantName: 'Фикус',
            type: CareEventType.water,
            performedAt: DateTime.utc(2026, 5, 27, 8),
            onTime: true,
          ),
        ]),
      );

      final result = await repo.getHistory(42);

      final entries = (result as Success).value;
      expect(entries, hasLength(1));
      expect(entries.single.kind, CareEventKind.water);
      expect(entries.single.plantName, 'Фикус');
    });

    test('should_send_chat_authScope_in_extras', () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => responseWith(const []));

      await repo.getHistory(42);

      final captured = verify(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.chat);
    });

    test('should_return_failure_network_when_DioException_carries_it',
        () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getHistory(42);

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(42));

      final result = await repo.getHistory(42);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('getStreak', () {
    test('should_return_success_with_mapped_streak', () async {
      when(() => stats.getPlantStreak(
            xChatId: any(named: 'xChatId'),
            plantId: any(named: 'plantId'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const StreakResponse(plantId: 42, streak: 9),
      );

      final result = await repo.getStreak(42);

      final streak = (result as Success).value;
      expect(streak.count, 9);
      expect(streak.plantId, 42);
    });

    test('should_send_chat_authScope_in_extras', () async {
      when(() => stats.getPlantStreak(
            xChatId: any(named: 'xChatId'),
            plantId: any(named: 'plantId'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const StreakResponse(plantId: 42, streak: 0),
      );

      await repo.getStreak(42);

      final captured = verify(() => stats.getPlantStreak(
            xChatId: any(named: 'xChatId'),
            plantId: any(named: 'plantId'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.chat);
    });

    test('should_return_failure_accessDenied_when_DioException_carries_it',
        () async {
      when(() => stats.getPlantStreak(
            xChatId: any(named: 'xChatId'),
            plantId: any(named: 'plantId'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.accessDenied()));

      final result = await repo.getStreak(42);

      expect((result as Failure).error, const ApiError.accessDenied());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => stats.getPlantStreak(
            xChatId: any(named: 'xChatId'),
            plantId: any(named: 'plantId'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(null));

      final result = await repo.getStreak(42);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
