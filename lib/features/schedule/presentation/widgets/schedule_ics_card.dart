import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Карточка «Подписаться в календаре» (.ics).
///
/// BACKEND-GAP: эндпоинта `/calendar.ics` в API нет, поэтому карточка инертна —
/// тап вызывает coming-soon snackbar ([onComingSoon]). Показывается визуально,
/// но без реальной подписки.
class ScheduleIcsCard extends StatelessWidget {
  const ScheduleIcsCard({super.key, required this.onComingSoon});

  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      label: l10n.scheduleIcsTitle,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onComingSoon,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.line),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: c.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.scheduleIcsTitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: c.ink,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        l10n.scheduleIcsSubtitle,
                        style: TextStyle(fontSize: 11, color: c.inkSoft),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 20, color: c.inkSoft),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
