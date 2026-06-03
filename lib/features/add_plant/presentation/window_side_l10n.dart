import '../../../l10n/app_localizations.dart';
import '../domain/window_side.dart';

/// UI-обвязка для [WindowSide]: локализованные подпись и краткое описание
/// освещённости. Без бизнес-логики — только перевод enum в строки.
extension WindowSideL10n on WindowSide {
  /// Короткая буква-метка для бейджа (С/В/Ю/З).
  String letter(AppLocalizations l10n) => switch (this) {
        WindowSide.south => 'Ю',
        WindowSide.east => 'В',
        WindowSide.west => 'З',
        WindowSide.north => 'С',
      };

  /// Локализованное название стороны.
  String label(AppLocalizations l10n) => switch (this) {
        WindowSide.south => l10n.addPlantWindowSouth,
        WindowSide.east => l10n.addPlantWindowEast,
        WindowSide.west => l10n.addPlantWindowWest,
        WindowSide.north => l10n.addPlantWindowNorth,
      };

  /// Краткое описание освещённости стороны.
  String hint(AppLocalizations l10n) => switch (this) {
        WindowSide.south => l10n.addPlantWindowSouthHint,
        WindowSide.east => l10n.addPlantWindowEastHint,
        WindowSide.west => l10n.addPlantWindowWestHint,
        WindowSide.north => l10n.addPlantWindowNorthHint,
      };
}
