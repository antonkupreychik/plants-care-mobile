// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_deletion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncDeletionDto _$SyncDeletionDtoFromJson(Map<String, dynamic> json) =>
    SyncDeletionDto(
      entityType: SyncDeletionDtoEntityType.fromJson(
        json['entityType'] as String,
      ),
      id: (json['id'] as num).toInt(),
      deletedAt: DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$SyncDeletionDtoToJson(SyncDeletionDto instance) =>
    <String, dynamic>{
      'entityType': instance.entityType,
      'id': instance.id,
      'deletedAt': instance.deletedAt.toIso8601String(),
    };
