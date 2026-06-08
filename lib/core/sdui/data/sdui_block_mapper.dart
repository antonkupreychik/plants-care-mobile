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
      final chips = _asMapList(json['locations'])
          .map(_locationChipFromJson)
          .toList(growable: false);
      return SduiBlock.locationChips(
        locations: chips,
        // `selectedLocationId` — id отфильтрованной комнаты (single source of
        // truth выделения); отсутствует/null → чип «Все».
        selectedLocationId: _asInt(json['selectedLocationId']),
        // Счётчик чипа «Все» = сумма растений по комнатам (сервер-derived).
        totalCount: chips.fold<int>(0, (sum, c) => sum + c.count),
      );
    case 'plant_grid':
      return SduiBlock.plantGrid(
        plants: _asMapList(json['plants'])
            .map(_plantFromJson)
            .toList(growable: false),
        // Контекстный пустой стейт комнаты (MADR-016): l10n-КЛЮЧИ, не текст.
        // Отсутствуют → null (нет контекстного пустого стейта).
        emptyTitleKey: _asString(json['emptyTitleKey']),
        emptyBodyKey: _asString(json['emptyBodyKey']),
      );
    case 'guest_banner':
      return SduiBlock.guestBanner(
        titleKey: _asString(json['titleKey']) ?? '',
        bodyKey: _asString(json['bodyKey']) ?? '',
        ctaAction: _actionFromJson(json['ctaAction']),
      );
    case 'empty_state':
      return SduiBlock.emptyState(
        iconKey: _asString(json['iconKey']) ?? '',
        titleKey: _asString(json['titleKey']) ?? '',
        bodyKey: _asString(json['bodyKey']) ?? '',
        ctaAction: _actionFromJson(json['ctaAction']),
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

/// Чип локации (`location_chips.locations[]`) → доменный [SduiLocationChip]
/// (доменная [GardenLocation] + `count` растений в комнате). SDUI-чип не несёт
/// `isDefault` (для рендера чипа он не нужен) — ставим `false`. Отсутствующий
/// `count` → 0 (graceful: старый сервер без поля счётчик не показывает).
SduiLocationChip _locationChipFromJson(Map<String, Object?> json) =>
    SduiLocationChip(
      location: GardenLocation(
        id: _asInt(json['id']) ?? 0,
        name: _asString(json['name']) ?? '',
        emoji: _asString(json['emoji']),
        isDefault: false,
      ),
      count: _asInt(json['count']) ?? 0,
    );

/// Элемент сетки (`plant_grid.plants[]`) → доменный [SduiPlantGridItem]
/// (+ опциональные действия: тап тела → [action] (navigate), кнопка «полить» →
/// [waterAction] (log_care)).
SduiPlantGridItem _plantFromJson(Map<String, Object?> json) => SduiPlantGridItem(
      id: _asInt(json['id']) ?? 0,
      name: _asString(json['name']) ?? '',
      locationName: _asString(json['locationName']),
      action: _actionFromJson(json['action']),
      waterAction: _actionFromJson(json['waterAction']),
    );

/// `action`/`waterAction`/`ctaAction` → доменный [SduiAction]. `kind`
/// нормализуем через [SduiActionKind.fromApi]: нераспознанный →
/// [SduiActionKind.unknown] (`ActionRunner` такое действие не исполняет, но и
/// не падает). Парсим `navigate.target` и декларативные `invalidates` (ключи).
/// Без объекта-действия или с битой формой → `null`.
SduiAction? _actionFromJson(Object? raw) {
  if (raw is! Map) return null;
  final json = Map<String, Object?>.from(raw);
  final payload = json['payloadTemplate'];
  return SduiAction(
    kind: SduiActionKind.fromApi(_asString(json['kind'])),
    method: _asString(json['method']) ?? '',
    path: _asString(json['path']) ?? '',
    target: _asString(json['target']),
    payload: payload is Map ? Map<String, dynamic>.from(payload) : null,
    invalidates: _asStringList(json['invalidates']),
  );
}

/// `invalidates` → список строковых ключей, пропуская элементы иного типа.
/// Отсутствует/иной формы → пустой список.
List<String> _asStringList(Object? raw) {
  if (raw is! List) return const <String>[];
  return [
    for (final e in raw)
      if (e is String) e,
  ];
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
