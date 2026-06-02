// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'me_response_locale.dart';
import 'me_response_seasonal_mode.dart';

part 'me_response.g.dart';

/// Профиль и настройки текущего пользователя (`GET /api/v1/me`).
@JsonSerializable()
class MeResponse {
  const MeResponse({
    required this.id,
    required this.emailVerified,
    required this.createdAt,
    required this.name,
    required this.plantsTotal,
    required this.tasksToday,
    required this.notificationsUnread,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.timezone,
    required this.locale,
    required this.seasonalEnabled,
    required this.seasonalMode,
    required this.weatherEnabled,
    required this.featureFlags,
    required this.appleLinked,
    required this.googleLinked,
    required this.emailLinked,
    required this.telegramLinked,
    this.email,
    this.avatar,
  });
  
  factory MeResponse.fromJson(Map<String, Object?> json) => _$MeResponseFromJson(json);
  
  /// Идентификатор пользователя.
  final int id;

  /// Email пользователя. `null` для чисто Telegram-юзеров.
  final String? email;

  /// Подтверждён ли email (magic link / verified OAuth-провайдером).
  final bool emailVerified;

  /// Момент регистрации пользователя (UTC).
  final DateTime createdAt;

  /// Отображаемое имя пользователя (из `users.username`). Может быть `null`.
  final String? name;

  /// URL аватара пользователя. Плейсхолдер: на текущей схеме нет колонки.
  /// под аватар, поэтому поле всегда `null` до появления хранилища аватаров.
  ///
  final String? avatar;

  /// Число неархивированных растений пользователя.
  final int plantsTotal;

  /// Число невыполненных (pending) задач ухода на сегодня в таймзоне.
  /// пользователя: дедлайн до конца сегодняшнего дня, отметка «сделано».
  /// ещё не проставлена. Это pending-подмножество `GET /api/v1/today`.
  ///
  final int tasksToday;

  /// Плейсхолдер: фид уведомлений (issue #183) ещё не влит, поэтому поле.
  /// всегда `0`. Будет считаться по-настоящему после появления фида.
  ///
  final int notificationsUnread;

  /// Начало тихих часов, локальное время `HH:mm`.
  final String quietHoursStart;

  /// Конец тихих часов, локальное время `HH:mm`.
  final String quietHoursEnd;

  /// IANA-идентификатор таймзоны пользователя.
  final String timezone;

  /// Язык интерфейса/уведомлений.
  final MeResponseLocale locale;

  /// Учитывать сезоны при расчёте следующего полива.
  final bool seasonalEnabled;

  /// Режим сезонности: `MULTIPLIER` (коэффициент к базовому интервалу) или.
  /// `FIXED` (фиксированные интервалы на сезон).
  ///
  final MeResponseSeasonalMode seasonalMode;

  /// Учитывать погоду в рекомендациях.
  final bool weatherEnabled;

  /// Per-user feature flags, например `{ "sharing": "true" }`.
  final dynamic featureFlags;

  /// Привязан ли Sign in with Apple.
  final bool appleLinked;

  /// Привязан ли Google.
  final bool googleLinked;

  /// Задан ли email для входа.
  final bool emailLinked;

  /// Привязан ли Telegram-аккаунт.
  final bool telegramLinked;

  Map<String, Object?> toJson() => _$MeResponseToJson(this);
}
