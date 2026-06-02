// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingItemDto _$ShoppingItemDtoFromJson(Map<String, dynamic> json) =>
    ShoppingItemDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      checked: json['checked'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ShoppingItemDtoToJson(ShoppingItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'checked': instance.checked,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
