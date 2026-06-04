import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Пустое состояние «Всё в порядке» — растение здорово.
///
/// Отображается когда [PlantDiagnosis.isHealthy] == true.
class HealthyState extends StatelessWidget {
  const HealthyState({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Semantics(
      label: '${l10n.diagnosisHealthyTitle}. ${l10n.diagnosisHealthyMessage}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        decoration: BoxDecoration(
          color: c.primarySoft,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.leaf.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: c.leaf.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.eco_rounded,
                size: 36,
                color: c.leaf,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.diagnosisHealthyTitle,
              textAlign: TextAlign.center,
              style: AppTheme.serif(fontSize: 26, color: c.ink),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.diagnosisHealthyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: c.inkSoft,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
