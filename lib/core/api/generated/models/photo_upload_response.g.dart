// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoUploadResponse _$PhotoUploadResponseFromJson(Map<String, dynamic> json) =>
    PhotoUploadResponse(
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$PhotoUploadResponseToJson(
  PhotoUploadResponse instance,
) => <String, dynamic>{'id': instance.id, 'url': instance.url};
