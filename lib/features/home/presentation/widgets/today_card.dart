import 'package:flutter/material.dart';

import '../../../../core/care/care_task.dart';
import '../../../../core/care/care_task_l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../l10n/app_localizations.dart';
import '../plant_illustration.dart';

/// Карточка «Сегодня»: компактный список задач ухода ([CareTask]).
///
/// Без группировки «утро/вечер» (это экран 03) и без вычислений интервалов —
/// только счётчик и список. Срок берётся из уже посчитанного backend `dueAt`.
class TodayCard extends StatelessWidget {
  const TodayCard({
    super.key,
    required this.tasks,
    required this.now,
    required this.onTaskTap,
    this.onSeeAll,
  });

  final List<CareTask> tasks;
  final DateTime now;

  /// Тап по задаче → sheet ухода (фича 06).
  final void Function(CareTask task) onTaskTap;

  /// Тап по заголовку секции → открыть полный экран 03 «Сегодня».
  /// Опциональный (не ломает существующие вызовы/тесты): если `null`,
  /// заголовок неинтерактивен.
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHead(
            overline: l10n.homeTodayTitle,
            title: l10n.homeTodayTasksCount(tasks.length),
            onSeeAll: onSeeAll,
            seeAllLabel: l10n.homeTodaySeeAll,
          ),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 6),
              child: Text(
                l10n.homeTasksEmptyHint,
                style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
              ),
            )
          else
            ...List.generate(tasks.length, (i) {
              final task = tasks[i];
              return _TaskRow(
                task: task,
                now: now,
                showDivider: i > 0,
                onTap: () => onTaskTap(task),
              );
            }),
        ],
      ),
    );
  }
}

/// Skeleton-вариант карточки «Сегодня» (loading-состояние секции).
class TodayCardSkeleton extends StatelessWidget {
  const TodayCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 80, height: 12),
          SizedBox(height: 8),
          SkeletonBox(width: 120, height: 22),
          SizedBox(height: 18),
          _TaskRowSkeleton(),
          SizedBox(height: 14),
          _TaskRowSkeleton(),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: c.line),
      ),
      child: child,
    );
  }
}

class _SectionHead extends StatelessWidget {
  const _SectionHead({
    required this.overline,
    required this.title,
    this.onSeeAll,
    this.seeAllLabel,
  });

  final String overline;
  final String title;
  final VoidCallback? onSeeAll;
  final String? seeAllLabel;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          overline.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 2),
        Text(title, style: AppTheme.serif(fontSize: 24, color: c.ink)),
      ],
    );

    if (onSeeAll == null) return content;

    // Ненавязчивый аффорданс «посмотреть все»: тап по заголовку ведёт на
    // экран 03. Стрелка-шеврон даёт визуальный намёк на переход.
    return Semantics(
      button: true,
      label: seeAllLabel,
      child: InkWell(
        onTap: onSeeAll,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: content),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Icon(Icons.chevron_right_rounded, size: 22, color: c.inkSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.now,
    required this.showDivider,
    required this.onTap,
  });

  final CareTask task;
  final DateTime now;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        if (showDivider) Divider(height: 1, color: c.line),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: c.surfaceWarm,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  // Иллюстрация по виду задачи (BACKEND-GAPS G6 закрыт:
                  // TaskDto отдаёт speciesName). PlantArt.fromSpecies сам
                  // падает в дефолт (monstera) при null/нераспознанном виде.
                  child: PlantIllustration(
                    speciesName: task.speciesName,
                    size: 36,
                  ),
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
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        task.dueLabel(l10n, now),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: c.inkSoft),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _ActionPill(
                  icon: task.type.icon,
                  label: task.type.label(l10n),
                ),
              ],
            ),
          ),
        ),
      ],
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

class _TaskRowSkeleton extends StatelessWidget {
  const _TaskRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SkeletonBox(width: 48, height: 48, radius: 16),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 100, height: 14),
              SizedBox(height: 6),
              SkeletonBox(width: 64, height: 11),
            ],
          ),
        ),
        SizedBox(width: 8),
        SkeletonBox(width: 84, height: 32, radius: 999),
      ],
    );
  }
}
