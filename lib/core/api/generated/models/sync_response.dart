// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'sync_care_event_dto.dart';
import 'sync_deletion_dto.dart';
import 'sync_location_dto.dart';
import 'sync_plant_dto.dart';

part 'sync_response.g.dart';

/// Ответ `GET /api/v1/sync`. Содержит все изменения с момента `since`.
/// `serverTime` — клиент обязан использовать это значение как `since`.
/// при следующем вызове (защита от clock drift).
///
@JsonSerializable()
class SyncResponse {
  const SyncResponse({
    required this.plants,
    required this.locations,
    required this.careEvents,
    required this.deletions,
    required this.serverTime,
  });
  
  factory SyncResponse.fromJson(Map<String, Object?> json) => _$SyncResponseFromJson(json);
  
  /// Растения, изменённые после `since` (active, not deleted).
  final List<SyncPlantDto> plants;

  /// Локации, изменённые после `since` (active, not deleted).
  final List<SyncLocationDto> locations;

  /// Активные события ухода, изменённые после `since`.
  final List<SyncCareEventDto> careEvents;

  /// Удалённые сущности. Клиент удаляет их из локальной БД по `entityType` + `id`.
  /// Сортировка по `deletedAt` ASC.
  ///
  final List<SyncDeletionDto> deletions;

  /// Серверное время на момент обработки запроса.
  /// Клиент сохраняет это значение и передаёт как `since` при следующем вызове.
  ///
  final DateTime serverTime;

  Map<String, Object?> toJson() => _$SyncResponseToJson(this);
}
