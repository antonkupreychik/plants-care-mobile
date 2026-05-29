import '../../../../core/api/generated/models/page_response_species_summary_dto.dart';
import '../../../../core/api/generated/models/species_detail_dto.dart';
import '../../../../core/api/generated/models/species_fact_dto.dart';
import '../../../../core/api/generated/models/species_summary_dto.dart';
import '../../domain/care_difficulty.dart';
import '../../domain/light_preference.dart';
import '../../domain/species.dart';
import '../../domain/species_detail.dart';
import '../../domain/species_fact.dart';
import '../../domain/species_fact_category.dart';
import '../../domain/species_page.dart';

/// Маппинг видов: сгенерированные DTO (`/api/v1/species`) → domain (MADR-002).
///
/// Backend отдаёт `careDifficulty` / `lightPreference` строкой (имя enum'а,
/// напр. `EASY`, `BRIGHT_INDIRECT`) — нормализуем в domain-enum здесь, точка
/// нормализации контракта. Неизвестный/`null` код → `*.unknown` (не падаем).

extension SpeciesSummaryDtoMapper on SpeciesSummaryDto {
  Species toDomain() => Species(
        id: id,
        name: name,
        latinName: latinName,
        wateringDays: wateringDays,
        mistingDays: mistingDays,
        fertilizingDays: fertilizingDays,
        soilCheckDays: soilCheckDays,
        careDifficulty: _careDifficultyFromApi(careDifficulty),
        lightPreference: _lightPreferenceFromApi(lightPreference),
      );
}

extension SpeciesDetailDtoMapper on SpeciesDetailDto {
  SpeciesDetail toDomain() => SpeciesDetail(
        id: id,
        name: name,
        latinName: latinName,
        wateringDays: wateringDays,
        mistingDays: mistingDays,
        fertilizingDays: fertilizingDays,
        soilCheckDays: soilCheckDays,
        careDifficulty: _careDifficultyFromApi(careDifficulty),
        lightPreference: _lightPreferenceFromApi(lightPreference),
        description: description,
        facts: facts
                ?.map((dto) => dto.toDomain())
                .toList(growable: false) ??
            const <SpeciesFact>[],
      );
}

extension SpeciesFactDtoMapper on SpeciesFactDto {
  SpeciesFact toDomain() => SpeciesFact(
        category: _factCategoryFromApi(category),
        title: title,
        body: body,
        source: source,
      );
}

extension PageResponseSpeciesSummaryDtoMapper on PageResponseSpeciesSummaryDto {
  SpeciesPage toDomain() => SpeciesPage(
        items: items.map((dto) => dto.toDomain()).toList(growable: false),
        total: total,
        offset: offset,
        limit: limit,
      );
}

/// `CareDifficulty.name()` backend → domain-enum. Регистр приводим к верхнему
/// на случай вариаций; пустое/неизвестное → [CareDifficulty.unknown].
CareDifficulty _careDifficultyFromApi(String? raw) => switch (raw?.toUpperCase()) {
      'EASY' => CareDifficulty.easy,
      'MEDIUM' => CareDifficulty.medium,
      'HARD' => CareDifficulty.hard,
      _ => CareDifficulty.unknown,
    };

/// `LightPreference.name()` backend → domain-enum. Контракт не фиксирует полный
/// перечень — известные коды маппим, остальное → [LightPreference.unknown].
///
/// Dev-backend отдаёт сокращённые коды (`BRIGHT`, `PARTIAL`, `SHADE`), тогда как
/// api-contract документирует развёрнутые (`BRIGHT_INDIRECT`, `PARTIAL_SHADE`).
/// Распознаём оба варианта — на случай смены окружения. `BRIGHT` семантически
/// трактуем как яркий рассеянный свет (→ [LightPreference.brightIndirect]).
LightPreference _lightPreferenceFromApi(String? raw) => switch (raw?.toUpperCase()) {
      'FULL_SUN' => LightPreference.fullSun,
      'BRIGHT' || 'BRIGHT_INDIRECT' => LightPreference.brightIndirect,
      'PARTIAL' || 'PARTIAL_SHADE' => LightPreference.partialShade,
      'SHADE' => LightPreference.shade,
      _ => LightPreference.unknown,
    };

/// `SpeciesFactDto.category` backend → domain-enum. Перечень категорий открытый
/// (`CARE` | `CURIOSITY` | `ORIGIN` | `TOXICITY` | …), известные коды маппим,
/// остальное → [SpeciesFactCategory.unknown] (не падаем). Регистр приводим к
/// верхнему на случай вариаций.
SpeciesFactCategory _factCategoryFromApi(String raw) => switch (raw.toUpperCase()) {
      'CARE' => SpeciesFactCategory.care,
      'CURIOSITY' => SpeciesFactCategory.curiosity,
      'ORIGIN' => SpeciesFactCategory.origin,
      'TOXICITY' => SpeciesFactCategory.toxicity,
      _ => SpeciesFactCategory.unknown,
    };
