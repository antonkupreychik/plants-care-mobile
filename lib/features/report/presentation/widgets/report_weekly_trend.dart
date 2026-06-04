import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/weekly_health_bucket.dart';
import '../report_format.dart';
import 'report_section_label.dart';

/// Недельный тренд (дизайн v4): для каждой недели — подпись, число выполненных
/// и мини-полоса доли вовремя. Полосы нарисованы через [FractionallySizedBox]
/// поверх дорожки (Container) — без сторонних чарт-пакетов.
///
/// Родитель скрывает секцию при пустом списке; здесь подстраховка.
class ReportWeeklyTrend extends StatelessWidget {
  const ReportWeeklyTrend({super.key, required this.buckets});

  final List<WeeklyHealthBucket> buckets;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    if (buckets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportSectionLabel(text: l10n.reportTrendLabel),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.line),
          ),
          child: Column(
            children: [
              for (var i = 0; i < buckets.length; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                _WeekRow(bucket: buckets[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow({required this.bucket});

  final WeeklyHealthBucket bucket;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    // onTimePct из домена в [0,1]; подстраховываемся clamp для ширины полосы.
    final fraction = bucket.onTimePct.clamp(0.0, 1.0);
    final pctText = l10n.reportPercent((fraction * 100).round());
    final weekText = l10n.reportWeekLabel(ReportFormat.weekNumber(bucket.week));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                weekText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c.ink,
                ),
              ),
            ),
            Text(
              l10n.reportTrendWeekDone(bucket.done),
              style: TextStyle(fontSize: 12, color: c.inkSoft),
            ),
            const SizedBox(width: 10),
            Text(
              pctText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: c.leafDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 8,
            width: double.infinity,
            color: c.surfaceWarm,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction == 0 ? null : fraction,
              child: ColoredBox(color: c.leaf),
            ),
          ),
        ),
      ],
    );
  }
}
