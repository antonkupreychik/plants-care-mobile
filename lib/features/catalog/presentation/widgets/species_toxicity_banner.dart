import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/species_detail.dart';
import '../../domain/species_fact.dart';

/// Баннер токсичности вида (🐈) — по дизайну v5 (`screens-v5.jsx`, блок
/// TOXICITY banner): иконка-эмодзи + заголовок (terracotta) + пояснение.
///
/// Данные — реальные, из `facts[TOXICITY]` ([SpeciesDetail.toxicityFact]):
/// заголовок = `title`, пояснение = `body`, опц. источник = `source`.
///
/// Структурного флага `toxic: bool` в API всё ещё нет — это остаётся
/// BACKEND-GAPS G28 (нужен, например, для бейджа «токсично» в списке каталога).
/// Здесь это не требуется: баннер показывается по наличию факта токсичности.
class SpeciesToxicityBanner extends StatelessWidget {
  const SpeciesToxicityBanner({super.key, required this.detail});

  final SpeciesDetail detail;

  /// Показывать ли баннер: только когда есть факт токсичности.
  static bool shouldShow(SpeciesDetail detail) => detail.toxicityFact != null;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    // shouldShow гарантирует наличие факта в дереве; на всякий случай — guard.
    final SpeciesFact? fact = detail.toxicityFact;
    if (fact == null) return const SizedBox.shrink();

    final title = fact.title.trim().isNotEmpty
        ? fact.title.trim()
        : l10n.speciesToxicTitle;
    final body = fact.body.trim();
    final source = fact.source?.trim();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.terracotta.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.terracotta.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🐈', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: c.terracotta,
                  ),
                ),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  // body из API может быть длинным — переносим целиком,
                  // без обрезки, чтобы не терять важное предупреждение.
                  Text(
                    body,
                    style: TextStyle(fontSize: 11, color: c.inkSoft),
                  ),
                ],
                if (source != null && source.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    source,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: c.inkSoft.withValues(alpha: 0.8),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
