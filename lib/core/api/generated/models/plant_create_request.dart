// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'schedule_input.dart';

part 'plant_create_request.g.dart';

/// Тело POST /api/v1/plants.
@JsonSerializable()
class PlantCreateRequest {
  const PlantCreateRequest({
    required this.name,
    this.notes,
    this.locationId,
    this.speciesId,
    this.parentPlantId,
    this.acquiredAt,
    this.isNew,
    this.schedules,
  });
  
  factory PlantCreateRequest.fromJson(Map<String, Object?> json) => _$PlantCreateRequestFromJson(json);
  
  /// Имя нового растения. Обязательно, не пустое.
  final String name;

  /// Опциональные заметки пользователя.
  final String? notes;

  /// Идентификатор локации. Если не задан, используется дефолтная локация пользователя.
  final int? locationId;

  /// Идентификатор вида растения (`Species.id`). Опционально. Если задан —.
  /// растение связывается с видом (mobile gap G13); вид должен существовать,.
  /// иначе `404 NOT_FOUND`. Расписания ухода при этом **не** создаются.
  /// автоматически (отдельная задача G14).
  ///
  final int? speciesId;

  /// ID материнского растения. Если задан, новое растение считается.
  /// отводком/потомком этого растения. Родитель должен принадлежать текущему.
  /// пользователю и не быть архивированным, иначе 404/403.
  ///
  final int? parentPlantId;

  /// Дата покупки/получения растения (ISO-8601). Используется для годовщин и строки «С тобой с …».
  final DateTime? acquiredAt;

  /// Если true — включить режим акклиматизации на 21 день после создания.
  final bool? isNew;

  /// Опциональные расписания ухода. Если не передан или пуст — применяются.
  /// дефолты вида (как при обычном создании).
  ///
  final List<ScheduleInput>? schedules;

  Map<String, Object?> toJson() => _$PlantCreateRequestToJson(this);
}
