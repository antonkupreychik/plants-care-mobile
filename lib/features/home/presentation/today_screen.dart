import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../care_event/data/mappers/task_type_mapper.dart';
import '../../care_event/presentation/log_care_event_sheet.dart';
import 'home_providers.dart';
import 'today_filter.dart';
import 'today_providers.dart';
import 'today_view.dart';
import 'widgets/today_filter_pills.dart';
import 'widgets/today_task_card.dart';

/// Экран 03 «Сегодня» — полный список задач ухода (`GET /today`).
///
/// Производный от Home: state собирает [todayViewProvider] поверх
/// `homeTasksProvider` (тот же источник). Sheet 06 инвалидирует
/// `homeTasksProvider` → список здесь обновляется сам.
///
/// TODO(nav): позже Today переедет под таб «Расписание» (StatefulShellRoute) —
/// сейчас это push-маршрут `/home/today`, реструктуризацию табов не делаем.
///
/// Скрыто (BACKEND-GAPS, см. задача 03): прогресс-кольцо «X из N выполнено» и
/// секция «N выполнено сегодня» — фида done нет; voice line (G2); вид/species
/// растения (G6) — нет данных.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();

    final async = ref.watch(todayViewProvider);

    void openSheet(TodayTaskItem item) {
      showLogCareEventSheet(
        context,
        plantId: item.task.plantId,
        presetType: careEventKindFromTaskType(item.task.type),
        plantName: item.task.plantName,
      );
    }

    void selectFilter(TodayFilter filter) =>
        ref.read(selectedTodayFilterProvider.notifier).select(filter);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: async.when(
          loading: () => const _TodayLoading(),
          error: (error, _) => _TodayError(
            message: l10n.messageForError(error),
            onRetry: () => ref.invalidate(homeTasksProvider),
          ),
          data: (view) => _TodayContent(
            view: view,
            now: nowLocal,
            onSelectFilter: selectFilter,
            onTaskTap: openSheet,
          ),
        ),
      ),
    );
  }
}

/// Шапка экрана: кнопка «назад», дата, крупный serif-заголовок с числом задач.
class _TodayHeader extends StatelessWidget {
  const _TodayHeader({required this.now, required this.totalCount});

  final DateTime now;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final dateLabel = DateFormat.MMMMEEEEd(l10n.localeName).format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackButton(label: l10n.todayBack),
        const SizedBox(height: 14),
        Text(
          dateLabel.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.todayHeroCount(totalCount),
          style: AppTheme.serif(fontSize: 40, color: c.ink),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          // Стек пуст (deep link / прямой заход) — уходим на /home.
          onTap: () => context.canPop() ? context.pop() : context.go('/home'),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
          ),
        ),
      ),
    );
  }
}

/// Компактная summary-строка: всего задач · сколько просрочено.
class _TodaySummary extends StatelessWidget {
  const _TodaySummary({required this.view});

  final TodayView view;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Icon(
            view.overdueCount > 0
                ? Icons.warning_amber_rounded
                : Icons.spa_outlined,
            size: 20,
            color: view.overdueCount > 0 ? c.terracotta : c.leaf,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${l10n.todaySummary(view.totalCount)} · '
              '${l10n.todaySummaryOverdue(view.overdueCount)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Контент data-состояния: шапка + summary + пилюли + секции (или empty).
class _TodayContent extends StatelessWidget {
  const _TodayContent({
    required this.view,
    required this.now,
    required this.onSelectFilter,
    required this.onTaskTap,
  });

  final TodayView view;
  final DateTime now;
  final ValueChanged<TodayFilter> onSelectFilter;
  final void Function(TodayTaskItem item) onTaskTap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
          sliver: SliverToBoxAdapter(
            child: _TodayHeader(now: now, totalCount: view.totalCount),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
          sliver: SliverToBoxAdapter(child: _TodaySummary(view: view)),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 14, bottom: 4),
          sliver: SliverToBoxAdapter(
            child: TodayFilterPills(view: view, onSelected: onSelectFilter),
          ),
        ),
        if (view.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
            sliver: SliverToBoxAdapter(
              child: _TodayEmpty(filter: view.filter),
            ),
          )
        else
          ..._sections(),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  List<Widget> _sections() {
    return [
      for (final group in view.groups)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: _TodaySection(
            group: group,
            now: now,
            onTaskTap: onTaskTap,
          ),
        ),
    ];
  }
}

/// Секция фазы: serif-заголовок «Утром»/«Вечером» + счётчик, под ним карточки.
class _TodaySection extends StatelessWidget {
  const _TodaySection({
    required this.group,
    required this.now,
    required this.onTaskTap,
  });

  final TodayGroup group;
  final DateTime now;
  final void Function(TodayTaskItem item) onTaskTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final phaseLabel = switch (group.phase) {
      TodayPhase.morning => l10n.todayPhaseMorning,
      TodayPhase.evening => l10n.todayPhaseEvening,
    };

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  phaseLabel,
                  style: AppTheme.serif(fontSize: 20, color: c.ink),
                ),
                const Spacer(),
                Text(
                  l10n.todaySectionCount(group.items.length).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: c.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList.separated(
          itemCount: group.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final item = group.items[i];
            return TodayTaskCard(
              item: item,
              now: now,
              onTap: () => onTaskTap(item),
            );
          },
        ),
      ],
    );
  }
}

/// Пустое состояние: текст зависит от того, активен ли фильтр.
class _TodayEmpty extends StatelessWidget {
  const _TodayEmpty({required this.filter});

  final TodayFilter filter;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final isAll = filter == TodayFilter.all;
    final title = isAll ? l10n.todayEmptyAll : l10n.todayEmptyFilter;
    final hint = isAll ? l10n.todayEmptyAllHint : l10n.todayEmptyFilterHint;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Icon(Icons.spa_outlined, size: 36, color: c.leaf),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.ink),
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
          ),
        ],
      ),
    );
  }
}

/// Loading: заглушка шапки + несколько skeleton-карточек.
class _TodayLoading extends StatelessWidget {
  const _TodayLoading();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(22, 12, 22, 0),
          sliver: SliverToBoxAdapter(child: _TodayHeaderSkeleton()),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                TodayTaskCardSkeleton(),
                SizedBox(height: 8),
                TodayTaskCardSkeleton(),
                SizedBox(height: 8),
                TodayTaskCardSkeleton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TodayHeaderSkeleton extends StatelessWidget {
  const _TodayHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackButton(label: AppLocalizations.of(context).todayBack),
        const SizedBox(height: 18),
        Container(
          width: 220,
          height: 36,
          decoration: BoxDecoration(
            color: c.surfaceWarm,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

/// Error: кнопка «назад» + блок ошибки с retry (стек может быть пуст).
class _TodayError extends StatelessWidget {
  const _TodayError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BackButton(label: l10n.todayBack),
          const SizedBox(height: 24),
          ErrorState(
            message: message,
            retryLabel: l10n.retry,
            onRetry: onRetry,
          ),
        ],
      ),
    );
  }
}
