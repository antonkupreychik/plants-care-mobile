// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationResponse _$VacationResponseFromJson(Map<String, dynamic> json) =>
    VacationResponse(
      active: json['active'] as bool,
      pausedUntil: json['pausedUntil'] == null
          ? null
          : DateTime.parse(json['pausedUntil'] as String),
    );

Map<String, dynamic> _$VacationResponseToJson(VacationResponse instance) =>
    <String, dynamic>{
      'active': instance.active,
      'pausedUntil': instance.pausedUntil?.toIso8601String(),
    };
