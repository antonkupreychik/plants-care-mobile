// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_family_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantFamilyResponse _$PlantFamilyResponseFromJson(Map<String, dynamic> json) =>
    PlantFamilyResponse(
      children: (json['children'] as List<dynamic>)
          .map((e) => PlantFamilyMemberDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      parent: json['parent'] == null
          ? null
          : PlantFamilyMemberDto.fromJson(
              json['parent'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PlantFamilyResponseToJson(
  PlantFamilyResponse instance,
) => <String, dynamic>{
  'parent': instance.parent,
  'children': instance.children,
};
