// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'shopping_item_dto.g.dart';

/// Позиция персонального списка покупок.
@JsonSerializable()
class ShoppingItemDto {
  const ShoppingItemDto({
    required this.id,
    required this.title,
    required this.checked,
    this.createdAt,
  });
  
  factory ShoppingItemDto.fromJson(Map<String, Object?> json) => _$ShoppingItemDtoFromJson(json);
  
  final int id;
  final String title;

  /// Куплено ли уже.
  final bool checked;
  final DateTime? createdAt;

  Map<String, Object?> toJson() => _$ShoppingItemDtoToJson(this);
}
