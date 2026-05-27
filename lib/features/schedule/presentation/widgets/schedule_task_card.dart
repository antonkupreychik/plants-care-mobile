import 'package:flutter/material.dart';

import '../../../../core/care/care_task.dart';
import '../../../../core/care/care_task_l10n.dart';
import '../../../../core/care/care_task_type.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Карточка одной задачи ухода в раскрытом (сегодняшнем) дне.
///
/// Бейдж типа окрашен по [CareTaskType] (палитра PcColors). Просроченные
/// задачи (`dueAt < now`) подсвечиваются terracotta и получают подпись
/// «Просрочено» (её отдаёт `dueLabel`, тут только цвет). Признака «выполнено»
/// нет: `/calendar` не возвращает статус выполнения (BACKEND-GAP), поэтому
/// прогресс/«готово» не рисуем.
class ScheduleTaskCard extends StatelessWidget {
  const ScheduleTaskCard({
    super.key,
    required this.task,
    required this.now,
  });

  final CareTask task;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final overdue = task.dueAt.toLocal().isBefore(now);
    final tint = _tintFor(task.type, c);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: overdue ? c.terracotta : c.line),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(task.type.icon, size: 14, color: c.surface),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.plantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  task.dueLabel(l10n, now),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: overdue ? c.terracotta : c.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Тинт бейджа по типу ухода (палитра PcColors).
  static Color _tintFor(CareTaskType type, PcColors c) => switch (type) {
        CareTaskType.watering => c.primary,
        CareTaskType.misting => c.terracotta,
        CareTaskType.fertilizing => c.leafDark,
        CareTaskType.soilCheck => c.leaf,
        CareTaskType.unknown => c.inkSoft,
      };
}
