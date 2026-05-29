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
import 'package:plantcare_mobile/features/care_history/data/care_history_repository_impl.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockPlantsClient extends Mock implements PlantsClient {}

class _MockPlantHistoryClient extends Mock implements PlantHistoryClient {}

class _MockStatsClient extends Mock implements StatsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      error: error,
    );

CareEventResponse _event(int id) => CareEventResponse(
      id: id,
      plantId: 42,
      plantName: 'Фикус',
      type: CareEventType.water,
      performedAt: DateTime.utc(2026, 5, 27, 8),
      onTime: true,
    );

void main() {
  late _MockApi api;
  late _MockPlantsClient plants;
  late _MockPlantHistoryClient history;
  late _MockStatsClient stats;
  late CareHistoryRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    plants = _MockPlantsClient();
    history = _MockPlantHistoryClient();
    stats = _MockStatsClient();

    when(() => api.plants).thenReturn(plants);
    when(() => api.plantHistory).thenReturn(history);
    when(() => api.stats).thenReturn(stats);

    repo = CareHistoryRepositoryImpl(api);
  });

  PlantHistoryResponse responseWith(
    List<CareEventResponse> items, {
    int? total,
    int limit = 50,
    int offset = 0,
  }) =>
      PlantHistoryResponse(
        items: items,
        total: total ?? items.length,
        limit: limit,
        offset: offset,
      );

  group('getHistoryPage', () {
    test('should_map_items_and_carry_pagination_metadata', () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => responseWith(
          [_event(1), _event(2)],
          total: 9,
          limit: 50,
          offset: 0,
        ),
      );

      final result = await repo.getHistoryPage(42, limit: 50, offset: 0);

      final page = (result as Success).value;
      expect(page.items, hasLength(2));
      expect(page.items.first.kind, CareEventKind.water);
      expect(page.items.first.plantName, 'Фикус');
      // total/limit/offset перенесены из ответа как есть.
      expect(page.total, 9);
      expect(page.limit, 50);
      expect(page.offset, 0);
    });

    test('should_report_hasMore_true_when_window_below_total', () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => responseWith([_event(1), _event(2)], total: 5, offset: 0),
      );

      final page = (await repo.getHistoryPage(42) as Success).value;

      expect(page.hasMore, isTrue);
    });

    test('should_report_hasMore_false_when_window_reaches_total', () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => responseWith([_event(3), _event(4)], total: 4, offset: 2),
      );

      final page = (await repo.getHistoryPage(42, offset: 2) as Success).value;

      expect(page.hasMore, isFalse);
    });

    test('should_forward_limit_and_offset_to_client', () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => responseWith(const []));

      await repo.getHistoryPage(42, limit: 25, offset: 50);

      verify(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: 42,
            limit: 25,
            offset: 50,
            extras: any(named: 'extras'),
          )).called(1);
    });

    // Auth-слот: история ходит со scope chat (X-Chat-Id). Идентичность не
    // хардкодится в data — ставит её интерсептор; ловит молчаливую регрессию,
    // если кто-то сменит scope при подключении реального auth.
    test('should_send_chat_authScope_in_extras', () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => responseWith(const []));

      await repo.getHistoryPage(42);

      final captured = verify(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
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
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getHistoryPage(42);

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => history.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.getHistoryPage(42);

      // Наружу не бросаем — заворачиваем в Result.failure(unknown).
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

    test('should_return_failure_when_DioException_carries_ApiError', () async {
      when(() => stats.getPlantStreak(
            xChatId: any(named: 'xChatId'),
            plantId: any(named: 'plantId'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.accessDenied()));

      final result = await repo.getStreak(42);

      expect((result as Failure).error, const ApiError.accessDenied());
    });
  });

  group('getPlant', () {
    test('should_return_success_with_mapped_plant', () async {
      when(() => plants.getPlant(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => PlantDto(
          id: 42,
          name: 'Фикус',
          archived: false,
          speciesName: 'Ficus',
          createdAt: DateTime.utc(2026, 1, 5),
        ),
      );

      final result = await repo.getPlant(42);

      final plant = (result as Success).value;
      expect(plant.id, 42);
      expect(plant.name, 'Фикус');
      expect(plant.createdAt, DateTime.utc(2026, 1, 5));
    });

    // Auth-слот: деталь растения ходит со scope user (X-User-Id) — иной, чем у
    // истории/стрика. Регрессия scope тут увела бы заголовок не туда.
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

    test('should_return_failure_notFound_when_DioException_carries_it',
        () async {
      when(() => plants.getPlant(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.getPlant(42);

      expect((result as Failure).error, const ApiError.notFound());
    });
  });
}
