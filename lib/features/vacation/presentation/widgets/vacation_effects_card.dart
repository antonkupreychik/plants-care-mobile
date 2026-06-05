import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Карточка «Что будет с садом» (экран 25): два пункта — пуши на паузе и
/// поведение дедлайнов (не переносятся, копятся в сводку «С возвращением!»).
/// Чисто информационная — backend поведение фиксировано (см. спеку vacation).
class VacationEffectsCard extends StatelessWidget {
  const VacationEffectsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _EffectRow(
            icon: Icons.notifications_off_outlined,
            title: l10n.vacationPausePushTitle,
            subtitle: l10n.vacationPausePushSubtitle,
          ),
          Divider(height: 1, thickness: 1, color: c.line),
          _EffectRow(
            icon: Icons.event_busy_outlined,
            title: l10n.vacationDeadlinesTitle,
            subtitle: l10n.vacationDeadlinesSubtitle,
          ),
        ],
      ),
    );
  }
}

class _EffectRow extends StatelessWidget {
  const _EffectRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: c.surfaceWarm,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: c.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: c.inkSoft, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
