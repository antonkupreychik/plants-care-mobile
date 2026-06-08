import '../../../l10n/app_localizations.dart';
import '../domain/plant_template.dart';

/// Маппинг [PlantTemplateCareType] → локализованное название (MADR-012).
extension PlantTemplateCareTypeL10n on AppLocalizations {
  String careTypeName(PlantTemplateCareType type) => switch (type) {
        PlantTemplateCareType.watering => plantTemplatesCareTypeWatering,
        PlantTemplateCareType.misting => plantTemplatesCareTypeMisting,
        PlantTemplateCareType.fertilizing => plantTemplatesCareTypeFertilizing,
        PlantTemplateCareType.soilCheck => plantTemplatesCareTypeSoilCheck,
        PlantTemplateCareType.unknown => type.name,
      };
}
