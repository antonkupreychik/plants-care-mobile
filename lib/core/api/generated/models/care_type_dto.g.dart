// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_type_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareTypeDto _$CareTypeDtoFromJson(Map<String, dynamic> json) => CareTypeDto(
  code: CareTypeDtoCode.fromJson(json['code'] as String),
  displayName: json['displayName'] as String,
);

Map<String, dynamic> _$CareTypeDtoToJson(CareTypeDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'displayName': instance.displayName,
    };
