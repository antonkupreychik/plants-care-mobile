// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharingMemberDto _$SharingMemberDtoFromJson(Map<String, dynamic> json) =>
    SharingMemberDto(
      id: (json['id'] as num).toInt(),
      contact: json['contact'] as String,
      status: SharingStatus.fromJson(json['status'] as String),
      canLogCare: json['canLogCare'] as bool,
      plantIds: (json['plantIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$SharingMemberDtoToJson(SharingMemberDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contact': instance.contact,
      'status': instance.status,
      'canLogCare': instance.canLogCare,
      'plantIds': instance.plantIds,
    };
