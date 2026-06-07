// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/plant_event_dto.dart';
import '../models/plant_event_page_response.dart';
import '../models/plant_event_request.dart';

part 'plant_events_client.g.dart';

@RestApi()
abstract class PlantEventsClient {
  factory PlantEventsClient(Dio dio, {String? baseUrl}) = _PlantEventsClient;

  /// Журнал событий растения.
  ///
  /// Возвращает страницу журнала событий растения, принадлежащего текущему.
  /// пользователю (`sub` из bearer-токена). Сортировка — по дате события.
  /// (`eventDate`) по убыванию (свежие сверху).
  ///
  /// Доступ только к неархивированному растению текущего пользователя.
  /// Если растение не найдено, архивировано или принадлежит другому.
  /// пользователю — 404.
  ///
  /// Пагинация — `limit/offset`. `limit` нормализуется в диапазон [1, 100].
  /// (по умолчанию 5 — совпадает с размером страницы журнала). `offset` < 0.
  /// нормализуется в 0.
  ///
  /// [id] - Идентификатор растения.
  ///
  /// [limit] - Размер страницы. Нормализуется в [1, 100]. По умолчанию 5.
  ///
  /// [offset] - Сдвиг от начала журнала. Значения < 0 нормализуются в 0.
  @GET('/api/v1/plants/{id}/events')
  Future<PlantEventPageResponse> getPlantEvents({
    @Path('id') required int id,
    @Query('limit') int? limit = 5,
    @Query('offset') int? offset = 0,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Добавить событие в журнал растения.
  ///
  /// Создаёт событие журнала текущей датой (UTC) для растения текущего.
  /// пользователя. Одно нажатие = одно событие; `comment` в v1 не принимается.
  ///
  /// ## Дедуп.
  ///
  /// Повторный запрос того же `eventType` для того же растения в окне 60.
  /// секунд считается двойным нажатием и возвращает 409 без повторной вставки.
  ///
  /// Доступ только к неархивированному растению текущего пользователя —.
  /// иначе 404. Неизвестный `eventType` — 422.
  ///
  /// [id] - Идентификатор растения.
  @POST('/api/v1/plants/{id}/events')
  Future<PlantEventDto> createPlantEvent({
    @Path('id') required int id,
    @Body() required PlantEventRequest body,
    @Extras() Map<String, dynamic>? extras,
  });
}
