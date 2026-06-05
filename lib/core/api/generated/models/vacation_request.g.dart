// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationRequest _$VacationRequestFromJson(Map<String, dynamic> json) =>
    VacationRequest(
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
    );

Map<String, dynamic> _$VacationRequestToJson(VacationRequest instance) =>
    <String, dynamic>{
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
    };
