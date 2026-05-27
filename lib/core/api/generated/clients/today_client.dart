// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/today_response.dart';

part 'today_client.g.dart';

@RestApi()
abstract class TodayClient {
  factory TodayClient(Dio dio, {String? baseUrl}) = _TodayClient;

  /// Задачи на сегодня.
  ///
  /// Возвращает задачи ухода, дедлайн которых наступает до конца.
  /// сегодняшнего дня в **таймзоне пользователя** (`users.timezone`).
  ///
  /// Учитываются только активные расписания; завершённые или приостановленные.
  /// не попадают в выдачу.
  ///
  /// [xChatId] - Telegram `chat_id` авторизованного пользователя. Резолвится в `users.id`.
  /// на стороне сервера через `UserApiResolver`.
  @GET('/api/v1/today')
  Future<TodayResponse> getToday({
    @Header('X-Chat-Id') required int xChatId,
    @Extras() Map<String, dynamic>? extras,
  });
}
