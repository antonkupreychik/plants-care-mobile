import '../../../l10n/app_localizations.dart';
import '../domain/care_difficulty.dart';

/// UI-обвязка для [CareDifficulty]: локализованная подпись уровня ухода.
///
/// Без бизнес-логики — только перевод enum в строку. `unknown` не несёт
/// подписи (вызывающий просто не рисует бейдж).
extension CareDifficultyL10n on CareDifficulty {
  /// Локализованная подпись или `null` для [CareDifficulty.unknown]
  /// (нераспознанный уровень — бейдж не показываем).
  String? labelOrNull(AppLocalizations l10n) => switch (this) {
        CareDifficulty.easy => l10n.careDifficultyEasy,
        CareDifficulty.medium => l10n.careDifficultyMedium,
        CareDifficulty.hard => l10n.careDifficultyHard,
        CareDifficulty.unknown => null,
      };
}
