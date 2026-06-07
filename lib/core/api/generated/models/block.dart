// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'location_chip.dart';
import 'location_chips_block.dart';
import 'location_chips_block_type.dart';
import 'plant_grid_block.dart';
import 'plant_grid_block_type.dart';
import 'plant_grid_item.dart';
import 'today_summary_block.dart';
import 'today_summary_block_type.dart';
import 'weather_strip_block.dart';
import 'weather_strip_block_recommendation.dart';
import 'weather_strip_block_type.dart';


part 'block.g.dart';

/// Полиморфный блок SDUI. Конкретный тип определяется дискриминатором.
/// `type`. Клиент выбирает рендерер по `type`; неизвестные значения.
/// пропускает.
///
@JsonSerializable(createFactory: false)
sealed class Block {
  const Block();
  
  factory Block.fromJson(Map<String, dynamic> json) =>
      BlockSealedDeserializer.tryDeserialize(json);
  
  Map<String, dynamic> toJson();
}

extension BlockSealedDeserializer on Block {
  static Block tryDeserialize(
    Map<String, dynamic> json, {
    String key = 'type',
    Map<Type, Object?>? mapping,
  }) {
    final mappingFallback = const <Type, Object?>{
      BlockWeatherStripBlock: 'weather_strip',
      BlockTodaySummaryBlock: 'today_summary',
      BlockLocationChipsBlock: 'location_chips',
      BlockPlantGridBlock: 'plant_grid',
    };
    final value = json[key];
    final effective = mapping ?? mappingFallback;
    return switch (value) {
      _ when value == effective[BlockWeatherStripBlock] => BlockWeatherStripBlock.fromJson(json),
      _ when value == effective[BlockTodaySummaryBlock] => BlockTodaySummaryBlock.fromJson(json),
      _ when value == effective[BlockLocationChipsBlock] => BlockLocationChipsBlock.fromJson(json),
      _ when value == effective[BlockPlantGridBlock] => BlockPlantGridBlock.fromJson(json),
      _ => throw FormatException('Unknown discriminator value "${json[key]}" for Block'),
    };
  }
}

@JsonSerializable()
class BlockWeatherStripBlock extends Block implements WeatherStripBlock {
  @override
  final WeatherStripBlockType type;
  @override
  final bool available;
  @override
  final int? humidityPercent;
  @override
  final WeatherStripBlockRecommendation? recommendation;
  @override
  final DateTime? fetchedAt;
  @override
  final bool? fromCache;

  const BlockWeatherStripBlock({
    required this.type,
    required this.available,
    required this.humidityPercent,
    required this.recommendation,
    required this.fetchedAt,
    required this.fromCache,
  });
  
  factory BlockWeatherStripBlock.fromJson(Map<String, dynamic> json) =>
      _$BlockWeatherStripBlockFromJson(json);
      
  @override
  Map<String, dynamic> toJson() => _$BlockWeatherStripBlockToJson(this);
}
@JsonSerializable()
class BlockTodaySummaryBlock extends Block implements TodaySummaryBlock {
  @override
  final TodaySummaryBlockType type;
  @override
  final int total;
  @override
  final int done;
  @override
  final int remaining;
  @override
  final int overdue;

  const BlockTodaySummaryBlock({
    required this.type,
    required this.total,
    required this.done,
    required this.remaining,
    required this.overdue,
  });
  
  factory BlockTodaySummaryBlock.fromJson(Map<String, dynamic> json) =>
      _$BlockTodaySummaryBlockFromJson(json);
      
  @override
  Map<String, dynamic> toJson() => _$BlockTodaySummaryBlockToJson(this);
}
@JsonSerializable()
class BlockLocationChipsBlock extends Block implements LocationChipsBlock {
  @override
  final LocationChipsBlockType type;
  @override
  final List<LocationChip> locations;

  const BlockLocationChipsBlock({
    required this.type,
    required this.locations,
  });
  
  factory BlockLocationChipsBlock.fromJson(Map<String, dynamic> json) =>
      _$BlockLocationChipsBlockFromJson(json);
      
  @override
  Map<String, dynamic> toJson() => _$BlockLocationChipsBlockToJson(this);
}
@JsonSerializable()
class BlockPlantGridBlock extends Block implements PlantGridBlock {
  @override
  final PlantGridBlockType type;
  @override
  final List<PlantGridItem> plants;

  const BlockPlantGridBlock({
    required this.type,
    required this.plants,
  });
  
  factory BlockPlantGridBlock.fromJson(Map<String, dynamic> json) =>
      _$BlockPlantGridBlockFromJson(json);
      
  @override
  Map<String, dynamic> toJson() => _$BlockPlantGridBlockToJson(this);
}
