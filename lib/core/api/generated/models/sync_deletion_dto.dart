// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'sync_deletion_dto_entity_type.dart';

part 'sync_deletion_dto.g.dart';

/// Запись об удалённой сущности. Клиент удаляет её из локальной БД.
/// по сочетанию `entityType` + `id`.
///
@JsonSerializable()
class SyncDeletionDto {
  const SyncDeletionDto({
    required this.entityType,
    required this.id,
    required this.deletedAt,
  });
  
  factory SyncDeletionDto.fromJson(Map<String, Object?> json) => _$SyncDeletionDtoFromJson(json);
  
  /// Тип сущности.
  final SyncDeletionDtoEntityType entityType;

  /// Идентификатор удалённой сущности.
  final int id;

  /// Момент удаления (UTC).
  final DateTime deletedAt;

  Map<String, Object?> toJson() => _$SyncDeletionDtoToJson(this);
}
