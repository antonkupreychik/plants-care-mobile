// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'photo_progress_item_dto.dart';

part 'photo_progress_history_response.g.dart';

/// Страница таймлайна фото-прогресса с метаданными пагинации.
@JsonSerializable()
class PhotoProgressHistoryResponse {
  const PhotoProgressHistoryResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });
  
  factory PhotoProgressHistoryResponse.fromJson(Map<String, Object?> json) => _$PhotoProgressHistoryResponseFromJson(json);
  
  final List<PhotoProgressItemDto> items;

  /// Общее количество снимков в таймлайне растения.
  final int total;
  final int limit;
  final int offset;

  Map<String, Object?> toJson() => _$PhotoProgressHistoryResponseToJson(this);
}
