import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/care/care_task_type.dart';
import 'care_difficulty.dart';
import 'care_plan_item.dart';

part 'species_summary.freezed.dart';

/// Краткая карточка вида из справочника (`SpeciesSummaryDto`, `GET /species`).
///
/// Чистый Dart, иммутабельный. Используется на шаге 1 мастера (поиск/выбор вида)
/// и несёт рекомендуемые интервалы ухода — из них собирается read-only «план
/// ухода» ([carePlan]) для превью шага 3, без дополнительного запроса.
///
/// [lightPreference] держим строкой, а не enum: контракт не фиксирует множество
/// значений, а поле read-only (показываем как пришло — FLUTTER.md «Контент с
/// backend»). [careDifficulty] — domain enum, т.к. влияет на стилизацию/подпись
/// уровня в UI и множество значений известно (EASY/MEDIUM/HARD).
@freezed
abstract class SpeciesSummary with _$SpeciesSummary {
  const factory SpeciesSummary({
    required int id,
    required String name,
    String? latinName,

    /// Рекомендуемые интервалы ухода в днях (null/0 — рекомендации нет).
    int? wateringDays,
    int? mistingDays,
    int? fertilizingDays,
    int? soilCheckDays,
    @Default(CareDifficulty.unknown) CareDifficulty careDifficulty,

    /// Предпочтение по свету как пришло с backend (`LightPreference.name()`).
    String? lightPreference,
  }) = _SpeciesSummary;

  const SpeciesSummary._();

  /// «План ухода» для read-only превью (шаг 3): по одному пункту на каждый
  /// заданный интервал. Пропускает null и неположительные значения. Порядок
  /// детерминирован (полив → опрыскивание → удобрение → проверка почвы).
  List<CarePlanItem> get carePlan {
    final items = <CarePlanItem>[];
    void add(CareTaskType type, int? days) {
      if (days != null && days > 0) {
        items.add(CarePlanItem(type: type, everyDays: days));
      }
    }

    add(CareTaskType.watering, wateringDays);
    add(CareTaskType.misting, mistingDays);
    add(CareTaskType.fertilizing, fertilizingDays);
    add(CareTaskType.soilCheck, soilCheckDays);
    return List.unmodifiable(items);
  }
}
