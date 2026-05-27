import '../../../l10n/app_localizations.dart';
import '../domain/care_difficulty.dart';
import '../domain/light_preference.dart';

/// Локализованные подписи доменных enum'ов вида (сложность ухода, свет).
///
/// Перевод кода → текст — презентационная обвязка (MADR-012), живёт в UI-слое,
/// а не в виджете литералом. Доменные enum'ы остаются чистыми.
extension CareDifficultyL10n on AppLocalizations {
  String labelForDifficulty(CareDifficulty difficulty) => switch (difficulty) {
        CareDifficulty.easy => speciesDifficultyEasy,
        CareDifficulty.medium => speciesDifficultyMedium,
        CareDifficulty.hard => speciesDifficultyHard,
        CareDifficulty.unknown => speciesDifficultyUnknown,
      };

  String labelForLight(LightPreference light) => switch (light) {
        LightPreference.fullSun => speciesLightFullSun,
        LightPreference.brightIndirect => speciesLightBrightIndirect,
        LightPreference.partialShade => speciesLightPartialShade,
        LightPreference.shade => speciesLightShade,
        LightPreference.unknown => speciesLightUnknown,
      };
}
