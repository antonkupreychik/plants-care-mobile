import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/care/care_task_type.dart';

part 'care_plan_item.freezed.dart';

/// Один пункт «плана ухода» для read-only превью шага 3 мастера (экран 04).
///
/// Чистый Dart, иммутабельный. Собирается из интервалов вида
/// ([SpeciesSummary]) — НЕ из расписаний backend (их `POST /plants` не
/// сохраняет, см. BACKEND-GAPS). Поэтому это именно «рекомендация по виду»,
/// а не персональное расписание растения: на этом шаге ничего не редактируется
/// и не персистится.
///
/// Переиспользует общий [CareTaskType] из `core/care` (FLUTTER.md: общее — через
/// core/). [everyDays] — рекомендуемый интервал в днях (всегда > 0; пункты с
/// null/0 в план не попадают).
@freezed
abstract class CarePlanItem with _$CarePlanItem {
  const factory CarePlanItem({
    required CareTaskType type,
    required int everyDays,
  }) = _CarePlanItem;
}
