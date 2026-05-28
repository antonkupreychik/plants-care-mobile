// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/weather_snapshot_response.dart';

part 'weather_client.g.dart';

@RestApi()
abstract class WeatherClient {
  factory WeatherClient(Dio dio, {String? baseUrl}) = _WeatherClient;

  /// Снапшот погоды для рекомендаций по поливу.
  ///
  /// Возвращает текущий снапшот погоды (влажность воздуха) и рекомендацию.
  /// backend, стоит ли отложить полив. Значения посчитаны backend по.
  /// внешнему источнику погоды и кэшируются (~60 мин, см. `fromCache`).
  ///
  /// Если погода не настроена или источник недоступен, `available` равно.
  /// `false`, а остальные поля приходят `null` — UI не показывает строку.
  /// погоды.
  ///
  /// Эндпоинт публичный: идентификация по заголовкам не требуется.
  @GET('/api/v1/weather/snapshot')
  Future<WeatherSnapshotResponse> getWeatherSnapshot({
    @Extras() Map<String, dynamic>? extras,
  });
}
