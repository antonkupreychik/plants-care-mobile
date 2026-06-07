// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/plant_dto.dart';
import '../models/plant_template_create_request.dart';
import '../models/plant_template_dto.dart';
import '../models/plant_template_instantiate_request.dart';

part 'plant_templates_client.g.dart';

@RestApi()
abstract class PlantTemplatesClient {
  factory PlantTemplatesClient(Dio dio, {String? baseUrl}) = _PlantTemplatesClient;

  /// Список шаблонов пользователя.
  ///
  /// Возвращает все шаблоны растений, созданные текущим пользователем,.
  /// отсортированные по дате создания (новые первыми).
  @GET('/api/v1/plant-templates')
  Future<List<PlantTemplateDto>> listPlantTemplates({
    @Extras() Map<String, dynamic>? extras,
  });

  /// Создать шаблон.
  ///
  /// Создаёт шаблон растения для текущего пользователя.
  ///
  /// Если передан `fromPlantId`, копирует активные расписания ухода.
  /// (WATERING, MISTING, FERTILIZING) из существующего растения пользователя.
  ///
  /// Ограничения:.
  /// - Максимум 30 шаблонов на пользователя.
  /// - Имя 1–40 символов, без дублей (case-insensitive) в пределах пользователя.
  @POST('/api/v1/plant-templates')
  Future<PlantTemplateDto> createPlantTemplate({
    @Body() required PlantTemplateCreateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Удалить шаблон.
  ///
  /// Удаляет шаблон пользователя. Растения, созданные из этого шаблона,.
  /// не затрагиваются (связи FK на plants нет).
  ///
  /// [id] - ID шаблона растения.
  @DELETE('/api/v1/plant-templates/{id}')
  Future<void> deletePlantTemplate({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Создать растение из шаблона.
  ///
  /// Создаёт новое растение, копируя интервалы ухода из указанного шаблона.
  /// Сезонная корректировка применяется согласно глобальной настройке.
  /// пользователя (`seasonal_mode`). Локация — дефолтная для пользователя.
  ///
  /// Расписания (WATERING + другие из шаблона) получают статус active.
  ///
  /// [id] - ID шаблона растения.
  @POST('/api/v1/plant-templates/{id}/instantiate')
  Future<PlantDto> instantiatePlantTemplate({
    @Path('id') required int id,
    @Body() required PlantTemplateInstantiateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });
}
