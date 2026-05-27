// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayResponse _$TodayResponseFromJson(Map<String, dynamic> json) =>
    TodayResponse(
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$TodayResponseToJson(TodayResponse instance) =>
    <String, dynamic>{'tasks': instance.tasks, 'count': instance.count};
