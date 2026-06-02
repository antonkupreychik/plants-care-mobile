// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/page_response_plant_dto.dart';
import '../models/plant_create_request.dart';
import '../models/plant_diagnosis_dto.dart';
import '../models/plant_dto.dart';
import '../models/plant_family_response.dart';
import '../models/plant_health_dto.dart';
import '../models/plant_update_request.dart';

part 'plants_client.g.dart';

@RestApi()
abstract class PlantsClient {
  factory PlantsClient(Dio dio, {String? baseUrl}) = _PlantsClient;

  /// Список растений пользователя.
  ///
  /// Возвращает страницу растений, принадлежащих текущему пользователю.
  /// (`sub` из bearer-токена). Архивированные (soft-deleted) растения в.
  /// выдачу не попадают.
  ///
  /// Можно фильтровать по локации параметром `locationId`. Пагинация —.
  /// классическая `offset/limit`.
  ///
  /// Параметры приводятся к безопасным границам:.
  /// * `limit` обрезается до диапазона **[1, 100]** (всё, что больше 100,.
  ///   становится 100; всё, что меньше 1 — становится 1);.
  /// * `offset` ниже нуля становится 0.
  ///
  /// [locationId] - Идентификатор локации. Если задан, возвращаются только растения из неё.
  ///
  /// [offset] - Сдвиг от начала выборки. Значения < 0 трактуются как 0.
  ///
  /// [limit] - Размер страницы. Обрезается до [1, 100] на сервере.
  @GET('/api/v1/plants')
  Future<PageResponsePlantDto> listPlants({
    @Query('offset') int? offset = 0,
    @Query('limit') int? limit = 20,
    @Query('locationId') int? locationId,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Создать растение.
  ///
  /// Создаёт растение от имени текущего пользователя (`sub` из.
  /// bearer-токена). Если `locationId` не указан, растение попадает в.
  /// дефолтную локацию пользователя. Если `parentPlantId` указан, растение.
  /// создаётся как отводок/потомок материнского растения.
  @POST('/api/v1/plants')
  Future<PlantDto> createPlant({
    @Body() required PlantCreateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Получить растение по ID.
  ///
  /// Возвращает растение, если оно принадлежит текущему пользователю.
  /// (`sub` из bearer-токена) и не архивировано. Чужие или несуществующие.
  /// растения отдаются как 404, чужие активные — как 403 (когда сервис уже.
  /// знает, что запись есть, но принадлежит другому пользователю).
  ///
  /// [id] - Идентификатор растения.
  @GET('/api/v1/plants/{id}')
  Future<PlantDto> getPlant({
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
  /// [id] - Идентификатор растения.
  @PUT('/api/v1/plants/{id}')
  Future<PlantDto> updatePlant({
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
  /// [id] - Идентификатор растения.
  @DELETE('/api/v1/plants/{id}')
  Future<void> deletePlant({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Health-score растения.
  ///
  /// Возвращает числовой балл здоровья растения 0–100 и цветовую зону.
  /// (mobile gap G1, issue #138). Балл считается поверх истории ухода за.
  /// окно 30 дней в таймзоне пользователя плюс бонусы за фото/заметки.
  ///
  /// Если активных записей ухода меньше порога (`< 3`), балл не.
  /// вычисляется: `insufficientData = true`, а `score`/`zone` приходят.
  /// `null` (клиент рисует кольцо нейтральным / «Пока мало данных»).
  ///
  /// Доступ только к своему неархивированному растению (как `GET /plants/{id}`).
  ///
  /// [id] - Идентификатор растения.
  @GET('/api/v1/plants/{id}/health')
  Future<PlantHealthDto> getPlantHealth({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Родословная растения.
  ///
  /// Возвращает материнское растение и прямых потомков/отводки.
  /// для текущего растения. Доступ только к растениям текущего пользователя.
  ///
  /// [id] - Идентификатор растения.
  @GET('/api/v1/plants/{id}/family')
  Future<PlantFamilyResponse> getPlantFamily({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Пассивная диагностика растения.
  ///
  /// Возвращает список выявленных проблем (`issues`) и рекомендаций.
  /// (`recommendations`) для растения (mobile screen 15 «Диагноз»,.
  /// issue #193). Диагноз пассивный — выводится только из уже имеющихся.
  /// данных (просроченные расписания ухода, health-зона), без ИИ и без.
  /// интерактивного опросника. Новой схемы БД не требует.
  ///
  /// Если активных записей ухода меньше порога (`< 3`), диагноз не.
  /// строится: `issues` пустой, в `recommendations` — единственная.
  /// подсказка продолжать отмечать уход.
  ///
  /// У здорового растения (данных достаточно, нет просрочек, зона не `RED`).
  /// и `issues`, и `recommendations` пустые.
  ///
  /// Доступ только к своему неархивированному растению (как `GET /plants/{id}`).
  ///
  /// [id] - Идентификатор растения.
  @GET('/api/v1/plants/{id}/diagnosis')
  Future<PlantDiagnosisDto> getPlantDiagnosis({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
