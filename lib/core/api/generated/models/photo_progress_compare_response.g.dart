// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_progress_compare_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoProgressCompareResponse _$PhotoProgressCompareResponseFromJson(
  Map<String, dynamic> json,
) => PhotoProgressCompareResponse(
  before: PhotoProgressItemDto.fromJson(json['before'] as Map<String, dynamic>),
  after: PhotoProgressItemDto.fromJson(json['after'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PhotoProgressCompareResponseToJson(
  PhotoProgressCompareResponse instance,
) => <String, dynamic>{'before': instance.before, 'after': instance.after};
