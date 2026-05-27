// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/location_create_request.dart';
import '../models/location_dto.dart';
import '../models/location_update_request.dart';

part 'locations_client.g.dart';

@RestApi()
abstract class LocationsClient {
  factory LocationsClient(Dio dio, {String? baseUrl}) = _LocationsClient;

  /// Список локаций пользователя.
  ///
  /// Возвращает все локации, принадлежащие пользователю из `X-User-Id`.
  /// Без пагинации — у пользователя обычно меньше десятка локаций.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  @GET('/api/v1/locations')
  Future<List<LocationDto>> listLocations({
    @Header('X-User-Id') required int xUserId,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Создать локацию.
  ///
  /// Создаёт локацию от имени пользователя. Имя уникально в рамках.
  /// пользователя — при коллизии возвращается 400 с `code=BAD_REQUEST`.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  @POST('/api/v1/locations')
  Future<LocationDto> createLocation({
    @Header('X-User-Id') required int xUserId,
    @Body() required LocationCreateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Получить локацию по ID.
  ///
  /// Возвращает локацию, если она принадлежит пользователю. Чужие или.
  /// несуществующие локации — 404 (различения не делаем, чтобы не.
  /// раскрывать существование чужих ID).
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [id] - Идентификатор локации.
  @GET('/api/v1/locations/{id}')
  Future<LocationDto> getLocation({
    @Header('X-User-Id') required int xUserId,
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Обновить локацию.
  ///
  /// PATCH-семантика — обновляются только переданные поля.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [id] - Идентификатор локации.
  @PUT('/api/v1/locations/{id}')
  Future<LocationDto> updateLocation({
    @Header('X-User-Id') required int xUserId,
    @Path('id') required int id,
    @Body() required LocationUpdateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Удалить локацию.
  ///
  /// Удаляет локацию. Если в локации есть растения — обязательно передать.
  /// `targetLocationId`, чтобы переместить их в другую локацию того же.
  /// пользователя.
  ///
  /// Если растений нет — `targetLocationId` игнорируется.
  ///
  /// Особый код ошибки `LOCATION_NOT_EMPTY` возвращается, когда в локации.
  /// есть растения, а `targetLocationId` не задан.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [id] - Идентификатор локации.
  ///
  /// [targetLocationId] - Локация, куда переместить растения. Обязателен, если в удаляемой локации есть растения.
  @DELETE('/api/v1/locations/{id}')
  Future<void> deleteLocation({
    @Header('X-User-Id') required int xUserId,
    @Path('id') required int id,
    @Query('targetLocationId') int? targetLocationId,
    @Extras() Map<String, dynamic>? extras,
  });
}
