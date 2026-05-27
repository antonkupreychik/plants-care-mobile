// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/streak_response.dart';

part 'stats_client.g.dart';

@RestApi()
abstract class StatsClient {
  factory StatsClient(Dio dio, {String? baseUrl}) = _StatsClient;

  /// Текущий стрик растения.
  ///
  /// Возвращает текущий «стрик» растения — количество последовательных.
  /// выполнений ухода без пропусков (`on_time = true` подряд).
  ///
  /// Проверяется владение растением: если растение принадлежит другому.
  /// пользователю или не существует — 404.
  ///
  /// [xChatId] - Telegram `chat_id` авторизованного пользователя. Резолвится в `users.id`.
  /// на стороне сервера через `UserApiResolver`.
  ///
  ///
  /// [plantId] - Идентификатор растения, для которого считаем стрик.
  @GET('/api/v1/stats/streak')
  Future<StreakResponse> getPlantStreak({
    @Header('X-Chat-Id') required int xChatId,
    @Query('plantId') required int plantId,
    @Extras() Map<String, dynamic>? extras,
  });
}
