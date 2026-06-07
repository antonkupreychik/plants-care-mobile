// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'location_chip.g.dart';

/// Один чип локации в блоке `location_chips`.
@JsonSerializable()
class LocationChip {
  const LocationChip({
    required this.id,
    required this.name,
    this.emoji,
  });
  
  factory LocationChip.fromJson(Map<String, Object?> json) => _$LocationChipFromJson(json);
  
  /// Идентификатор локации.
  final int id;

  /// Название локации.
  final String name;

  /// Эмодзи локации. Может быть `null`, если не задано.
  final String? emoji;

  Map<String, Object?> toJson() => _$LocationChipToJson(this);
}
