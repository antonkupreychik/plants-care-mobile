import 'package:freezed_annotation/freezed_annotation.dart';

import 'plant_event_type.dart';

part 'plant_event.freezed.dart';

/// Одно событие журнала растения (backend `PlantEvent`, issue #76).
///
/// Чистый Dart, иммутабельно. [eventDate] хранится в UTC (как все времена с
/// backend) — UI приводит к локальной TZ перед показом (`.toLocal()`),
/// клиент интервалы не пересчитывает.
@freezed
abstract class PlantEvent with _$PlantEvent {
  const factory PlantEvent({
    /// Идентификатор события (backend `id`).
    required int id,

    /// Тип события (пересадка / замена грунта / обрезка / обработка).
    required PlantEventType eventType,

    /// Момент события в UTC. Показывать в локальной TZ.
    required DateTime eventDate,

    /// Необязательный комментарий пользователя.
    String? comment,
  }) = _PlantEvent;
}
