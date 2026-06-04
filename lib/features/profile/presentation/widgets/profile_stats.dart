import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/profile_summary.dart';

/// Блок статистики экрана «Я» (экран 13): счётчики в одной плашке.
///
/// «Растения» — всегда ([ProfileSummary.plantsTotal]). «Уходов» —
/// ТОЛЬКО когда backend отдаёт [ProfileSummary.totalCareEvents] (graceful
/// degradation: поле ждёт plants-care#226; до тех пор блок «Уходов» скрыт, без
/// заглушки-нуля). Если оба отсутствуют — единственный счётчик «Растения»
/// растягивается на всю ширину.
class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key, required this.summary});

  final ProfileSummary summary;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final careEvents = summary.totalCareEvents;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: _StatCell(
              value: '${summary.plantsTotal}',
              label: l10n.profileStatPlants,
            ),
          ),
          if (careEvents != null) ...[
            Container(width: 1, height: 40, color: c.line),
            Expanded(
              child: _StatCell(
                value: '$careEvents',
                label: l10n.profileStatCareEvents,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: c.ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: c.inkSoft)),
      ],
    );
  }
}
