import '../../../../core/api/generated/models/plant_event_dto.dart';
import '../../../../core/api/generated/models/plant_event_page_response.dart';
import '../../../../core/api/generated/models/plant_event_type.dart' as dto;
import '../../domain/plant_event.dart';
import '../../domain/plant_event_type.dart';
import '../../domain/plant_events_page.dart';

/// Маппинг DTO → domain для журнала событий растения (MADR-002/007). Пишется
/// руками, сгенерированный код не правим.
///
/// Источник enum-значения на проводе — `@JsonValue` сгенерированного
/// [dto.PlantEventType] (его `json` совпадает с backend-кодом). Разбор в
/// domain делегируем `PlantEventType.fromWire` — единый маппинг по `wireName`,
/// не дублируем switch (см. `plant_event_type.dart`).

/// Сгенерированный DTO-enum → domain [PlantEventType] по `wireName`.
/// Неизвестный код (`$unknown`) → `null`: вызывающий решает, как деградировать
/// (обычно пропускает запись).
PlantEventType? plantEventTypeFromDto(dto.PlantEventType type) =>
    PlantEventType.fromWire(type.json);

/// domain [PlantEventType] → сгенерированный DTO-enum для тела запроса.
/// Сопоставление по `wireName` (= `@JsonValue` DTO); domain не содержит
/// неотправляемых значений, поэтому `$unknown` тут не возникает.
dto.PlantEventType plantEventTypeToDto(PlantEventType type) =>
    dto.PlantEventType.fromJson(type.wireName);

extension PlantEventDtoMapper on PlantEventDto {
  /// DTO записи → domain. Возвращает `null`, если тип события нераспознан
  /// (неизвестный backend-код) — такие записи пропускаются в маппере страницы,
  /// а не роняют весь список (forward-compat, MADR-016).
  /// `eventDate` нормализуем в UTC (backend хранит UTC).
  PlantEvent? toDomainOrNull() {
    final type = plantEventTypeFromDto(eventType);
    if (type == null) return null;
    return PlantEvent(
      id: id,
      eventType: type,
      eventDate: eventDate.toUtc(),
      comment: comment,
    );
  }
}

extension PlantEventPageResponseMapper on PlantEventPageResponse {
  /// Ответ-страница backend → domain. Записи с нераспознанным типом
  /// пропускаются (`total`/`limit`/`offset` — echo из ответа, не пересчитываем:
  /// пагинацию ведёт backend).
  PlantEventsPage toDomain() => PlantEventsPage(
        items: items
            .map((d) => d.toDomainOrNull())
            .whereType<PlantEvent>()
            .toList(growable: false),
        total: total,
        limit: limit,
        offset: offset,
      );
}
