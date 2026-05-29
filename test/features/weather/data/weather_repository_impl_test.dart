import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/weather_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/weather_snapshot_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/weather_snapshot_response_recommendation.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/weather/data/weather_repository_impl.dart';
import 'package:plantcare_mobile/features/weather/domain/watering_recommendation.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockWeatherClient extends Mock implements WeatherClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      error: error,
    );

void main() {
  late _MockApi api;
  late _MockWeatherClient weather;
  late WeatherRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    weather = _MockWeatherClient();

    when(() => api.weather).thenReturn(weather);

    repo = WeatherRepositoryImpl(api);
  });

  group('getSnapshot', () {
    test('should_return_success_with_mapped_snapshot_when_client_returns_dto',
        () async {
      final fetchedAt = DateTime.utc(2026, 5, 28, 9);
      when(() => weather.getWeatherSnapshot(
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => WeatherSnapshotResponse(
          available: true,
          humidityPercent: 88,
          recommendation: WeatherSnapshotResponseRecommendation.deferOk,
          fetchedAt: fetchedAt,
          fromCache: true,
        ),
      );

      final result = await repo.getSnapshot();

      final snapshot = (result as Success).value;
      expect(snapshot.available, isTrue);
      expect(snapshot.humidityPercent, 88);
      expect(snapshot.recommendation, WateringRecommendation.deferOk);
      expect(snapshot.fetchedAt, fetchedAt);
      expect(snapshot.fromCache, isTrue);
      expect(snapshot.hasData, isTrue);
    });

    test('should_return_success_with_unavailable_snapshot_when_available_false',
        () async {
      when(() => weather.getWeatherSnapshot(
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const WeatherSnapshotResponse(available: false),
      );

      final result = await repo.getSnapshot();

      final snapshot = (result as Success).value;
      expect(snapshot.available, isFalse);
      expect(snapshot.humidityPercent, isNull);
      expect(snapshot.hasData, isFalse);
    });

    // Auth-слот (облегчённый): публичный эндпоинт — scope NONE, без
    // user/chat-заголовков. Ловит молчаливую регрессию при подключении
    // реального auth (если scope сменят, заголовки уедут не туда).
    test('should_send_none_authScope_in_extras', () async {
      when(() => weather.getWeatherSnapshot(
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const WeatherSnapshotResponse(available: false),
      );

      await repo.getSnapshot();

      final captured = verify(() => weather.getWeatherSnapshot(
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.none);
      expect(captured[kAuthScopeExtraKey], isNot(AuthScope.user));
      expect(captured[kAuthScopeExtraKey], isNot(AuthScope.chat));
    });

    test('should_return_failure_network_when_DioException_carries_ApiError',
        () async {
      when(() => weather.getWeatherSnapshot(
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getSnapshot();

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => weather.getWeatherSnapshot(
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.getSnapshot();

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
