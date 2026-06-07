// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_dto_health_zone.dart';

part 'plant_dto.g.dart';

/// Растение в формате REST API. Поля `locationName` / `speciesName`.
/// денормализованы из связанных сущностей для удобства фронта.
///
@JsonSerializable()
class PlantDto {
  const PlantDto({
    required this.id,
    required this.name,
    required this.archived,
    this.notes,
    this.photoFileId,
    this.locationId,
    this.locationName,
    this.speciesId,
    this.speciesName,
    this.createdAt,
    this.healthInsufficientData,
    this.healthScore,
    this.healthZone,
    this.acquiredAt,
    this.inAcclimation,
    this.acclimationUntil,
    this.archivedAt,
    this.gifted,
    this.note,
    this.totalCareDays,
    this.totalCareEvents,
  });
  
  factory PlantDto.fromJson(Map<String, Object?> json) => _$PlantDtoFromJson(json);
  
  /// Уникальный идентификатор растения.
  final int id;

  /// Имя растения, заданное пользователем.
  final String name;

  /// Произвольные заметки пользователя.
  final String? notes;

  /// Telegram `file_id` загруженной фотографии. Используется ботом для повторной отправки без скачивания.
  final String? photoFileId;

  /// Идентификатор локации, в которой стоит растение.
  final int? locationId;

  /// Денормализованное имя локации на момент запроса.
  final String? locationName;

  /// Идентификатор вида из справочника.
  final int? speciesId;

  /// Денормализованное название вида.
  final String? speciesName;

  /// Признак того, что растение архивировано (soft-deleted). В выдаче списков всегда `false`.
  final bool archived;

  /// Момент создания записи в БД (UTC).
  final DateTime? createdAt;

  /// true — данных мало (< 3 активных записей ухода), score/zone равны null.
  final bool? healthInsufficientData;

  /// Балл здоровья 0–100 (mobile gap G16). null если insufficientData.
  final int? healthScore;

  /// Цветовая зона. null если insufficientData.
  final PlantDtoHealthZone? healthZone;

  /// Дата покупки/получения растения (ISO-8601). null если не указана.
  final DateTime? acquiredAt;

  /// true пока acclimation_until > now(). Вычисляемое поле, в БД не хранится.
  final bool? inAcclimation;

  /// Конец периода акклиматизации (UTC). null если акклиматизация не активна.
  final DateTime? acclimationUntil;

  /// Момент архивации (UTC). Заполняется только в выдаче.
  /// `GET /plants?status=archived` и в ответах archive/restore.
  /// (mobile gap G15, issue #219). null для активных растений.
  ///
  final DateTime? archivedAt;

  /// Причина выбытия (issue #219): true — растение подарили, false —.
  /// погибло. null если не указано или растение активно. Заполняется.
  /// только в архивной выдаче и ответах archive/restore.
  ///
  final bool? gifted;

  /// Заметка о выбытии растения (issue #219), напр. «Залила соседка».
  /// null если не задана. Заполняется только в архивной выдаче и ответах.
  /// archive/restore. Это отдельное от `notes` поле.
  ///
  final String? note;

  /// Сколько дней растение было с пользователем: `archivedAt - acquiredAt`.
  /// (или `createdAt`, если `acquiredAt` не задан). Заполняется только в.
  /// архивной выдаче (issue #219).
  ///
  final int? totalCareDays;

  /// Сколько раз пользователь отмечал уход за этим растением (COUNT из.
  /// `care_history`). Заполняется только в архивной выдаче (issue #219).
  ///
  final int? totalCareEvents;

  Map<String, Object?> toJson() => _$PlantDtoToJson(this);
}
