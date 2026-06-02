// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListResponse _$ShoppingListResponseFromJson(
  Map<String, dynamic> json,
) => ShoppingListResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => ShoppingItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ShoppingListResponseToJson(
  ShoppingListResponse instance,
) => <String, dynamic>{'items': instance.items};
