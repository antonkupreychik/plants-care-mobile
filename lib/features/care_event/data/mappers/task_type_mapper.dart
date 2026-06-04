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

/// Обратное направление (G7): публичный [CareEventKind] записанного ухода →
/// внутренний [CareTaskType] расписания (`GET /plants/{id}/schedules`).
///
/// Нужно, чтобы по типу выполненного события (экран 33 «Успех первого ухода»)
/// найти соответствующее расписание и показать его `nextDueAt`. Единственная
/// точка нормализации в эту сторону; покрывается unit-тестом (test-writer).
///
/// [CareEventKind.unknown] не имеет внутреннего эквивалента (как и `SOIL_CHECK`
/// не имеет публичного) — возвращаем [CareTaskType.unknown]. Расписание с типом
/// `unknown` среди ответа `/schedules` не ожидается, поэтому поиск по нему
/// просто не найдёт совпадения (счётчик не покажем). Возвращаем `unknown`, а не
/// бросаем: решение «нашлось ли расписание» принимает вызывающий.
CareTaskType careTaskTypeFromCareEventKind(CareEventKind kind) =>
    switch (kind) {
      CareEventKind.water => CareTaskType.watering,
      CareEventKind.spray => CareTaskType.misting,
      CareEventKind.fertilize => CareTaskType.fertilizing,
      CareEventKind.unknown => CareTaskType.unknown,
    };
