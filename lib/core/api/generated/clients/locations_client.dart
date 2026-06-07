// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/location_create_request.dart';
import '../models/location_dto.dart';
import '../models/location_pause_request.dart';
import '../models/location_update_request.dart';

part 'locations_client.g.dart';

@RestApi()
abstract class LocationsClient {
  factory LocationsClient(Dio dio, {String? baseUrl}) = _LocationsClient;

  /// Список локаций пользователя.
  ///
  /// Возвращает все незаархивированные локации, принадлежащие текущему пользователю.
  /// (`sub` из bearer-токена). Без пагинации — у пользователя обычно.
  /// меньше десятка локаций.
  @GET('/api/v1/locations')
  Future<List<LocationDto>> listLocations({
    @Extras() Map<String, dynamic>? extras,
  });

  /// Создать локацию.
  ///
  /// Создаёт локацию от имени пользователя. Имя уникально в рамках.
  /// пользователя — при коллизии возвращается 400 с `code=BAD_REQUEST`.
  @POST('/api/v1/locations')
  Future<LocationDto> createLocation({
    @Body() required LocationCreateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Получить локацию по ID.
  ///
  /// Возвращает локацию, если она принадлежит пользователю. Чужие или.
  /// несуществующие локации — 404 (различения не делаем, чтобы не.
  /// раскрывать существование чужих ID).
  ///
  /// [id] - Идентификатор локации.
  @GET('/api/v1/locations/{id}')
  Future<LocationDto> getLocation({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Обновить локацию.
  ///
  /// PATCH-семантика — обновляются только переданные поля.
  ///
  /// [id] - Идентификатор локации.
  @PATCH('/api/v1/locations/{id}')
  Future<LocationDto> updateLocation({
    @Path('id') required int id,
    @Body() required LocationUpdateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Архивировать локацию.
  ///
  /// Архивирует (soft-delete) локацию. Если в локации есть активные растения —.
  /// возвращает 409 с `code=LOCATION_NOT_EMPTY`. Перенос растений перед удалением.
  /// выполняется отдельным вызовом (`PATCH /plants/{id}` с новым `locationId`),.
  /// каскадного переноса нет.
  ///
  /// [id] - Идентификатор локации.
  @DELETE('/api/v1/locations/{id}')
  Future<void> deleteLocation({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Сделать локацию активной.
  ///
  /// Устанавливает данную локацию как активную для пользователя.
  /// (`users.active_location_id`). Предыдущая активная локация теряет флаг `isActive`.
  ///
  /// [id] - Идентификатор локации.
  @POST('/api/v1/locations/{id}/activate')
  Future<LocationDto> activateLocation({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Поставить локацию на паузу.
  ///
  /// Ставит локацию на паузу на указанное количество дней (1–180).
  /// На время паузы растения этой локации исключаются из шедулера уведомлений.
  /// и из «сегодняшних дел». Глобальная пауза пользователя (`users.paused_until`).
  /// имеет приоритет.
  ///
  /// [id] - Идентификатор локации.
  @POST('/api/v1/locations/{id}/pause')
  Future<LocationDto> pauseLocation({
    @Path('id') required int id,
    @Body() required LocationPauseRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Снять паузу с локации.
  ///
  /// Снимает паузу (`paused_until = null`). После этого растения локации.
  /// снова попадают в шедулер и «сегодняшние дела».
  ///
  /// [id] - Идентификатор локации.
  @POST('/api/v1/locations/{id}/resume')
  Future<LocationDto> resumeLocation({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
