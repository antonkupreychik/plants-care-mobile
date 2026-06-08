// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_progress_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoProgressItemDto _$PhotoProgressItemDtoFromJson(
  Map<String, dynamic> json,
) => PhotoProgressItemDto(
  id: (json['id'] as num).toInt(),
  takenAt: DateTime.parse(json['takenAt'] as String),
  photoId: (json['photoId'] as num?)?.toInt(),
  url: json['url'] as String?,
  caption: json['caption'] as String?,
);

Map<String, dynamic> _$PhotoProgressItemDtoToJson(
  PhotoProgressItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'photoId': instance.photoId,
  'url': instance.url,
  'takenAt': instance.takenAt.toIso8601String(),
  'caption': instance.caption,
};
