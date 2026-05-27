// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreakResponse _$StreakResponseFromJson(Map<String, dynamic> json) =>
    StreakResponse(
      plantId: (json['plantId'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
    );

Map<String, dynamic> _$StreakResponseToJson(StreakResponse instance) =>
    <String, dynamic>{'plantId': instance.plantId, 'streak': instance.streak};
