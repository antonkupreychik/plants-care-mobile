// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'disease_dto.g.dart';

/// Карточка болезни/вредителя комнатных растений.
@JsonSerializable()
class DiseaseDto {
  const DiseaseDto({
    required this.id,
    required this.name,
    required this.symptoms,
    required this.treatment,
    required this.prevention,
    this.latinName,
  });
  
  factory DiseaseDto.fromJson(Map<String, Object?> json) => _$DiseaseDtoFromJson(json);
  
  final int id;
  final String name;
  final String? latinName;
  final String symptoms;
  final String treatment;
  final String prevention;

  Map<String, Object?> toJson() => _$DiseaseDtoToJson(this);
}
