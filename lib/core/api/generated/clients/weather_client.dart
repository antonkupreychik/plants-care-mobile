// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/weather_snapshot_dto.dart';

part 'weather_client.g.dart';

@RestApi()
abstract class WeatherClient {
  factory WeatherClient(Dio dio, {String? baseUrl}) = _WeatherClient;

  /// Снепшот погоды (влажность) для пользователя.
  ///
  /// Возвращает текущую относительную влажность и рекомендацию по поливу.
  /// для **текущего пользователя** (координаты и флаг погоды берутся из.
  /// профиля).
  ///
  /// Если погода у пользователя не настроена (выключена или нет координат).
  /// либо внешний источник недоступен — отвечает `200` с.
  /// `available = false` и пустыми полями (клиент просто скрывает строку.
  /// погоды, это не ошибка).
  ///
  /// Значение кешируется на стороне сервера (~60 мин), повторные запросы в.
  /// пределах окна не ходят во внешний API (`fromCache = true`).
  @GET('/api/v1/weather/snapshot')
  Future<WeatherSnapshotDto> getWeatherSnapshot({
    @Extras() Map<String, dynamic>? extras,
  });
}
