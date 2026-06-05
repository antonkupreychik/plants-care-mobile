import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../vacation_screen.dart' show formatVacationDateShort;

/// Карточка одной границы диапазона отпуска («С» / «По», экран 25). Тап →
/// `showDatePicker` (логика в родителе). Показывает подпись и дату курсивом-сериф.
class VacationDateCard extends StatelessWidget {
  const VacationDateCard({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final dateText = formatVacationDateShort(context, date);
    return Semantics(
      button: true,
      label: '$label $dateText',
      child: Material(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: c.inkSoft,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.serif(fontSize: 22, color: c.ink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
