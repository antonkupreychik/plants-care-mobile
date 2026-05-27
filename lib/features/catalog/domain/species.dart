import 'package:freezed_annotation/freezed_annotation.dart';

import 'care_difficulty.dart';
import 'light_preference.dart';

part 'species.freezed.dart';

/// Краткая карточка вида для списка каталога (источник — `GET /api/v1/species`,
/// [SpeciesSummaryDto]). Экран 12.
///
/// Чистый Dart, иммутабельна. Интервалы ухода (`*Days`) nullable: backend может
/// не знать рекомендации для конкретного вида (`soilCheckDays` — особенно).
/// `description` здесь СОЗНАТЕЛЬНО нет: список его не отдаёт — деталь вида
/// моделируется отдельной [SpeciesDetail], чтобы тип не врал о наличии поля.
@freezed
abstract class Species with _$Species {
  const factory Species({
    required int id,
    required String name,

    /// Латинское имя (`Monstera deliciosa`). У части видов может отсутствовать.
    String? latinName,

    /// Рекомендуемый интервал полива в днях.
    int? wateringDays,

    /// Рекомендуемый интервал опрыскивания в днях.
    int? mistingDays,

    /// Рекомендуемый интервал подкормки в днях.
    int? fertilizingDays,

    /// Рекомендуемый интервал проверки грунта в днях.
    int? soilCheckDays,

    /// Сложность ухода (domain-enum, замаплен из строки backend).
    @Default(CareDifficulty.unknown) CareDifficulty careDifficulty,

    /// Предпочтение освещённости (domain-enum, замаплен из строки backend).
    @Default(LightPreference.unknown) LightPreference lightPreference,
  }) = _Species;
}
