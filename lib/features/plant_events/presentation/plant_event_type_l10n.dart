import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/plant_event_type.dart';

/// UI-обвязка для [PlantEventType]: локализованная подпись и иконка типа.
///
/// Без бизнес-логики — только перевод enum в строку/глиф (аналог
/// `care_event_kind_l10n.dart`). Domain про ассеты/локализацию не знает.
extension PlantEventTypeL10n on PlantEventType {
  String label(AppLocalizations l10n) => switch (this) {
        PlantEventType.transplant => l10n.plantEventTypeTransplant,
        PlantEventType.soilChange => l10n.plantEventTypeSoilChange,
        PlantEventType.pruning => l10n.plantEventTypePruning,
        PlantEventType.pestTreatment => l10n.plantEventTypePestTreatment,
      };

  IconData get icon => switch (this) {
        PlantEventType.transplant => Icons.yard_outlined,
        PlantEventType.soilChange => Icons.grass_outlined,
        PlantEventType.pruning => Icons.content_cut_rounded,
        PlantEventType.pestTreatment => Icons.bug_report_outlined,
      };
}
