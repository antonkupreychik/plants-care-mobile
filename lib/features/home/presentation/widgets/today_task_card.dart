import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/care/care_task_l10n.dart';
import '../today_view.dart';

/// Карточка задачи на экране 03 «Сегодня».
///
/// Близка по стилю к строке `TodayCard` (Home), но это самостоятельная
/// карточка-плитка с рамкой: глиф растения (нейтральный — вид неизвестен, G6),
/// имя, бейдж «просрочено», срок ([CareTask.dueLabel]) и action-pill с типом
/// ухода. Тап по карточке или по pill открывает sheet 06 (колбэк [onTap]).
class TodayTaskCard extends StatelessWidget {
  const TodayTaskCard({super.key, required this.item, required this.now, required this.onTap});

  final TodayTaskItem item;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final task = item.task;

    return Semantics(
      button: true,
      label: '${task.plantName}, ${task.type.label(l10n)}',
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: item.overdue ? c.terracotta : c.line,
                width: item.overdue ? 1.5 : 1,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: c.surfaceWarm,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  // Вид растения в /today неизвестен (TaskDto без speciesId —
                  // BACKEND-GAPS G6): нейтральный глиф, а не подбор иллюстрации.
                  child: Icon(Icons.local_florist_outlined, size: 26, color: c.leaf),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              task.plantName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: c.ink,
                              ),
                            ),
                          ),
                          if (item.overdue) ...[
                            const SizedBox(width: 8),
                            _OverdueBadge(label: l10n.todayOverdueBadge),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        task.dueLabel(l10n, now),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: c.inkSoft),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _ActionPill(icon: task.type.icon, label: task.type.label(l10n)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverdueBadge extends StatelessWidget {
  const _OverdueBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c.terracotta.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: c.terracotta,
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: c.ink,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c.surface),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.surface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton-плитка задачи (loading-состояние экрана 03).
class TodayTaskCardSkeleton extends StatelessWidget {
  const TodayTaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.all(14),
      child: const Row(
        children: [
          SkeletonBox(width: 52, height: 52, radius: 18),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 110, height: 14),
                SizedBox(height: 6),
                SkeletonBox(width: 70, height: 11),
              ],
            ),
          ),
          SizedBox(width: 10),
          SkeletonBox(width: 92, height: 32, radius: 999),
        ],
      ),
    );
  }
}
