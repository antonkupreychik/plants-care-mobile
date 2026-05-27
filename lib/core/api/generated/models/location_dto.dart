// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'location_dto.g.dart';

/// Локация (комната/место), в которой пользователь держит растения.
@JsonSerializable()
class LocationDto {
  const LocationDto({
    required this.id,
    required this.name,
    required this.defaultLocation,
    this.emoji,
    this.createdAt,
  });
  
  factory LocationDto.fromJson(Map<String, Object?> json) => _$LocationDtoFromJson(json);
  
  final int id;
  final String name;
  final String? emoji;

  /// Является ли локация дефолтной для пользователя.
  final bool defaultLocation;
  final DateTime? createdAt;

  Map<String, Object?> toJson() => _$LocationDtoToJson(this);
}
