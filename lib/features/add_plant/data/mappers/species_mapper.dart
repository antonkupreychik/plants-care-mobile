import '../../../../core/api/generated/models/species_detail_dto.dart';
import '../../../../core/api/generated/models/species_summary_dto.dart';
import '../../domain/care_difficulty.dart';
import '../../domain/species_detail.dart';
import '../../domain/species_summary.dart';

/// Маппинг DTO видов (`/species`) → domain (MADR-002).
///
/// `careDifficulty` (строка `EASY/MEDIUM/HARD`) нормализуется в domain-enum
/// через [CareDifficulty.fromApi]; неизвестное → `unknown`, не падаем.
/// `lightPreference` пробрасывается как есть (read-only контент backend).
extension SpeciesSummaryDtoMapper on SpeciesSummaryDto {
  SpeciesSummary toDomain() => SpeciesSummary(
        id: id,
        name: name,
        latinName: latinName,
        wateringDays: wateringDays,
        mistingDays: mistingDays,
        fertilizingDays: fertilizingDays,
        soilCheckDays: soilCheckDays,
        careDifficulty: CareDifficulty.fromApi(careDifficulty),
        lightPreference: lightPreference,
      );
}

/// Маппинг [SpeciesDetailDto] → domain [SpeciesDetail]. Переиспользует структуру
/// summary (все интервалы) + добавляет `description`.
extension SpeciesDetailDtoMapper on SpeciesDetailDto {
  SpeciesDetail toDomain() => SpeciesDetail(
        summary: SpeciesSummary(
          id: id,
          name: name,
          latinName: latinName,
          wateringDays: wateringDays,
          mistingDays: mistingDays,
          fertilizingDays: fertilizingDays,
          soilCheckDays: soilCheckDays,
          careDifficulty: CareDifficulty.fromApi(careDifficulty),
          lightPreference: lightPreference,
        ),
        description: description,
      );
}
