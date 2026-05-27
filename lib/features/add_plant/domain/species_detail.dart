import 'package:freezed_annotation/freezed_annotation.dart';

import 'care_plan_item.dart';
import 'species_summary.dart';

part 'species_detail.freezed.dart';

/// Полная карточка вида (`SpeciesDetailDto`, `GET /species/{id}`).
///
/// Чистый Dart. Композиция, а не наследование: держит [summary] (все интервалы
/// и метаданные) плюс [description]. Это избегает дублирования полей и
/// позволяет переиспользовать [SpeciesSummary.carePlan] на превью.
///
/// Отдельный запрос деталей нужен только ради [description] — интервалы для
/// «плана ухода» уже есть в выбранном [SpeciesSummary] (см. провайдеры).
@freezed
abstract class SpeciesDetail with _$SpeciesDetail {
  const factory SpeciesDetail({
    required SpeciesSummary summary,

    /// Длинное текстовое описание вида (может отсутствовать).
    String? description,
  }) = _SpeciesDetail;

  const SpeciesDetail._();

  /// Делегирует план ухода вложенному [summary].
  List<CarePlanItem> get carePlan => summary.carePlan;
}
