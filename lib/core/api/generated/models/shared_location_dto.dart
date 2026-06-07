// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'location_access_role.dart';

part 'shared_location_dto.g.dart';

/// Локация, к которой у пользователя есть доступ CARETAKER.
@JsonSerializable()
class SharedLocationDto {
  const SharedLocationDto({
    required this.id,
    required this.name,
    required this.ownerUserId,
    required this.role,
    required this.joinedAt,
    this.emoji,
  });
  
  factory SharedLocationDto.fromJson(Map<String, Object?> json) => _$SharedLocationDtoFromJson(json);
  
  /// Идентификатор локации.
  final int id;

  /// Название локации.
  final String name;

  /// Emoji локации.
  final String? emoji;

  /// Идентификатор владельца локации.
  final int ownerUserId;
  final LocationAccessRole role;

  /// Когда появился доступ (UTC).
  final DateTime joinedAt;

  Map<String, Object?> toJson() => _$SharedLocationDtoToJson(this);
}
