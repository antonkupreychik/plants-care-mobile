import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Пустое состояние отчёта (`report.isEmpty`: за месяц нет ни выполнений, ни
/// просрочек). Дружелюбная карточка с иконкой, серифным заголовком и подсказкой
/// — не голый экран.
class ReportEmpty extends StatelessWidget {
  const ReportEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.eco_outlined, size: 28, color: c.primary),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.reportEmptyTitle,
            textAlign: TextAlign.center,
            style: AppTheme.serif(fontSize: 26, color: c.ink),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.reportEmptyBody,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.45),
          ),
        ],
      ),
    );
  }
}
