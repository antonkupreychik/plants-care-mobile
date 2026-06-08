import '../../../../core/api/generated/models/plant_template_care_rule_dto.dart';
import '../../../../core/api/generated/models/plant_template_care_rule_dto_care_type.dart';
import '../../../../core/api/generated/models/plant_template_dto.dart';
import '../../domain/plant_template.dart';

/// Маппинг [PlantTemplateDto] → domain [PlantTemplate] (MADR-007).
///
/// Сгенерированный DTO не трогаем; маппинг пишется руками.
extension PlantTemplateDtoMapper on PlantTemplateDto {
  PlantTemplate toDomain() => PlantTemplate(
        id: id,
        name: name,
        careRules: careRules
            .map((r) => r.toDomain())
            .toList(growable: false),
        createdAt: createdAt,
      );
}

/// Маппинг [PlantTemplateCareRuleDto] → domain [PlantTemplateCareRule].
extension PlantTemplateCareRuleDtoMapper on PlantTemplateCareRuleDto {
  PlantTemplateCareRule toDomain() => PlantTemplateCareRule(
        careType: careType.toDomain(),
        intervalDays: intervalDays,
      );
}

/// Маппинг DTO care-type enum → domain enum.
extension PlantTemplateCareRuleDtoCareTypeMapper
    on PlantTemplateCareRuleDtoCareType {
  PlantTemplateCareType toDomain() => switch (this) {
        PlantTemplateCareRuleDtoCareType.watering =>
          PlantTemplateCareType.watering,
        PlantTemplateCareRuleDtoCareType.misting =>
          PlantTemplateCareType.misting,
        PlantTemplateCareRuleDtoCareType.fertilizing =>
          PlantTemplateCareType.fertilizing,
        PlantTemplateCareRuleDtoCareType.soilCheck =>
          PlantTemplateCareType.soilCheck,
        PlantTemplateCareRuleDtoCareType.$unknown =>
          PlantTemplateCareType.unknown,
      };
}
