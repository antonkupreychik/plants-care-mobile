import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/schedule_day.dart';
import 'schedule_task_card.dart';

/// Строка одного дня недели в графике.
///
/// Сегодняшний день ([isToday]) выделен карточкой (border 2px primary, фон
/// surface, radius 24) и раскрыт со списком задач. Прошлые дни ([isPast])
/// приглушены. Счётчик задач — без прогресса «done/count»: backend не отдаёт
/// статус выполнения (BACKEND-GAP), поэтому показываем только число задач или
/// «Свободно».
class ScheduleDayRow extends StatelessWidget {
  const ScheduleDayRow({
    super.key,
    required this.day,
    required this.now,
    required this.isToday,
    required this.isPast,
    required this.showDivider,
  });

  final ScheduleDay day;
  final DateTime now;
  final bool isToday;
  final bool isPast;

  /// Тонкий разделитель снизу (для обычных, не сегодняшних дней).
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final weekdayLabel =
        DateFormat.E(l10n.localeName).format(day.date).toUpperCase();
    final dayNumber = DateFormat.d(l10n.localeName).format(day.date);
    final tasks = day.tasks;

    final row = Container(
      decoration: isToday
          ? BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: c.primary, width: 2),
            )
          : null,
      padding: isToday
          ? const EdgeInsets.all(14)
          : const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 44,
                child: Column(
                  children: [
                    Text(
                      weekdayLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: isToday ? c.primary : c.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dayNumber,
                      style: AppTheme.serif(
                        fontSize: isToday ? 30 : 24,
                        color: isToday ? c.primary : c.ink,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l10n.scheduleDayTasksCount(tasks.length),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: tasks.isEmpty ? c.inkSoft : c.ink,
                  ),
                ),
              ),
            ],
          ),
          if (isToday && tasks.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...List.generate(tasks.length, (i) {
              return Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 6),
                child: ScheduleTaskCard(task: tasks[i], now: now),
              );
            }),
          ],
        ],
      ),
    );

    final content = isPast ? Opacity(opacity: 0.55, child: row) : row;

    if (isToday) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: content,
      );
    }
    return Container(
      decoration: showDivider
          ? BoxDecoration(
              border: Border(bottom: BorderSide(color: c.line)),
            )
          : null,
      child: content,
    );
  }
}
