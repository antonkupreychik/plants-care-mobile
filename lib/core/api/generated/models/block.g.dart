// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{};

BlockWeatherStripBlock _$BlockWeatherStripBlockFromJson(
  Map<String, dynamic> json,
) => BlockWeatherStripBlock(
  type: WeatherStripBlockType.fromJson(json['type'] as String),
  available: json['available'] as bool,
  humidityPercent: (json['humidityPercent'] as num?)?.toInt(),
  recommendation: json['recommendation'] == null
      ? null
      : WeatherStripBlockRecommendation.fromJson(
          json['recommendation'] as String,
        ),
  fetchedAt: json['fetchedAt'] == null
      ? null
      : DateTime.parse(json['fetchedAt'] as String),
  fromCache: json['fromCache'] as bool?,
);

Map<String, dynamic> _$BlockWeatherStripBlockToJson(
  BlockWeatherStripBlock instance,
) => <String, dynamic>{
  'type': instance.type,
  'available': instance.available,
  'humidityPercent': instance.humidityPercent,
  'recommendation': instance.recommendation,
  'fetchedAt': instance.fetchedAt?.toIso8601String(),
  'fromCache': instance.fromCache,
};

BlockTodaySummaryBlock _$BlockTodaySummaryBlockFromJson(
  Map<String, dynamic> json,
) => BlockTodaySummaryBlock(
  type: TodaySummaryBlockType.fromJson(json['type'] as String),
  total: (json['total'] as num).toInt(),
  done: (json['done'] as num).toInt(),
  remaining: (json['remaining'] as num).toInt(),
  overdue: (json['overdue'] as num).toInt(),
);

Map<String, dynamic> _$BlockTodaySummaryBlockToJson(
  BlockTodaySummaryBlock instance,
) => <String, dynamic>{
  'type': instance.type,
  'total': instance.total,
  'done': instance.done,
  'remaining': instance.remaining,
  'overdue': instance.overdue,
};

BlockLocationChipsBlock _$BlockLocationChipsBlockFromJson(
  Map<String, dynamic> json,
) => BlockLocationChipsBlock(
  type: LocationChipsBlockType.fromJson(json['type'] as String),
  locations: (json['locations'] as List<dynamic>)
      .map((e) => LocationChip.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BlockLocationChipsBlockToJson(
  BlockLocationChipsBlock instance,
) => <String, dynamic>{'type': instance.type, 'locations': instance.locations};

BlockPlantGridBlock _$BlockPlantGridBlockFromJson(Map<String, dynamic> json) =>
    BlockPlantGridBlock(
      type: PlantGridBlockType.fromJson(json['type'] as String),
      plants: (json['plants'] as List<dynamic>)
          .map((e) => PlantGridItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockPlantGridBlockToJson(
  BlockPlantGridBlock instance,
) => <String, dynamic>{'type': instance.type, 'plants': instance.plants};
