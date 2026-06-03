import 'package:flutter/material.dart';

import '../../../../core/care/care_task_l10n.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/plant_illustration.dart';
import '../schedule_day_view.dart';
import 'care_action_tint.dart';

/// Строка задачи в agenda-списке экрана 11 «График».
///
/// Аватар вида (44×44, surfaceWarm) + имя растения + подпись + кнопка-чек.
/// Состояния: обычная, overdue (рамка terracotta, подпись «Просрочено · со
/// вчера»), done (opacity 0.5, имя зачёркнуто, кнопка-чек → галка).
///
/// Тап по кнопке-чеку отдаёт колбэк [onMark] (оптимистичный POST). Для done
/// колбэк не вызывается (кнопка инертна). Тип `SOIL_CHECK`/`unknown` отметить
/// нельзя — [canMark] false, кнопка приглушена.
class ScheduleAgendaRow extends StatelessWidget {
  const ScheduleAgendaRow({
    super.key,
    required this.item,
    required this.pending,
    required this.onMark,
  });

  final ScheduleTaskItem item;

  /// Отметка в полёте (POST идёт) — кнопка показывает прогресс.
  final bool pending;

  final VoidCallback onMark;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final task = item.task;

    final borderColor = item.overdue ? c.terracotta : c.line;

    final subtitle = item.overdue
        ? l10n.scheduleOverdueSubtitle
        : l10n.scheduleTaskSubtitle(
            task.type.label(l10n),
            task.speciesName ?? task.plantName,
          );
    final subtitleColor = item.overdue ? c.terracotta : c.inkSoft;

    final row = Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: item.overdue ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.surfaceWarm,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: PlantIllustration(speciesName: task.speciesName, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.plantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.ink,
                    decoration:
                        item.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _CheckButton(item: item, pending: pending, onTap: onMark),
        ],
      ),
    );

    return item.done ? Opacity(opacity: 0.5, child: row) : row;
  }
}

/// Кнопка-чек 34×34 справа в строке: тинт по действию (не выполнено) или
/// галка/прогресс (выполнено / в полёте).
class _CheckButton extends StatelessWidget {
  const _CheckButton({
    required this.item,
    required this.pending,
    required this.onTap,
  });

  final ScheduleTaskItem item;
  final bool pending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    if (item.done) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.line, width: 2),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.check_rounded, size: 18, color: c.inkMute),
      );
    }

    if (pending) {
      return SizedBox(
        width: 34,
        height: 34,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: c.primary),
          ),
        ),
      );
    }

    return Semantics(
      button: true,
      label: l10n.scheduleMarkDone,
      child: Material(
        color: item.task.type.tint(c),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 34,
            height: 34,
            child: Icon(Icons.check_rounded, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
