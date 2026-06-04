import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/schedule_day.dart';

/// Горизонтальный день-селектор экрана 11 «График» (agenda).
///
/// Ряд из 7 ячеек Пн→Вс (скролл по X). Каждая ячейка: день недели + число +
/// «точки нагрузки» (`min(taskCount, 3)`, 0 → символ «—»). Выбранный день
/// залит [PcColors.primary] (текст белый), остальные — surface с рамкой line.
///
/// Зависит только от [days] (нагрузка) и [selected]; тап отдаёт дату в
/// [onSelect]. Без состояния — данные приходят от провайдеров (MADR-002).
class ScheduleDaySelector extends StatelessWidget {
  const ScheduleDaySelector({
    super.key,
    required this.days,
    required this.selected,
    required this.onSelect,
  });

  final List<ScheduleDay> days;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final selectedDate = DateTime(selected.year, selected.month, selected.day);

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (context, i) {
          final day = days[i];
          final date = DateTime(day.date.year, day.date.month, day.date.day);
          return _DayCell(
            date: date,
            taskCount: day.tasks.length,
            isSelected: date == selectedDate,
            onTap: () => onSelect(date),
          );
        },
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.taskCount,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final int taskCount;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final weekday = DateFormat.E(l10n.localeName).format(date).toUpperCase();
    final dayNumber = DateFormat.d(l10n.localeName).format(date);

    final bg = isSelected ? c.primary : c.surface;
    final border = isSelected ? c.primary : c.line;
    final weekdayColor =
        isSelected ? Colors.white.withValues(alpha: 0.8) : c.inkSoft;
    final numberColor = isSelected ? Colors.white : c.ink;

    return Semantics(
      button: true,
      selected: isSelected,
      label: DateFormat.MMMMEEEEd(l10n.localeName).format(date),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weekday,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: weekdayColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dayNumber,
                  style: AppTheme.serif(fontSize: 22, color: numberColor),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 6,
                  child: _LoadDots(count: taskCount, isSelected: isSelected),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Точки нагрузки: `min(count, 3)` точек 5×5; 0 → символ «—».
class _LoadDots extends StatelessWidget {
  const _LoadDots({required this.count, required this.isSelected});

  final int count;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    if (count == 0) {
      return Text(
        l10n.scheduleDayLoadHint,
        style: TextStyle(
          fontSize: 9,
          height: 1,
          color: isSelected ? Colors.white.withValues(alpha: 0.7) : c.inkMute,
        ),
      );
    }

    final dots = count > 3 ? 3 : count;
    final color = isSelected ? Colors.white.withValues(alpha: 0.85) : c.leaf;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dots, (i) {
        return Container(
          margin: EdgeInsets.only(left: i == 0 ? 0 : 2),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
