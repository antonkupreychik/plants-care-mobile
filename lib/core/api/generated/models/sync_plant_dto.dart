// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'sync_plant_dto.g.dart';

/// Снапшот растения для офлайн-синка.
@JsonSerializable()
class SyncPlantDto {
  const SyncPlantDto({
    required this.id,
    required this.name,
    required this.locationId,
    required this.archived,
    required this.updatedAt,
    this.notes,
    this.locationName,
    this.speciesId,
    this.speciesName,
    this.clientId,
  });
  
  factory SyncPlantDto.fromJson(Map<String, Object?> json) => _$SyncPlantDtoFromJson(json);
  
  final int id;
  final String name;
  final String? notes;
  final int locationId;
  final String? locationName;
  final int? speciesId;
  final String? speciesName;

  /// Признак архивации (soft-delete на стороне бизнес-логики).
  final bool archived;

  /// UUID, сгенерированный клиентом при создании. Null для записей из бота.
  final String? clientId;

  /// Момент последнего изменения (UTC).
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$SyncPlantDtoToJson(this);
}
