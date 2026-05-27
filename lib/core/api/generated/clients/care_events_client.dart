// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/care_event_response.dart';
import '../models/create_care_event_request.dart';

part 'care_events_client.g.dart';

@RestApi()
abstract class CareEventsClient {
  factory CareEventsClient(Dio dio, {String? baseUrl}) = _CareEventsClient;

  /// Зарегистрировать событие ухода.
  ///
  /// Записывает выполнение ухода (полив/опрыскивание/удобрение) для растения.
  /// пользователя. После записи пересчитывается ближайший дедлайн в.
  /// связанном расписании.
  ///
  /// ## Идемпотентность.
  ///
  /// Если в теле передан `clientId`, и ранее уже была зарегистрирована.
  /// запись с таким `clientId` от того же пользователя/растения, возвращается.
  /// существующая запись без повторной вставки. Это позволяет мобильным.
  /// клиентам безопасно ретраить запрос при потере соединения.
  ///
  /// [xChatId] - Telegram `chat_id` авторизованного пользователя. Резолвится в `users.id`.
  /// на стороне сервера через `UserApiResolver`.
  @POST('/api/v1/care-events')
  Future<CareEventResponse> createCareEvent({
    @Header('X-Chat-Id') required int xChatId,
    @Body() required CreateCareEventRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Отменить событие ухода (компенсация).
  ///
  /// Запись физически не удаляется — создаётся компенсирующая запись и в.
  /// исходной проставляется FK `cancelled_by`. Это сохраняет полную историю.
  /// и позволяет восстанавливать состояние.
  ///
  /// Повторная отмена уже отменённой записи возвращает 409.
  ///
  /// [xChatId] - Telegram `chat_id` авторизованного пользователя. Резолвится в `users.id`.
  /// на стороне сервера через `UserApiResolver`.
  ///
  ///
  /// [id] - Идентификатор записи `care_history`.
  @DELETE('/api/v1/care-events/{id}')
  Future<void> cancelCareEvent({
    @Header('X-Chat-Id') required int xChatId,
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
