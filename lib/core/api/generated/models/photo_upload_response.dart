// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'photo_upload_response.g.dart';

/// Результат загрузки фото.
@JsonSerializable()
class PhotoUploadResponse {
  const PhotoUploadResponse({
    required this.id,
    required this.url,
  });
  
  factory PhotoUploadResponse.fromJson(Map<String, Object?> json) => _$PhotoUploadResponseFromJson(json);
  
  /// Идентификатор созданной записи фото.
  final int id;

  /// Presigned URL для скачивания загруженного фото.
  final String url;

  Map<String, Object?> toJson() => _$PhotoUploadResponseToJson(this);
}
