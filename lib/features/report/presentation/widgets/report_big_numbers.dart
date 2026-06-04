import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/monthly_report.dart';

/// Сетка 2×2 крупных чисел отчёта (дизайн v4 «BIG NUMBERS») из реальных полей:
/// стрик, выполнено, вовремя (NN% / «—»), пропусков. Одна карточка акцентная
/// (на `primary`). Дельты v4 («+12 к рекорду») опущены — данных нет.
class ReportBigNumbers extends StatelessWidget {
  const ReportBigNumbers({super.key, required this.report});

  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final pct = report.onTimePct;
    final pctText = pct == null
        ? l10n.reportNoData
        : l10n.reportPercent((pct * 100).round());

    final cards = <Widget>[
      _StatCard(
        value: '${report.streak}',
        label: l10n.reportStatStreak,
        tint: c.primary,
      ),
      _StatCard(
        value: '${report.done}',
        label: l10n.reportStatDone,
        tint: c.terracotta,
      ),
      _StatCard(
        value: pctText,
        label: l10n.reportStatOnTime,
        tint: c.leafDark,
      ),
      _StatCard(
        value: '${report.overdue}',
        label: l10n.reportStatOverdue,
        tint: c.primary,
        accent: true,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.25,
      children: cards,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.tint,
    this.accent = false,
  });

  final String value;
  final String label;
  final Color tint;

  /// Акцентная карточка — заливка `primary`, текст инверсный.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final valueColor = accent ? c.surface : tint;
    final labelColor = accent ? c.surface : c.inkSoft;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent ? c.primary : c.surface,
        borderRadius: BorderRadius.circular(22),
        border: accent ? null : Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.serif(fontSize: 46, color: valueColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              height: 1.3,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}
