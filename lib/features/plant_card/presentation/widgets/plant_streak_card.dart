import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/streak.dart';

/// Секция «Серия ухода»: счётчик on-time-уходов подряд ([Streak.count]).
///
/// Число считает backend — UI его лишь отображает. `count == 0` → дружелюбная
/// подпись «серии пока нет» (empty), а не голый ноль.
class PlantStreakCard extends StatelessWidget {
  const PlantStreakCard({super.key, required this.streak});

  final Streak streak;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final isEmpty = streak.count <= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.local_fire_department_rounded,
              size: 26,
              color: isEmpty ? c.inkMute : c.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.plantCardStreakTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: c.inkSoft,
                  ),
                ),
                const SizedBox(height: 2),
                if (isEmpty)
                  Text(
                    l10n.plantCardStreakEmpty,
                    style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.3),
                  )
                else ...[
                  Text(
                    l10n.plantCardStreakCount(streak.count),
                    style: AppTheme.serif(fontSize: 22, color: c.ink),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.plantCardStreakHint,
                    style: TextStyle(fontSize: 12, color: c.inkSoft),
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

/// Skeleton секции стрика (loading-состояние).
class PlantStreakCardSkeleton extends StatelessWidget {
  const PlantStreakCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: const Row(
        children: [
          SkeletonBox(width: 52, height: 52, radius: 18),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 90, height: 12),
                SizedBox(height: 8),
                SkeletonBox(width: 140, height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
