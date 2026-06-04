import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/care_difficulty.dart';
import '../../domain/light_preference.dart';
import '../species_attributes_l10n.dart';

/// Компактная строка метаданных вида: бейдж сложности (цветная точка + текст),
/// предпочтение света (через текстовый разделитель «·») и бейдж токсичности —
/// как в дизайне каталога (`screens-v4`, экран 12, issue #80, п.3,7,8).
///
/// Цвет точки сложности (дизайн `diffOk`): лёгкая → primary; средняя/сложная →
/// terracotta; неизвестная → inkMute (нейтрально). Свет пропускается, если
/// `unknown`. Бейдж «⚠ ТОКСИЧНО · 🐈» показывается при `toxic == true`.
class SpeciesMetaRow extends StatelessWidget {
  const SpeciesMetaRow({
    super.key,
    required this.difficulty,
    required this.light,
    this.toxic = false,
  });

  final CareDifficulty difficulty;
  final LightPreference light;

  /// Токсичен (для кошек) — показывать бейдж токсичности в конце строки.
  final bool toxic;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _dotColor(c, difficulty),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              l10n.labelForDifficulty(difficulty),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: c.inkSoft,
              ),
            ),
          ],
        ),
        if (light != LightPreference.unknown)
          Text(
            '· ${l10n.labelForLight(light)}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c.inkSoft,
            ),
          ),
        if (toxic) _ToxicBadge(text: l10n.catalogBadgeToxic),
      ],
    );
  }

  static Color _dotColor(PcColors c, CareDifficulty difficulty) =>
      switch (difficulty) {
        CareDifficulty.easy => c.primary,
        CareDifficulty.medium || CareDifficulty.hard => c.terracotta,
        CareDifficulty.unknown => c.inkMute,
      };

  /// Цвет точки сложности по токенам текущей темы — переиспользуется в
  /// фактах-сетке детали вида (единый маппинг сложность → цвет).
  static Color dotColorFor(BuildContext context, CareDifficulty difficulty) =>
      _dotColor(Theme.of(context).extension<PcColors>()!, difficulty);
}

/// Бейдж токсичности «⚠ ТОКСИЧНО · 🐈» (issue #80, п.3, дизайн `screens-v4`).
/// Терракотовый текст на светло-терракотовой подложке; подложка зависит от
/// темы (светлая — песочный тон, тёмная — полупрозрачная терракота).
class _ToxicBadge extends StatelessWidget {
  const _ToxicBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? c.terracotta.withValues(alpha: 0.18)
        : const Color(0xFFFBEFE4);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: c.terracotta,
        ),
      ),
    );
  }
}
