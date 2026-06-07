// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/sync_response.dart';

part 'sync_client.g.dart';

@RestApi()
abstract class SyncClient {
  factory SyncClient(Dio dio, {String? baseUrl}) = _SyncClient;

  /// Инкрементальный офлайн-синк.
  ///
  /// Возвращает все изменения, произошедшие после `since`.
  ///
  /// Если `since` не передан — возвращает все активные данные пользователя.
  /// (full sync при первом запуске или восстановлении).
  ///
  /// ## Как использовать.
  ///
  /// Клиент сохраняет `serverTime` из ответа и использует его как `since`.
  /// при следующем вызове. Это защищает от ошибок clock drift.
  ///
  /// ## Конфликт-резолюция.
  ///
  /// Server timestamp wins. Локальные изменения, не отправленные через.
  /// POST-эндпоинты, могут быть перезаписаны.
  ///
  /// ## Идемпотентность POST.
  ///
  /// Перед синком клиент должен отправить все локальные изменения через.
  /// POST /api/v1/care-events с `clientId`. Повторный POST с тем же `clientId`.
  /// возвращает существующую запись без дублирования.
  ///
  /// [since] - Момент, начиная с которого вернуть изменения (UTC, ISO-8601).
  /// Если не передан — full sync (все данные пользователя).
  /// Клиент использует `serverTime` из предыдущего ответа.
  @GET('/api/v1/sync')
  Future<SyncResponse> getSync({
    @Query('since') DateTime? since,
    @Extras() Map<String, dynamic>? extras,
  });
}
