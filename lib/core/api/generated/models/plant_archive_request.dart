// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'plant_archive_request.g.dart';

/// Тело PATCH /api/v1/plants/{id}/archive (issue #219). Оба поля.
/// опциональны; само тело тоже опционально (можно архивировать без причины).
///
@JsonSerializable()
class PlantArchiveRequest {
  const PlantArchiveRequest({
    this.gifted,
    this.note,
  });
  
  factory PlantArchiveRequest.fromJson(Map<String, Object?> json) => _$PlantArchiveRequestFromJson(json);
  
  /// true — растение подарили, false — погибло. null — не указано.
  final bool? gifted;

  /// Свободная заметка о выбытии.
  final String? note;

  Map<String, Object?> toJson() => _$PlantArchiveRequestToJson(this);
}
