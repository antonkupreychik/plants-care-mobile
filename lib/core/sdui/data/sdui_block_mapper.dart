import '../../care/care_task.dart';
import '../../care/care_task_type.dart';
import '../../locations/garden_location.dart';
import '../../../features/weather/domain/watering_recommendation.dart';
import '../domain/sdui_action.dart';
import '../domain/sdui_block.dart';

/// Маппинг ОПАКОВОГО SDUI-блока (свободный `Map<String, Object?>`) → domain
/// [SduiBlock] (MADR-015). Контракт `GET /api/v1/ui/{screen}` опаковый: backend
/// не типизирует блоки, клиент разбирает их динамически по полю `type`.
///
/// Неизвестный/отсутствующий `type` → `null` (блок пропускается на уровне
/// репозитория — graceful degradation, forward-compatibility). Поля читаются
/// мягко: недостающие/иного типа значения берутся с дефолтом, разбор не падает.
SduiBlock? sduiBlockFromJson(Map<String, Object?> json) {
  switch (json['type']) {
    case 'weather_strip':
      return SduiBlock.weatherStrip(
        available: _asBool(json['available']),
        // Клампим 0..100 — контракт опаковый, границы не валидируются.
        humidityPercent: _asInt(json['humidityPercent'])?.clamp(0, 100),
        recommendation: _recommendation(json['recommendation']),
      );
    case 'today_summary':
      return SduiBlock.todaySummary(
        total: _asInt(json['total']) ?? 0,
        done: _asInt(json['done']) ?? 0,
        remaining: _asInt(json['remaining']) ?? 0,
        overdue: _asInt(json['overdue']) ?? 0,
      );
    case 'today_tasks':
      return SduiBlock.todayTasks(
        completedCount: _asInt(json['completedCount']) ?? 0,
        totalCount: _asInt(json['totalCount']) ?? 0,
        tasks: _asMapList(json['tasks'])
            .map(_taskFromJson)
            .toList(growable: false),
      );
    case 'location_chips':
      return SduiBlock.locationChips(
        locations: _asMapList(json['locations'])
            .map(_locationFromJson)
            .toList(growable: false),
      );
    case 'plant_grid':
      return SduiBlock.plantGrid(
        plants: _asMapList(json['plants'])
            .map(_plantFromJson)
            .toList(growable: false),
      );
    default:
      // Неизвестный/новый `type` — клиент его не рендерит.
      return null;
  }
}

/// `recommendation` строкой backend (`DEFER_OK`/`DO_NOT_DEFER`/`NEUTRAL`) →
/// доменная [WateringRecommendation]. `null`/неизвестное → мягко в `neutral`
/// (см. [WateringRecommendation.fromApi]) — экран не падает.
WateringRecommendation? _recommendation(Object? raw) =>
    raw is String ? WateringRecommendation.fromApi(raw) : null;

/// Чип локации (`location_chips.locations[]`) → доменная [GardenLocation].
/// SDUI-чип не несёт `isDefault` (для рендера чипа он не нужен) — ставим `false`.
GardenLocation _locationFromJson(Map<String, Object?> json) => GardenLocation(
      id: _asInt(json['id']) ?? 0,
      name: _asString(json['name']) ?? '',
      emoji: _asString(json['emoji']),
      isDefault: false,
    );

/// Элемент сетки (`plant_grid.plants[]`) → доменный [SduiPlantGridItem]
/// (+ опциональное действие).
SduiPlantGridItem _plantFromJson(Map<String, Object?> json) => SduiPlantGridItem(
      id: _asInt(json['id']) ?? 0,
      name: _asString(json['name']) ?? '',
      locationName: _asString(json['locationName']),
      action: _actionFromJson(json['action']),
    );

/// `action` элемента сетки → доменный [SduiAction]. `kind` нормализуем через
/// [SduiActionKind.fromApi]: нераспознанный → [SduiActionKind.unknown]
/// (`ActionRunner` такое действие не исполняет, но и не падает). Без `action`
/// или с битой формой → `null`.
SduiAction? _actionFromJson(Object? raw) {
  if (raw is! Map) return null;
  final json = Map<String, Object?>.from(raw);
  final payload = json['payloadTemplate'];
  return SduiAction(
    kind: SduiActionKind.fromApi(_asString(json['kind'])),
    method: _asString(json['method']) ?? '',
    path: _asString(json['path']) ?? '',
    payload: payload is Map ? Map<String, dynamic>.from(payload) : null,
  );
}

/// Задача (`today_tasks.tasks[]`) → доменная [CareTask].
///
/// `type` в этом блоке уже НОРМАЛИЗОВАН backend в форму care-event
/// (`WATER`/`SPRAY`/`FERTILIZE` + возможный `SOIL_CHECK`) — не путать со
/// строками `/today` (`WATERING/MISTING/FERTILIZING`). Нормализуем её в
/// доменный [CareTaskType] через [_taskTypeFromNormalized]. `dueAt` —
/// ISO-8601 UTC; непарсимое → «сейчас» (UTC), чтобы не падать.
CareTask _taskFromJson(Map<String, Object?> json) => CareTask(
      scheduleId: _asInt(json['scheduleId']) ?? 0,
      plantId: _asInt(json['plantId']) ?? 0,
      plantName: _asString(json['plantName']) ?? '',
      type: _taskTypeFromNormalized(_asString(json['type'])),
      dueAt: _asUtcDateTime(json['dueAt']),
    );

/// Нормализованный backend-тип задачи (`WATER`/`SPRAY`/`FERTILIZE`/`SOIL_CHECK`)
/// → доменный [CareTaskType]. Неизвестное/`null` → [CareTaskType.unknown]
/// (forward-compat: новый тип не роняет рендер, sheet откатится на дефолт).
CareTaskType _taskTypeFromNormalized(String? raw) =>
    switch (raw?.toUpperCase()) {
      'WATER' => CareTaskType.watering,
      'SPRAY' => CareTaskType.misting,
      'FERTILIZE' => CareTaskType.fertilizing,
      'SOIL_CHECK' => CareTaskType.soilCheck,
      _ => CareTaskType.unknown,
    };

/// ISO-8601 строка → UTC [DateTime]. `null`/непарсимое → текущий момент UTC
/// (мягко, без исключения — контракт опаковый).
DateTime _asUtcDateTime(Object? v) {
  if (v is String) {
    final parsed = DateTime.tryParse(v);
    if (parsed != null) return parsed.toUtc();
  }
  return DateTime.now().toUtc();
}

/// `blocks`/`locations`/`plants` → список мап, пропуская элементы иной формы.
List<Map<String, Object?>> _asMapList(Object? raw) {
  if (raw is! List) return const <Map<String, Object?>>[];
  return [
    for (final e in raw)
      if (e is Map) Map<String, Object?>.from(e),
  ];
}

bool _asBool(Object? v) => v is bool ? v : false;

int? _asInt(Object? v) => v is num ? v.toInt() : null;

String? _asString(Object? v) => v is String ? v : null;
