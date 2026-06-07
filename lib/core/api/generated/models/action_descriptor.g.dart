// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_descriptor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionDescriptor _$ActionDescriptorFromJson(Map<String, dynamic> json) =>
    ActionDescriptor(
      kind: ActionDescriptorKind.fromJson(json['kind'] as String),
      method: json['method'] as String,
      path: json['path'] as String,
      payloadTemplate: json['payloadTemplate'],
    );

Map<String, dynamic> _$ActionDescriptorToJson(ActionDescriptor instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'method': instance.method,
      'path': instance.path,
      'payloadTemplate': instance.payloadTemplate,
    };
