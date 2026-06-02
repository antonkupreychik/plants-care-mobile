// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'shopping_item_dto.dart';

part 'shopping_list_response.g.dart';

/// Обёртка над списком позиций покупок.
@JsonSerializable()
class ShoppingListResponse {
  const ShoppingListResponse({
    required this.items,
  });
  
  factory ShoppingListResponse.fromJson(Map<String, Object?> json) => _$ShoppingListResponseFromJson(json);
  
  final List<ShoppingItemDto> items;

  Map<String, Object?> toJson() => _$ShoppingListResponseToJson(this);
}
