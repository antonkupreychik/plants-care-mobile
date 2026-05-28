import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../domain/health_zone.dart';

/// Маппинг [HealthZone] → семантический цвет токенов (G1).
///
/// Источник правды по цветам — [PcColors] (`core/theme/tokens.dart`). Отдельного
/// `danger`/`red` токена в палитре нет, поэтому «опасную» зону (red) и зону
/// «внимание» (yellow) рисуем тёплым предупреждающим [PcColors.terracotta] —
/// ближайший семантический токен. «Хорошую» (green) — акцентным [PcColors.primary].
/// Никаких хардкод-цветов: только токены.
extension HealthZoneColor on HealthZone {
  /// Цвет дуги кольца и текста бейджа для этой зоны.
  Color foreground(PcColors c) => switch (this) {
        HealthZone.green => c.primary,
        HealthZone.yellow => c.terracotta,
        HealthZone.red => c.terracotta,
      };

  /// Фон бейджа для этой зоны — мягкая плашка под текст.
  Color badgeBackground(PcColors c) => switch (this) {
        HealthZone.green => c.primarySoft,
        HealthZone.yellow => c.surfaceWarm,
        HealthZone.red => c.surfaceWarm,
      };
}
