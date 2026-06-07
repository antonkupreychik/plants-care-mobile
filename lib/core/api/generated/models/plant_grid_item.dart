// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'action_descriptor.dart';

part 'plant_grid_item.g.dart';

/// Один элемент сетки растений в блоке `plant_grid`.
@JsonSerializable()
class PlantGridItem {
  const PlantGridItem({
    required this.id,
    required this.name,
    this.locationName,
    this.action,
  });
  
  factory PlantGridItem.fromJson(Map<String, Object?> json) => _$PlantGridItemFromJson(json);
  
  /// Идентификатор растения.
  final int id;

  /// Название растения.
  final String name;

  /// Название локации растения. Может быть `null`.
  final String? locationName;
  final ActionDescriptor? action;

  Map<String, Object?> toJson() => _$PlantGridItemToJson(this);
}
