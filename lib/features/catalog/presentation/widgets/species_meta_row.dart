import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/care_difficulty.dart';
import '../../domain/light_preference.dart';
import '../species_attributes_l10n.dart';

/// Компактная строка метаданных вида: бейдж сложности (цветная точка + текст)
/// и предпочтение света — как в дизайне каталога (`screens-v4`, экран 12).
///
/// Цвет точки сложности: лёгкая/средняя → primary, сложная → terracotta,
/// неизвестная → inkMute (нейтрально). Свет пропускается, если `unknown`.
class SpeciesMetaRow extends StatelessWidget {
  const SpeciesMetaRow({
    super.key,
    required this.difficulty,
    required this.light,
  });

  final CareDifficulty difficulty;
  final LightPreference light;

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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wb_sunny_outlined, size: 13, color: c.inkMute),
              const SizedBox(width: 4),
              Text(
                l10n.labelForLight(light),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: c.inkSoft,
                ),
              ),
            ],
          ),
      ],
    );
  }

  static Color _dotColor(PcColors c, CareDifficulty difficulty) =>
      switch (difficulty) {
        CareDifficulty.easy || CareDifficulty.medium => c.primary,
        CareDifficulty.hard => c.terracotta,
        CareDifficulty.unknown => c.inkMute,
      };
}
