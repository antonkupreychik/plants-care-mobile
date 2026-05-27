// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'plant_dto.g.dart';

/// Растение в формате REST API. Поля `locationName` / `speciesName`.
/// денормализованы из связанных сущностей для удобства фронта.
///
@JsonSerializable()
class PlantDto {
  const PlantDto({
    required this.id,
    required this.name,
    required this.archived,
    this.notes,
    this.photoFileId,
    this.locationId,
    this.locationName,
    this.speciesId,
    this.speciesName,
    this.createdAt,
  });
  
  factory PlantDto.fromJson(Map<String, Object?> json) => _$PlantDtoFromJson(json);
  
  /// Уникальный идентификатор растения.
  final int id;

  /// Имя растения, заданное пользователем.
  final String name;

  /// Произвольные заметки пользователя.
  final String? notes;

  /// Telegram `file_id` загруженной фотографии. Используется ботом для повторной отправки без скачивания.
  final String? photoFileId;

  /// Идентификатор локации, в которой стоит растение.
  final int? locationId;

  /// Денормализованное имя локации на момент запроса.
  final String? locationName;

  /// Идентификатор вида из справочника.
  final int? speciesId;

  /// Денормализованное название вида.
  final String? speciesName;

  /// Признак того, что растение архивировано (soft-deleted). В выдаче списков всегда `false`.
  final bool archived;

  /// Момент создания записи в БД (UTC).
  final DateTime? createdAt;

  Map<String, Object?> toJson() => _$PlantDtoToJson(this);
}
