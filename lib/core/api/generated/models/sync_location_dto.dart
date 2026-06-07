// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'sync_location_dto.g.dart';

/// Снапшот локации для офлайн-синка.
@JsonSerializable()
class SyncLocationDto {
  const SyncLocationDto({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.updatedAt,
    this.emoji,
    this.clientId,
  });
  
  factory SyncLocationDto.fromJson(Map<String, Object?> json) => _$SyncLocationDtoFromJson(json);
  
  final int id;
  final String name;
  final String? emoji;
  final bool isDefault;

  /// UUID, сгенерированный клиентом при создании. Null для записей из бота.
  final String? clientId;

  /// Момент последнего изменения (UTC).
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$SyncLocationDtoToJson(this);
}
