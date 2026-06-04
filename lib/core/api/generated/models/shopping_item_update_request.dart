// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'shopping_item_update_request.g.dart';

/// Все поля опциональны.
@JsonSerializable()
class ShoppingItemUpdateRequest {
  const ShoppingItemUpdateRequest({
    this.title,
    this.checked,
  });
  
  factory ShoppingItemUpdateRequest.fromJson(Map<String, Object?> json) => _$ShoppingItemUpdateRequestFromJson(json);
  
  final String? title;
  final bool? checked;

  Map<String, Object?> toJson() => _$ShoppingItemUpdateRequestToJson(this);
}
