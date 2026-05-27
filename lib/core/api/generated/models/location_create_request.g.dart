// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationCreateRequest _$LocationCreateRequestFromJson(
  Map<String, dynamic> json,
) => LocationCreateRequest(
  name: json['name'] as String,
  emoji: json['emoji'] as String?,
);

Map<String, dynamic> _$LocationCreateRequestToJson(
  LocationCreateRequest instance,
) => <String, dynamic>{'name': instance.name, 'emoji': instance.emoji};
