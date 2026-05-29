import 'package:freezed_annotation/freezed_annotation.dart';

import 'care_difficulty.dart';
import 'light_preference.dart';
import 'species_fact.dart';
import 'species_fact_category.dart';

part 'species_detail.freezed.dart';

/// Полная карточка вида (источник — `GET /api/v1/species/{id}`,
/// [SpeciesDetailDto]). Экран 13.
///
/// Отдельная модель, а не [Species] с `description?`: деталь — единственный
/// эндпоинт, где `description` приходит, и тип это фиксирует (список не обязан
/// носить пустое поле). Остальные поля повторяют [Species] — дублирование здесь
/// дешевле, чем наследование/композиция ради одного поля, и держит модель плоской
/// для UI. `description` nullable: backend может не иметь текста для вида.
@freezed
abstract class SpeciesDetail with _$SpeciesDetail {
  const factory SpeciesDetail({
    required int id,
    required String name,
    String? latinName,
    int? wateringDays,
    int? mistingDays,
    int? fertilizingDays,
    int? soilCheckDays,
    @Default(CareDifficulty.unknown) CareDifficulty careDifficulty,
    @Default(LightPreference.unknown) LightPreference lightPreference,

    /// Длинное текстовое описание вида.
    String? description,

    /// Справочные факты о виде (уход, происхождение, токсичность и т.п.).
    /// Backend может не прислать поле/прислать пустой массив → `const []`.
    @Default(<SpeciesFact>[]) List<SpeciesFact> facts,
  }) = _SpeciesDetail;
}

/// Удобный доступ к токсичности для UI (баннер на экране 20).
extension SpeciesDetailToxicity on SpeciesDetail {
  /// Первый факт с категорией [SpeciesFactCategory.toxicity], если есть.
  /// `null` → вид нетоксичен / данных нет → UI баннер не рисует.
  SpeciesFact? get toxicityFact {
    for (final fact in facts) {
      if (fact.category == SpeciesFactCategory.toxicity) return fact;
    }
    return null;
  }
}
