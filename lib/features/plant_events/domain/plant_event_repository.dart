import '../../../core/error/result.dart';
import 'plant_event.dart';
import 'plant_event_type.dart';
import 'plant_events_page.dart';

/// Контракт data-слоя журнала событий растения.
///
/// Возвращает `Future<Result<T>>` и НЕ бросает наружу: доменная ошибка приходит
/// как [ApiError] в `Failure` (MADR-011). Presentation зависит только от этого
/// интерфейса (MADR-002) — реализация скрыта в data.
///
/// **Статус:** REST-контроллера на backend пока нет (backend issue #220 —
/// `GET/POST /plants/{id}/events`). Сейчас работает [FakePlantEventRepositoryImpl]
/// (статичный мок, как в `archive`). Когда backend отдаст эндпоинт и спека
/// регенерирует клиент — добавится dio/codegen-реализация с маппингом DTO→domain
/// и `AuthScope.user`; domain/state/UI не меняются — перевешивается только
/// `plantEventRepositoryProvider`.
abstract interface class PlantEventRepository {
  /// Страница журнала событий растения (`GET /plants/{id}/events`, scope user).
  Future<Result<PlantEventsPage>> getEvents(
    int plantId, {
    int limit,
    int offset,
  });

  /// Записать событие выбранного типа (`POST /plants/{id}/events`, scope user).
  /// Возвращает созданное событие. `Failure(ConflictError)` — дедуп (409).
  Future<Result<PlantEvent>> addEvent(int plantId, PlantEventType eventType);
}
