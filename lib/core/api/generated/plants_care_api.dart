// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/auth_client.dart';
import 'clients/health_client.dart';
import 'clients/plants_client.dart';
import 'clients/plant_history_client.dart';
import 'clients/plant_events_client.dart';
import 'clients/schedules_client.dart';
import 'clients/photo_progress_client.dart';
import 'clients/plant_templates_client.dart';
import 'clients/locations_client.dart';
import 'clients/care_events_client.dart';
import 'clients/calendar_client.dart';
import 'clients/today_client.dart';
import 'clients/weather_client.dart';
import 'clients/stats_client.dart';
import 'clients/reports_client.dart';
import 'clients/species_client.dart';
import 'clients/care_types_client.dart';
import 'clients/diseases_client.dart';
import 'clients/shopping_client.dart';
import 'clients/notifications_client.dart';
import 'clients/vacation_client.dart';
import 'clients/me_client.dart';
import 'clients/sharing_client.dart';
import 'clients/location_sharing_client.dart';
import 'clients/devices_client.dart';
import 'clients/sync_client.dart';
import 'clients/photos_client.dart';

/// Plants Care API `v0.1.0`.
///
/// Публичный REST API сервиса Plants Care — Telegram-бота для напоминаний об.
/// уходе за домашними растениями.
///
/// ## Аутентификация.
///
/// Пользовательские эндпоинты защищены JWT bearer-токеном (issue #88, ADR-011).
/// Клиент получает пару токенов через `/api/v1/auth/*` (Apple / Google / email.
/// magic link), затем передаёт access-токен в заголовке.
/// `Authorization: Bearer <token>`. Идентификатор пользователя (`users.id`).
/// берётся из claim `sub`.
///
/// Эндпоинты `/api/v1/auth/**` и публичные справочники (`/api/v1/species`,.
/// `/api/v1/care-types`) аутентификацию не требуют.
///
/// ## Таймзоны и время.
///
/// Все временные метки в ответах — UTC, формат `date-time` (ISO-8601).
/// Расписания и расчёт «сегодня» выполняются в таймзоне конкретного.
/// пользователя (поле `users.timezone`), но в API наружу пробрасываются как UTC.
///
/// ## Ошибки.
///
/// Все ошибки имеют единый формат — обёртку `{ "error": { code, message, details? } }`,.
/// см. схему [`ApiErrorResponse`](#/components/schemas/ApiErrorResponse).
///
class PlantsCareApi {
  PlantsCareApi(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '0.1.0';

  AuthClient? _auth;
  HealthClient? _health;
  PlantsClient? _plants;
  PlantHistoryClient? _plantHistory;
  PlantEventsClient? _plantEvents;
  SchedulesClient? _schedules;
  PhotoProgressClient? _photoProgress;
  PlantTemplatesClient? _plantTemplates;
  LocationsClient? _locations;
  CareEventsClient? _careEvents;
  CalendarClient? _calendar;
  TodayClient? _today;
  WeatherClient? _weather;
  StatsClient? _stats;
  ReportsClient? _reports;
  SpeciesClient? _species;
  CareTypesClient? _careTypes;
  DiseasesClient? _diseases;
  ShoppingClient? _shopping;
  NotificationsClient? _notifications;
  VacationClient? _vacation;
  MeClient? _me;
  SharingClient? _sharing;
  LocationSharingClient? _locationSharing;
  DevicesClient? _devices;
  SyncClient? _sync;
  PhotosClient? _photos;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  HealthClient get health => _health ??= HealthClient(_dio, baseUrl: _baseUrl);

  PlantsClient get plants => _plants ??= PlantsClient(_dio, baseUrl: _baseUrl);

  PlantHistoryClient get plantHistory => _plantHistory ??= PlantHistoryClient(_dio, baseUrl: _baseUrl);

  PlantEventsClient get plantEvents => _plantEvents ??= PlantEventsClient(_dio, baseUrl: _baseUrl);

  SchedulesClient get schedules => _schedules ??= SchedulesClient(_dio, baseUrl: _baseUrl);

  PhotoProgressClient get photoProgress => _photoProgress ??= PhotoProgressClient(_dio, baseUrl: _baseUrl);

  PlantTemplatesClient get plantTemplates => _plantTemplates ??= PlantTemplatesClient(_dio, baseUrl: _baseUrl);

  LocationsClient get locations => _locations ??= LocationsClient(_dio, baseUrl: _baseUrl);

  CareEventsClient get careEvents => _careEvents ??= CareEventsClient(_dio, baseUrl: _baseUrl);

  CalendarClient get calendar => _calendar ??= CalendarClient(_dio, baseUrl: _baseUrl);

  TodayClient get today => _today ??= TodayClient(_dio, baseUrl: _baseUrl);

  WeatherClient get weather => _weather ??= WeatherClient(_dio, baseUrl: _baseUrl);

  StatsClient get stats => _stats ??= StatsClient(_dio, baseUrl: _baseUrl);

  ReportsClient get reports => _reports ??= ReportsClient(_dio, baseUrl: _baseUrl);

  SpeciesClient get species => _species ??= SpeciesClient(_dio, baseUrl: _baseUrl);

  CareTypesClient get careTypes => _careTypes ??= CareTypesClient(_dio, baseUrl: _baseUrl);

  DiseasesClient get diseases => _diseases ??= DiseasesClient(_dio, baseUrl: _baseUrl);

  ShoppingClient get shopping => _shopping ??= ShoppingClient(_dio, baseUrl: _baseUrl);

  NotificationsClient get notifications => _notifications ??= NotificationsClient(_dio, baseUrl: _baseUrl);

  VacationClient get vacation => _vacation ??= VacationClient(_dio, baseUrl: _baseUrl);

  MeClient get me => _me ??= MeClient(_dio, baseUrl: _baseUrl);

  SharingClient get sharing => _sharing ??= SharingClient(_dio, baseUrl: _baseUrl);

  LocationSharingClient get locationSharing => _locationSharing ??= LocationSharingClient(_dio, baseUrl: _baseUrl);

  DevicesClient get devices => _devices ??= DevicesClient(_dio, baseUrl: _baseUrl);

  SyncClient get sync => _sync ??= SyncClient(_dio, baseUrl: _baseUrl);

  PhotosClient get photos => _photos ??= PhotosClient(_dio, baseUrl: _baseUrl);
}
