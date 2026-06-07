// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScreenLayout _$ScreenLayoutFromJson(Map<String, dynamic> json) => ScreenLayout(
  screenId: json['screenId'] as String,
  version: (json['version'] as num).toInt(),
  blocks: (json['blocks'] as List<dynamic>)
      .map((e) => Block.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ScreenLayoutToJson(ScreenLayout instance) =>
    <String, dynamic>{
      'screenId': instance.screenId,
      'version': instance.version,
      'blocks': instance.blocks,
    };
