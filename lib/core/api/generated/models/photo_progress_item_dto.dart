// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'photo_progress_item_dto.g.dart';

/// Снимок таймлайна фото-прогресса с presigned URL на скачивание.
@JsonSerializable()
class PhotoProgressItemDto {
  const PhotoProgressItemDto({
    required this.id,
    required this.takenAt,
    this.photoId,
    this.url,
    this.caption,
  });
  
  factory PhotoProgressItemDto.fromJson(Map<String, Object?> json) => _$PhotoProgressItemDtoFromJson(json);
  
  /// Идентификатор записи таймлайна.
  final int id;

  /// Идентификатор фото в S3-хранилище (issue #90). `null`, если снимок.
  /// загружен через бота (Telegram-источник) — тогда `url` отсутствует.
  ///
  final int? photoId;

  /// Presigned URL для скачивания снимка. Присутствует только для.
  /// S3-источника; для бот-фото (Telegram file_id) `null`.
  ///
  final String? url;

  /// Момент, когда снимок попал в систему (UTC).
  final DateTime takenAt;

  /// Опциональная подпись к снимку.
  final String? caption;

  Map<String, Object?> toJson() => _$PhotoProgressItemDtoToJson(this);
}
