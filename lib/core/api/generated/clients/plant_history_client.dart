// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/care_event_type.dart';
import '../models/plant_history_response.dart';
import '../models/plant_history_summary_dto.dart';

part 'plant_history_client.g.dart';

@RestApi()
abstract class PlantHistoryClient {
  factory PlantHistoryClient(Dio dio, {String? baseUrl}) = _PlantHistoryClient;

  /// История событий ухода за растением.
  ///
  /// Возвращает страницу истории ухода за растением, принадлежащим.
  /// текущему пользователю (`sub` из bearer-токена).
  ///
  /// В выдачу попадают все активные (не отменённые) записи ухода, включая.
  /// `SOIL_CHECK` (issue #222) — мобильный дневник показывает проверки.
  /// грунта наравне с остальными типами.
  ///
  /// Пагинация — `limit/offset`. `limit` строго в диапазоне [1, 100].
  /// (значения вне диапазона отдаются как 400). `offset` < 0 нормализуется.
  /// в 0.
  ///
  /// Опциональный параметр `type` позволяет фильтровать историю по типу.
  /// ухода. Допустимые значения: `WATER`, `SPRAY`, `FERTILIZE`, `SOIL_CHECK`.
  /// Если не задан — возвращаются все типы.
  ///
  /// [id] - Идентификатор растения.
  ///
  /// [limit] - Размер страницы. Допустимые значения — [1, 100].
  ///
  /// [offset] - Сдвиг от начала истории. Значения < 0 нормализуются в 0.
  ///
  /// [type] - Фильтр по типу ухода. Допустимые значения: `WATER`, `SPRAY`, `FERTILIZE`, `SOIL_CHECK`.
  /// Если не задан — возвращаются все типы.
  @GET('/api/v1/plants/{id}/history')
  Future<PlantHistoryResponse> getPlantHistory({
    @Path('id') required int id,
    @Query('type') CareEventType? type,
    @Query('limit') int? limit = 20,
    @Query('offset') int? offset = 0,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Сводная статистика по всей истории растения.
  ///
  /// Возвращает агрегированную статистику по **всей** истории ухода за.
  /// растением (не по странице). Учитываются только активные (не отменённые).
  /// записи. Тип `SOIL_CHECK` из выдачи исключён.
  ///
  /// Доступ только к неархивированному растению текущего пользователя.
  /// (`sub` из bearer-токена). Если растение не найдено или принадлежит.
  /// другому пользователю — 404.
  ///
  /// [id] - Идентификатор растения.
  @GET('/api/v1/plants/{id}/history/summary')
  Future<PlantHistorySummaryDto> getPlantHistorySummary({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
