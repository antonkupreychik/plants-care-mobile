// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'block.dart';
import 'location_chip.dart';
import 'location_chips_block_type.dart';

part 'location_chips_block.g.dart';

/// Блок горизонтальных чипов локаций (комнат) пользователя.
@JsonSerializable()
class LocationChipsBlock {
  const LocationChipsBlock({
    required this.type,
    required this.locations,
  });
  
  factory LocationChipsBlock.fromJson(Map<String, Object?> json) => _$LocationChipsBlockFromJson(json);
  
  /// Дискриминатор блока.
  final LocationChipsBlockType type;

  /// Локации пользователя для отрисовки чипами.
  final List<LocationChip> locations;

  Map<String, Object?> toJson() => _$LocationChipsBlockToJson(this);
}
