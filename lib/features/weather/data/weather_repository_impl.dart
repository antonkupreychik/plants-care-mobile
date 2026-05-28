import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/weather_repository.dart';
import '../domain/weather_snapshot.dart';
import 'mappers/weather_snapshot_mapper.dart';

/// Реализация [WeatherRepository] поверх сгенерированного API-клиента
/// (MADR-007). Зеркалит `getPlantHealth` из `PlantCardRepositoryImpl`:
/// публичный эндпоинт → `AuthScope.none`, интерсептор не вешает
/// `X-User-Id`/`X-Chat-Id`. Идентичность здесь НЕ хардкодится.
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<WeatherSnapshot>> getSnapshot() async {
    try {
      final dto = await _api.weather.getWeatherSnapshot(
        extras: authScopeExtra(AuthScope.none),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
