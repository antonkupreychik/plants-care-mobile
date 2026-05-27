// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/calendar_response.dart';

part 'calendar_client.g.dart';

@RestApi()
abstract class CalendarClient {
  factory CalendarClient(Dio dio, {String? baseUrl}) = _CalendarClient;

  /// Календарь задач ухода на диапазон дат.
  ///
  /// Возвращает проекцию активных расписаний пользователя на диапазон дат.
  /// `[from, to]` (включительно), сгруппированную по дате.
  ///
  /// Дни без задач в ответе **не появляются**. Ключи объекта-результата —.
  /// строки-даты в формате `YYYY-MM-DD`, упорядоченные по возрастанию.
  ///
  /// Максимальная длина диапазона — 60 дней; больше → 400.
  ///
  /// [xChatId] - Telegram `chat_id` авторизованного пользователя. Резолвится в `users.id`.
  /// на стороне сервера через `UserApiResolver`.
  ///
  ///
  /// [from] - Начало диапазона (включительно).
  ///
  /// [to] - Конец диапазона (включительно). Разница `to - from` ≤ 60 дней.
  @GET('/api/v1/calendar')
  Future<CalendarResponse> getCalendar({
    @Header('X-Chat-Id') required int xChatId,
    @Query('from') required DateTime from,
    @Query('to') required DateTime to,
    @Extras() Map<String, dynamic>? extras,
  });
}
