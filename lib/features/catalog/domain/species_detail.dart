import 'package:freezed_annotation/freezed_annotation.dart';

import 'care_difficulty.dart';
import 'light_preference.dart';

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
  }) = _SpeciesDetail;
}
