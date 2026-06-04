import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Карточка «Сбросить к рекомендованным» (экран 22). Показывается ТОЛЬКО когда
/// у вида есть рекомендованные интервалы (решает экран по
/// `recommendedIntervalsProvider`). Тап → сброс драфта к рекомендациям.
class ResetIntervalsCard extends StatelessWidget {
  const ResetIntervalsCard({
    super.key,
    required this.onTap,
    this.enabled = true,
  });

  final VoidCallback onTap;

  /// Заблокировать (например во время сохранения).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: c.primarySoft,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: c.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.eco_outlined, size: 18, color: c.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.editScheduleResetTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: c.primary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      l10n.editScheduleResetSubtitle,
                      style: TextStyle(fontSize: 11, color: c.inkSoft),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, size: 18, color: c.primary),
            ],
          ),
        ),
      ),
    );
  }
}
