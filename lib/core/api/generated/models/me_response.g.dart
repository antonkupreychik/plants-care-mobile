// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeResponse _$MeResponseFromJson(Map<String, dynamic> json) => MeResponse(
  id: (json['id'] as num).toInt(),
  emailVerified: json['emailVerified'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  name: json['name'] as String?,
  plantsTotal: (json['plantsTotal'] as num).toInt(),
  tasksToday: (json['tasksToday'] as num).toInt(),
  notificationsUnread: (json['notificationsUnread'] as num).toInt(),
  quietHoursStart: json['quietHoursStart'] as String,
  quietHoursEnd: json['quietHoursEnd'] as String,
  timezone: json['timezone'] as String,
  locale: MeResponseLocale.fromJson(json['locale'] as String),
  seasonalEnabled: json['seasonalEnabled'] as bool,
  seasonalMode: MeResponseSeasonalMode.fromJson(json['seasonalMode'] as String),
  weatherEnabled: json['weatherEnabled'] as bool,
  featureFlags: json['featureFlags'],
  appleLinked: json['appleLinked'] as bool,
  googleLinked: json['googleLinked'] as bool,
  emailLinked: json['emailLinked'] as bool,
  telegramLinked: json['telegramLinked'] as bool,
  email: json['email'] as String?,
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$MeResponseToJson(MeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'avatar': instance.avatar,
      'plantsTotal': instance.plantsTotal,
      'tasksToday': instance.tasksToday,
      'notificationsUnread': instance.notificationsUnread,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
      'timezone': instance.timezone,
      'locale': instance.locale,
      'seasonalEnabled': instance.seasonalEnabled,
      'seasonalMode': instance.seasonalMode,
      'weatherEnabled': instance.weatherEnabled,
      'featureFlags': instance.featureFlags,
      'appleLinked': instance.appleLinked,
      'googleLinked': instance.googleLinked,
      'emailLinked': instance.emailLinked,
      'telegramLinked': instance.telegramLinked,
    };
