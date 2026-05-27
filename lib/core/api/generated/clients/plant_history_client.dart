// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/plant_history_response.dart';

part 'plant_history_client.g.dart';

@RestApi()
abstract class PlantHistoryClient {
  factory PlantHistoryClient(Dio dio, {String? baseUrl}) = _PlantHistoryClient;

  /// История событий ухода за растением.
  ///
  /// Возвращает страницу истории ухода за растением, принадлежащим.
  /// пользователю из заголовка `X-Chat-Id` (Telegram chat_id).
  ///
  /// В выдачу попадают только активные (не отменённые) записи всех типов.
  /// ухода **кроме `SOIL_CHECK`** — это служебный тип, который наружу не.
  /// выставляется.
  ///
  /// Пагинация — `limit/offset`. `limit` строго в диапазоне [1, 100].
  /// (значения вне диапазона отдаются как 400). `offset` < 0 нормализуется.
  /// в 0.
  ///
  /// [xChatId] - Telegram `chat_id` авторизованного пользователя. Резолвится в `users.id`.
  /// на стороне сервера через `UserApiResolver`.
  ///
  ///
  /// [id] - Идентификатор растения.
  ///
  /// [limit] - Размер страницы. Допустимые значения — [1, 100].
  ///
  /// [offset] - Сдвиг от начала истории. Значения < 0 нормализуются в 0.
  @GET('/api/v1/plants/{id}/history')
  Future<PlantHistoryResponse> getPlantHistory({
    @Header('X-Chat-Id') required int xChatId,
    @Path('id') required int id,
    @Query('limit') int? limit = 20,
    @Query('offset') int? offset = 0,
    @Extras() Map<String, dynamic>? extras,
  });
}
