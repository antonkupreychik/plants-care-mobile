// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'care_type_dto_code.dart';

part 'care_type_dto.g.dart';

/// Локализованная карточка типа ухода.
@JsonSerializable()
class CareTypeDto {
  const CareTypeDto({
    required this.code,
    required this.displayName,
  });
  
  factory CareTypeDto.fromJson(Map<String, Object?> json) => _$CareTypeDtoFromJson(json);
  
  /// Машинное имя `TaskType.name()`.
  final CareTypeDtoCode code;

  /// Локализованное русское имя для UI.
  final String displayName;

  Map<String, Object?> toJson() => _$CareTypeDtoToJson(this);
}
