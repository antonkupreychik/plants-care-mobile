import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/species_detail.dart';

/// Баннер токсичности вида (🐈) — по дизайну v5 (`screens-v5.jsx`, блок
/// TOXICITY banner): иконка-эмодзи + заголовок (terracotta) + пояснение.
///
/// TODO(BACKEND-GAPS G28): поля `toxic` в API нет. Пока данных нет, баннер
/// НЕ отображается — никаких хардкод-значений «токсично». Когда backend
/// начнёт отдавать признак токсичности, добавьте поле в [SpeciesDetail] и
/// верните `true` из [shouldShow] (одна строка) — разметка ниже готова.
class SpeciesToxicityBanner extends StatelessWidget {
  const SpeciesToxicityBanner({super.key, required this.detail});

  final SpeciesDetail detail;

  /// Показывать ли баннер. Сейчас всегда `false` — данных о токсичности нет
  /// (G28). Единая точка включения, когда поле появится.
  static bool shouldShow(SpeciesDetail detail) => false;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

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
                  l10n.speciesToxicTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: c.terracotta,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.speciesToxicSubtitle,
                  style: TextStyle(fontSize: 11, color: c.inkSoft),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
