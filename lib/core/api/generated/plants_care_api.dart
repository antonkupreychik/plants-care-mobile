// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/health_client.dart';
import 'clients/plants_client.dart';
import 'clients/plant_history_client.dart';
import 'clients/locations_client.dart';
import 'clients/care_events_client.dart';
import 'clients/calendar_client.dart';
import 'clients/today_client.dart';
import 'clients/stats_client.dart';
import 'clients/species_client.dart';
import 'clients/care_types_client.dart';

/// Plants Care API `v0.1.0`.
///
/// Публичный REST API сервиса Plants Care — Telegram-бота для напоминаний об.
/// уходе за домашними растениями.
///
/// ## Аутентификация.
///
/// В текущей версии (PoC, issue #85/#86) большинство пользовательских.
/// эндпоинтов идентифицируют вызывающего по числовому заголовку:.
///
/// * **`X-User-Id`** — внутренний идентификатор пользователя в БД. Используется.
///   эндпоинтами `/api/v1/plants`, `/api/v1/locations`.
/// * **`X-Chat-Id`** — Telegram `chat_id`. Используется эндпоинтами.
///   `/api/v1/care-events`, `/api/v1/today`, `/api/v1/calendar`,.
///   `/api/v1/stats/streak` и историей растения.
///
/// Публичные справочники (`/api/v1/species`, `/api/v1/care-types`) аутентификацию.
/// не требуют.
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

  HealthClient? _health;
  PlantsClient? _plants;
  PlantHistoryClient? _plantHistory;
  LocationsClient? _locations;
  CareEventsClient? _careEvents;
  CalendarClient? _calendar;
  TodayClient? _today;
  StatsClient? _stats;
  SpeciesClient? _species;
  CareTypesClient? _careTypes;

  HealthClient get health => _health ??= HealthClient(_dio, baseUrl: _baseUrl);

  PlantsClient get plants => _plants ??= PlantsClient(_dio, baseUrl: _baseUrl);

  PlantHistoryClient get plantHistory => _plantHistory ??= PlantHistoryClient(_dio, baseUrl: _baseUrl);

  LocationsClient get locations => _locations ??= LocationsClient(_dio, baseUrl: _baseUrl);

  CareEventsClient get careEvents => _careEvents ??= CareEventsClient(_dio, baseUrl: _baseUrl);

  CalendarClient get calendar => _calendar ??= CalendarClient(_dio, baseUrl: _baseUrl);

  TodayClient get today => _today ??= TodayClient(_dio, baseUrl: _baseUrl);

  StatsClient get stats => _stats ??= StatsClient(_dio, baseUrl: _baseUrl);

  SpeciesClient get species => _species ??= SpeciesClient(_dio, baseUrl: _baseUrl);

  CareTypesClient get careTypes => _careTypes ??= CareTypesClient(_dio, baseUrl: _baseUrl);
}
