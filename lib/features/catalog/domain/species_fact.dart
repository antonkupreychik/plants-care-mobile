import 'package:freezed_annotation/freezed_annotation.dart';

import 'species_fact_category.dart';

part 'species_fact.freezed.dart';

/// Справочный факт о виде (источник — `SpeciesFactDto`, элемент
/// `SpeciesDetailDto.facts`). Уход, происхождение, токсичность и т.п.
///
/// `category` нормализована в [SpeciesFactCategory] в data-слое (открытый
/// перечень строк backend → enum, неизвестное → [SpeciesFactCategory.unknown]).
/// `source` nullable: указан не у всех фактов (напр. ASPCA для токсичности).
@freezed
abstract class SpeciesFact with _$SpeciesFact {
  const factory SpeciesFact({
    required SpeciesFactCategory category,
    required String title,
    required String body,

    /// Источник факта (напр. `ASPCA`), если указан.
    String? source,
  }) = _SpeciesFact;
}
