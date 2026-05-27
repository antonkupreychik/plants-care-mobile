import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/species_detail.dart';

/// Секция «Уход»: список рекомендованных интервалов (полив/опрыскивание/
/// подкормка/проверка грунта). Каждый интервал nullable — отсутствующие
/// пропускаются. Если все интервалы пусты — секция не строится (см.
/// [SpeciesCareSection.hasAny]).
class SpeciesCareSection extends StatelessWidget {
  const SpeciesCareSection({super.key, required this.detail});

  final SpeciesDetail detail;

  /// Есть ли хотя бы один известный интервал ухода (вызывающий решает, рисовать
  /// ли секцию вообще).
  static bool hasAny(SpeciesDetail detail) =>
      detail.wateringDays != null ||
      detail.mistingDays != null ||
      detail.fertilizingDays != null ||
      detail.soilCheckDays != null;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final rows = <_CareRow>[
      if (detail.wateringDays != null)
        _CareRow(
          icon: Icons.water_drop_outlined,
          label: l10n.speciesCareWatering,
          days: detail.wateringDays!,
        ),
      if (detail.mistingDays != null)
        _CareRow(
          icon: Icons.grain_rounded,
          label: l10n.speciesCareMisting,
          days: detail.mistingDays!,
        ),
      if (detail.fertilizingDays != null)
        _CareRow(
          icon: Icons.eco_outlined,
          label: l10n.speciesCareFertilizing,
          days: detail.fertilizingDays!,
        ),
      if (detail.soilCheckDays != null)
        _CareRow(
          icon: Icons.spa_outlined,
          label: l10n.speciesCareSoilCheck,
          days: detail.soilCheckDays!,
        ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: c.line),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _CareRow extends StatelessWidget {
  const _CareRow({
    required this.icon,
    required this.label,
    required this.days,
  });

  final IconData icon;
  final String label;
  final int days;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: c.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
          ),
          Text(
            l10n.speciesCareEveryDays(days),
            style: TextStyle(fontSize: 13, color: c.inkSoft),
          ),
        ],
      ),
    );
  }
}
