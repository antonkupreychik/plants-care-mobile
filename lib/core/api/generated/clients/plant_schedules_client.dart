// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/care_schedule_dto.dart';
import '../models/care_schedule_update_request.dart';

part 'plant_schedules_client.g.dart';

@RestApi()
abstract class PlantSchedulesClient {
  factory PlantSchedulesClient(Dio dio, {String? baseUrl}) = _PlantSchedulesClient;

  /// Расписания ухода растения.
  ///
  /// Возвращает список расписаний ухода для растения, принадлежащего.
  /// пользователю из заголовка `X-User-Id`. По одному расписанию на тип.
  /// ухода (`WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`).
  ///
  /// Значения интервалов и `nextDueAt` посчитаны backend.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [id] - Идентификатор растения.
  @GET('/api/v1/plants/{id}/schedules')
  Future<List<CareScheduleDto>> listPlantSchedules({
    @Header('X-User-Id') required int xUserId,
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Обновить расписание ухода по типу.
  ///
  /// Обновляет расписание ухода заданного типа ([type]) для растения.
  /// пользователя из `X-User-Id`. Возвращает обновлённое расписание с.
  /// пересчитанным backend `nextDueAt`.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [id] - Идентификатор растения.
  ///
  /// [type] - Тип ухода (`WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`).
  @PUT('/api/v1/plants/{id}/schedules/{type}')
  Future<CareScheduleDto> updatePlantSchedule({
    @Header('X-User-Id') required int xUserId,
    @Path('id') required int id,
    @Path('type') required String type,
    @Body() required CareScheduleUpdateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });
}
