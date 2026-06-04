import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/care_history_summary.dart';

/// Сводка экрана 21: три плитки (всего / вовремя% / стрик).
///
/// Деградирует мягко: пока [summary] == null (история ещё грузится) — показывает
/// skeleton. Процент «вовремя» приблизителен по загруженным записям (G29) —
/// акцентная плитка. Стрик 0 не прячем (валидное «серии нет»).
class CareHistorySummaryHeader extends StatelessWidget {
  const CareHistorySummaryHeader({super.key, required this.summary});

  /// `null` — данных истории ещё нет (loading), рисуем skeleton.
  final CareHistorySummary? summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = summary;
    if (s == null) return const CareHistorySummaryHeaderSkeleton();

    return Row(
      children: [
        Expanded(
          child: _Tile(
            value: l10n.careHistorySummaryTotalValue(s.total),
            label: l10n.careHistorySummaryTotalLabel,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Tile(
            value: l10n.careHistorySummaryOnTimeValue(s.onTimePercent),
            label: l10n.careHistorySummaryOnTimeLabel,
            accent: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Tile(
            value: l10n.careHistorySummaryStreakValue(s.streakCount),
            label: l10n.careHistorySummaryStreakLabel,
          ),
        ),
      ],
    );
  }
}

/// Skeleton сводки (loading первичной загрузки истории).
class CareHistorySummaryHeaderSkeleton extends StatelessWidget {
  const CareHistorySummaryHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: SkeletonBox(height: 74, radius: 18)),
        SizedBox(width: 8),
        Expanded(child: SkeletonBox(height: 74, radius: 18)),
        SizedBox(width: 8),
        Expanded(child: SkeletonBox(height: 74, radius: 18)),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.value,
    required this.label,
    this.accent = false,
  });

  final String value;
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final fg = accent ? c.surface : c.ink;
    final valueColor = accent ? c.surface : c.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: accent ? c.primary : c.surface,
        borderRadius: BorderRadius.circular(18),
        border: accent ? null : Border.all(color: c.line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTheme.serif(fontSize: 28, color: valueColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              height: 1.2,
              color: fg.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}
