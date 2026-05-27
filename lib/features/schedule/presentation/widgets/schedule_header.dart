import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Хедер экрана «График»: месяц (uppercase) + диапазон недели (сериф) и кнопки
/// листания ←/→ + кнопка возврата на текущую неделю.
///
/// Рисуется во всех состояниях (loading/error/data) — зависит только от
/// [weekStart], который доступен всегда. Даты форматируются через `intl`
/// `DateFormat` по `l10n.localeName`.
class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({
    super.key,
    required this.weekStart,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onCurrentWeek,
  });

  final DateTime weekStart;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onCurrentWeek;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final weekEnd = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day + 6,
    );

    final monthLabel =
        DateFormat.yMMMM(locale).format(weekStart).toUpperCase();
    final range = _rangeLabel(locale, weekStart, weekEnd);

    return Row(
      children: [
        _IconButton(
          icon: Icons.arrow_back_rounded,
          label: l10n.schedulePreviousWeek,
          onTap: onPreviousWeek,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                monthLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: c.inkSoft,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                range,
                textAlign: TextAlign.center,
                style: AppTheme.serif(fontSize: 20, color: c.ink),
              ),
            ],
          ),
        ),
        _IconButton(
          icon: Icons.today_rounded,
          label: l10n.scheduleToCurrentWeek,
          onTap: onCurrentWeek,
        ),
        const SizedBox(width: 6),
        _IconButton(
          icon: Icons.arrow_forward_rounded,
          label: l10n.scheduleNextWeek,
          onTap: onNextWeek,
        ),
      ],
    );
  }

  /// Диапазон «11 – 17 мая» (общий месяц) или «28 апр – 4 мая» (разные месяцы).
  static String _rangeLabel(String locale, DateTime start, DateTime end) {
    final endLabel = DateFormat.MMMMd(locale).format(end);
    if (start.month == end.month) {
      final startDay = DateFormat.d(locale).format(start);
      return '$startDay – $endLabel';
    }
    final startLabel = DateFormat.MMMMd(locale).format(start);
    return '$startLabel – $endLabel';
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: c.surface,
          shape: CircleBorder(side: BorderSide(color: c.line)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(icon, size: 20, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}
