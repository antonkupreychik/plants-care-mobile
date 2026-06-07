// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/device_dto.dart';
import '../models/device_register_request.dart';

part 'devices_client.g.dart';

@RestApi()
abstract class DevicesClient {
  factory DevicesClient(Dio dio, {String? baseUrl}) = _DevicesClient;

  /// Зарегистрировать устройство.
  ///
  /// Регистрирует push-токен устройства для текущего пользователя (из bearer-токена).
  /// Идемпотентно: повторный вызов с тем же `pushToken` обновляет `lastSeenAt`.
  /// и возвращает 201. FCM-отправка — отдельная задача.
  @POST('/api/v1/devices')
  Future<DeviceDto> registerDevice({
    @Body() required DeviceRegisterRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Отвязать устройство.
  ///
  /// Удаляет push-токен устройства текущего пользователя. Чужое или.
  /// несуществующее устройство → 404.
  ///
  /// [id] - Идентификатор устройства.
  @DELETE('/api/v1/devices/{id}')
  Future<void> unregisterDevice({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
