import '../../../core/clock/clock.dart';
import '../../../core/error/result.dart';
import '../domain/plant_event.dart';
import '../domain/plant_event_repository.dart';
import '../domain/plant_event_type.dart';
import '../domain/plant_events_page.dart';

/// TODO(BACKEND #220): заглушка до появления REST-контроллера журнала событий
/// (`GET/POST /plants/{id}/events`). Заменить на dio/codegen-реализацию
/// (`PlantEventApi`) с маппингом DTO→domain и `AuthScope.user`; domain/state/UI
/// при этом НЕ меняются — перевешивается только `plantEventRepositoryProvider`.
///
/// Держит события в памяти на процесс (по `plantId`), чтобы [addEvent] был
/// наблюдаем в последующих [getEvents] (оптимистичное добавление в UI + перечит).
/// Стартовый набор — 3 события из дизайна. Искусственная задержка — чтобы
/// loading-состояния UI были реально наблюдаемы. Никаких сетевых вызовов.
class FakePlantEventRepositoryImpl implements PlantEventRepository {
  FakePlantEventRepositoryImpl(this._clock);

  final Clock _clock;

  static const Duration _readLatency = Duration(milliseconds: 300);
  static const Duration _writeLatency = Duration(milliseconds: 250);

  /// События по растению (новые сверху). Лениво засеивается дизайн-набором.
  final Map<int, List<PlantEvent>> _byPlant = {};

  /// Источник возрастающих id для созданных в рантайме событий.
  int _nextId = 1000;

  List<PlantEvent> _eventsFor(int plantId) =>
      _byPlant.putIfAbsent(plantId, () => _seed(_clock.nowUtc()));

  @override
  Future<Result<PlantEventsPage>> getEvents(
    int plantId, {
    int limit = _defaultLimit,
    int offset = 0,
  }) async {
    await Future<void>.delayed(_readLatency);
    final all = _eventsFor(plantId);
    final from = offset.clamp(0, all.length);
    final to = (offset + limit).clamp(0, all.length);
    return Result.success(
      PlantEventsPage(
        items: all.sublist(from, to),
        total: all.length,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  Future<Result<PlantEvent>> addEvent(
    int plantId,
    PlantEventType eventType,
  ) async {
    await Future<void>.delayed(_writeLatency);
    final event = PlantEvent(
      id: _nextId++,
      eventType: eventType,
      eventDate: _clock.nowUtc(),
    );
    _eventsFor(plantId).insert(0, event);
    return Result.success(event);
  }

  static const int _defaultLimit = 20;

  /// Дизайн-набор из 3 событий, отсчитанный от «сейчас» (новые сверху).
  static List<PlantEvent> _seed(DateTime nowUtc) => [
        PlantEvent(
          id: 3,
          eventType: PlantEventType.pruning,
          eventDate: nowUtc.subtract(const Duration(days: 9)),
          comment: 'Убрал сухие листья',
        ),
        PlantEvent(
          id: 2,
          eventType: PlantEventType.soilChange,
          eventDate: nowUtc.subtract(const Duration(days: 34)),
        ),
        PlantEvent(
          id: 1,
          eventType: PlantEventType.transplant,
          eventDate: nowUtc.subtract(const Duration(days: 96)),
          comment: 'Горшок на 2 см больше',
        ),
      ];
}
