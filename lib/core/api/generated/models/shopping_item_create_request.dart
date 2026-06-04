// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'shopping_item_create_request.g.dart';

@JsonSerializable()
class ShoppingItemCreateRequest {
  const ShoppingItemCreateRequest({
    required this.title,
  });
  
  factory ShoppingItemCreateRequest.fromJson(Map<String, Object?> json) => _$ShoppingItemCreateRequestFromJson(json);
  
  final String title;

  Map<String, Object?> toJson() => _$ShoppingItemCreateRequestToJson(this);
}
