import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/care_difficulty.dart';
import '../../domain/light_preference.dart';
import '../../domain/species_detail.dart';
import '../species_attributes_l10n.dart';
import 'species_meta_row.dart';

/// Сетка фактов вида 2×2 (после hero). Карточки: иконка в плашке + label +
/// значение. По дизайну v5 (`screens-v5.jsx`, блок FACTS grid).
///
/// Состав по доступным данным:
/// - «Сложность» — всегда (с цветной точкой как в [SpeciesMetaRow]);
/// - «Свет» — только если `lightPreference != unknown`;
/// - «Полив» — только если задан `wateringDays`.
///
/// Факт «Рост» из дизайна НЕ добавляем — поля роста в API нет, фейк недопустим.
/// Если карточек < 1 — секция не строится (см. [SpeciesFactsGrid.hasAny]).
class SpeciesFactsGrid extends StatelessWidget {
  const SpeciesFactsGrid({super.key, required this.detail});

  final SpeciesDetail detail;

  /// Есть ли хотя бы один факт для отображения (сложность есть всегда, кроме
  /// `unknown`).
  static bool hasAny(SpeciesDetail detail) =>
      detail.careDifficulty != CareDifficulty.unknown ||
      detail.lightPreference != LightPreference.unknown ||
      detail.wateringDays != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final facts = <Widget>[
      if (detail.careDifficulty != CareDifficulty.unknown)
        _FactCard(
          icon: Icons.eco_outlined,
          label: l10n.speciesFactDifficulty,
          value: l10n.labelForDifficulty(detail.careDifficulty),
          dotColor: SpeciesMetaRow.dotColorFor(context, detail.careDifficulty),
        ),
      if (detail.lightPreference != LightPreference.unknown)
        _FactCard(
          icon: Icons.wb_sunny_outlined,
          label: l10n.speciesFactLight,
          value: l10n.labelForLight(detail.lightPreference),
        ),
      if (detail.wateringDays != null)
        _FactCard(
          icon: Icons.water_drop_outlined,
          label: l10n.speciesFactWatering,
          value: l10n.speciesWateringEveryDays(detail.wateringDays!),
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Две колонки; на узких экранах/крупном шрифте карточка может стать
        // выше — высота не фиксируется (содержимое определяет).
        const gap = 10.0;
        final cardWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final fact in facts)
              SizedBox(width: cardWidth, child: fact),
          ],
        );
      },
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({
    required this.icon,
    required this.label,
    required this.value,
    this.dotColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: c.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: c.inkSoft,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dotColor != null) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Flexible(
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: c.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
