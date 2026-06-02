// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/care_schedule_dto.dart';
import '../models/care_schedule_update_request.dart';
import '../models/type.dart';

part 'schedules_client.g.dart';

@RestApi()
abstract class SchedulesClient {
  factory SchedulesClient(Dio dio, {String? baseUrl}) = _SchedulesClient;

  /// Расписания ухода растения.
  ///
  /// Возвращает все четыре расписания ухода растения (WATERING, MISTING,.
  /// FERTILIZING, SOIL_CHECK) в фиксированном порядке. Если расписание ещё.
  /// не настроено — отдаётся дефолтный интервал вида с `enabled=false`.
  ///
  /// [id] - Идентификатор растения.
  @GET('/api/v1/plants/{id}/schedules')
  Future<List<CareScheduleDto>> listPlantSchedules({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Изменить расписание ухода.
  ///
  /// Создаёт или обновляет расписание ухода заданного типа. Поле `amountMl`.
  /// осмысленно только для типа `WATERING`; для остальных типов игнорируется.
  ///
  /// [id] - Идентификатор растения.
  ///
  /// [type] - Тип задачи ухода.
  @PUT('/api/v1/plants/{id}/schedules/{type}')
  Future<CareScheduleDto> updatePlantSchedule({
    @Path('id') required int id,
    @Path('type') required Type type,
    @Body() required CareScheduleUpdateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });
}
