import '../../../../core/care/care_task_type.dart';
import '../../../plant_card/domain/care_event_kind.dart';

/// Маппер-ловушка (FLUTTER.md «Data», BACKEND-GAPS G7): когда sheet ухода
/// открывается из задачи `/today`, у задачи **внутренний** тип
/// [CareTaskType] (`WATERING/MISTING/FERTILIZING/SOIL_CHECK`), а
/// `POST /care-events` принимает **публичный** [CareEventKind]
/// (`WATER/SPRAY/FERTILIZE`). Эта чистая функция — единственная точка
/// нормализации; покрывается unit-тестом (test-writer).
///
/// Цепочка строкового `taskType` → [CareTaskType] живёт в home
/// (`CareTaskType.fromApi`) — её не дублируем; здесь только domain-enum →
/// domain-enum.
///
/// `SOIL_CHECK` через REST недоступен (api-contract §7) и `unknown` не имеет
/// публичного эквивалента — оба дают [CareEventKind.unknown], который
/// невалиден для отправки (отсекается в `CareEventDraftMapper`). Возвращаем
/// `unknown`, а не бросаем: решение «можно ли отправить» принимает вызывающий.
CareEventKind careEventKindFromTaskType(CareTaskType taskType) =>
    switch (taskType) {
      CareTaskType.watering => CareEventKind.water,
      CareTaskType.misting => CareEventKind.spray,
      CareTaskType.fertilizing => CareEventKind.fertilize,
      CareTaskType.soilCheck => CareEventKind.unknown,
      CareTaskType.unknown => CareEventKind.unknown,
    };
