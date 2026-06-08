// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'photo_progress_item_dto.dart';

part 'photo_progress_compare_response.g.dart';

/// Пара снимков «до/после» для сравнения.
@JsonSerializable()
class PhotoProgressCompareResponse {
  const PhotoProgressCompareResponse({
    required this.before,
    required this.after,
  });
  
  factory PhotoProgressCompareResponse.fromJson(Map<String, Object?> json) => _$PhotoProgressCompareResponseFromJson(json);
  
  final PhotoProgressItemDto before;
  final PhotoProgressItemDto after;

  Map<String, Object?> toJson() => _$PhotoProgressCompareResponseToJson(this);
}
