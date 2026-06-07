// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'block.dart';
import 'plant_grid_block_type.dart';
import 'plant_grid_item.dart';

part 'plant_grid_block.g.dart';

/// Блок сетки растений с привязанным действием ухода.
@JsonSerializable()
class PlantGridBlock {
  const PlantGridBlock({
    required this.type,
    required this.plants,
  });
  
  factory PlantGridBlock.fromJson(Map<String, Object?> json) => _$PlantGridBlockFromJson(json);
  
  /// Дискриминатор блока.
  final PlantGridBlockType type;

  /// Растения для отрисовки в сетке.
  final List<PlantGridItem> plants;

  Map<String, Object?> toJson() => _$PlantGridBlockToJson(this);
}
