import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/care_event_kind.dart';

/// UI-обвязка для [CareEventKind]: локализованная подпись выполненного ухода
/// в дневнике и иконка типа.
///
/// Без бизнес-логики — только перевод enum в строку/глиф (аналог
/// `home/presentation/care_task_l10n.dart`).
extension CareEventKindL10n on CareEventKind {
  String doneLabel(AppLocalizations l10n) => switch (this) {
        CareEventKind.water => l10n.careDoneWater,
        CareEventKind.spray => l10n.careDoneSpray,
        CareEventKind.fertilize => l10n.careDoneFertilize,
        CareEventKind.unknown => l10n.careDoneUnknown,
      };

  IconData get icon => switch (this) {
        CareEventKind.water => Icons.water_drop_outlined,
        CareEventKind.spray => Icons.shower_outlined,
        CareEventKind.fertilize => Icons.eco_outlined,
        CareEventKind.unknown => Icons.spa_outlined,
      };
}
