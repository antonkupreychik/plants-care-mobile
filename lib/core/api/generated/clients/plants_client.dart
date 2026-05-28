// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/page_response_plant_dto.dart';
import '../models/plant_create_request.dart';
import '../models/plant_dto.dart';
import '../models/plant_health_response.dart';
import '../models/plant_update_request.dart';

part 'plants_client.g.dart';

@RestApi()
abstract class PlantsClient {
  factory PlantsClient(Dio dio, {String? baseUrl}) = _PlantsClient;

  /// Список растений пользователя.
  ///
  /// Возвращает страницу растений, принадлежащих пользователю из заголовка.
  /// `X-User-Id`. Архивированные (soft-deleted) растения в выдачу не.
  /// попадают.
  ///
  /// Можно фильтровать по локации параметром `locationId`. Пагинация —.
  /// классическая `offset/limit`.
  ///
  /// Параметры приводятся к безопасным границам:.
  /// * `limit` обрезается до диапазона **[1, 100]** (всё, что больше 100,.
  ///   становится 100; всё, что меньше 1 — становится 1);.
  /// * `offset` ниже нуля становится 0.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [locationId] - Идентификатор локации. Если задан, возвращаются только растения из неё.
  ///
  /// [offset] - Сдвиг от начала выборки. Значения < 0 трактуются как 0.
  ///
  /// [limit] - Размер страницы. Обрезается до [1, 100] на сервере.
  @GET('/api/v1/plants')
  Future<PageResponsePlantDto> listPlants({
    @Header('X-User-Id') required int xUserId,
    @Query('offset') int? offset = 0,
    @Query('limit') int? limit = 20,
    @Query('locationId') int? locationId,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Создать растение.
  ///
  /// Создаёт растение от имени пользователя из `X-User-Id`. Если.
  /// `locationId` не указан, растение попадает в дефолтную локацию.
  /// пользователя.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  @POST('/api/v1/plants')
  Future<PlantDto> createPlant({
    @Header('X-User-Id') required int xUserId,
    @Body() required PlantCreateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Получить растение по ID.
  ///
  /// Возвращает растение, если оно принадлежит пользователю из `X-User-Id`.
  /// и не архивировано. Чужие или несуществующие растения отдаются как 404,.
  /// чужие активные — как 403 (когда сервис уже знает, что запись есть, но.
  /// принадлежит другому пользователю).
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [id] - Идентификатор растения.
  @GET('/api/v1/plants/{id}')
  Future<PlantDto> getPlant({
    @Header('X-User-Id') required int xUserId,
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Обновить растение (PATCH-семантика).
  ///
  /// Несмотря на HTTP-метод `PUT`, апдейт реализован по принципу PATCH:.
  /// обновляются **только присутствующие в теле** поля. Передача `null`.
  /// в поле трактуется как «не менять».
  ///
  /// Пример: чтобы переместить растение в другую локацию, достаточно.
  /// отправить `{ "locationId": 5 }`.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [id] - Идентификатор растения.
  @PUT('/api/v1/plants/{id}')
  Future<PlantDto> updatePlant({
    @Header('X-User-Id') required int xUserId,
    @Path('id') required int id,
    @Body() required PlantUpdateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Архивировать растение (soft-delete).
  ///
  /// Помечает растение как удалённое (`archived_at = now()` в UTC). Запись.
  /// в БД остаётся, но перестаёт появляться во всех `/api/v1/plants/*`.
  /// выборках. Восстановления через API в этой версии нет.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [id] - Идентификатор растения.
  @DELETE('/api/v1/plants/{id}')
  Future<void> deletePlant({
    @Header('X-User-Id') required int xUserId,
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Health Score растения.
  ///
  /// Возвращает индекс здоровья растения (`score` 0..100) и его зону.
  /// (`GREEN`/`YELLOW`/`RED`), посчитанные backend по истории ухода.
  /// Клиент значения НЕ пересчитывает.
  ///
  /// Если данных для достоверной оценки недостаточно, `insufficientData`.
  /// равно `true` — в этом случае `score`/`zone` носят справочный характер,.
  /// а UI отображает нейтральное состояние.
  ///
  /// Эндпоинт публичный: идентификация по заголовкам не требуется.
  ///
  /// [id] - Идентификатор растения.
  @GET('/api/v1/plants/{id}/health')
  Future<PlantHealthResponse> getPlantHealth({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
