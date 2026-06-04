import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/monthly_report.dart';
import '../report_format.dart';
import 'report_section_label.dart';

/// HERO отчёта: надстрочник «Отчёт · {месяц}», крупный серифный заголовок и
/// подзаголовок про стрик. Заголовок выбирается из реальных полей
/// (`onTimePct`/`streak`) — без выдуманных фактов/имён растений и без поэтики
/// с бэка (её backend не отдаёт).
class ReportHero extends StatelessWidget {
  const ReportHero({super.key, required this.report});

  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final monthLabel = ReportFormat.monthLabel(report.month, l10n.localeName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportSectionLabel(text: l10n.reportOverline(monthLabel)),
        const SizedBox(height: 6),
        Text(
          _title(l10n, report),
          style: AppTheme.serif(fontSize: 44, color: c.ink),
        ),
        const SizedBox(height: 8),
        Text(
          report.streak > 0
              ? l10n.reportSubtitleStreak(report.streak)
              : l10n.reportSubtitleNoStreak,
          style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }

  /// Выбор UI-строки заголовка по проценту вовремя. Это не доменный расчёт —
  /// `onTimePct` посчитан backend/моделью, здесь лишь выбор копирайта.
  String _title(AppLocalizations l10n, MonthlyReport report) {
    final pct = report.onTimePct;
    if (pct == null) return l10n.reportTitleNeutral;
    if (pct >= 0.85) return l10n.reportTitleGreat;
    if (pct >= 0.6) return l10n.reportTitleGood;
    return l10n.reportTitleNeutral;
  }
}
