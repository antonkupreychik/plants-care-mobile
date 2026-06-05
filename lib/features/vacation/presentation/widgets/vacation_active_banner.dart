import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../vacation_screen.dart' show formatVacationDate;

/// Баннер активного режима отпуска (экран 25): «Отпуск включён» + до какой даты
/// напоминания на паузе. [pausedUntil] — UTC-момент из backend; показываем в
/// локальной зоне пользователя. `null` → подпись без даты.
class VacationActiveBanner extends StatelessWidget {
  const VacationActiveBanner({super.key, this.pausedUntil});

  final DateTime? pausedUntil;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final until = pausedUntil;
    final subtitle = until != null
        ? l10n.vacationActiveBannerUntil(
            formatVacationDate(context, until.toLocal()),
          )
        : l10n.vacationActiveBannerNoDate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🏖', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          Text(
            l10n.vacationActiveBannerTitle,
            style: AppTheme.serif(fontSize: 24, color: c.ink),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
          ),
        ],
      ),
    );
  }
}
