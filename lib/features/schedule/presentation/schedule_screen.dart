import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/schedule_week.dart';
import 'schedule_agenda_providers.dart';
import 'schedule_day_view.dart';
import 'schedule_mark_controller.dart';
import 'schedule_providers.dart';
import 'schedule_week_start_provider.dart';
import 'selected_schedule_day_provider.dart';
import 'widgets/schedule_agenda_row.dart';
import 'widgets/schedule_day_selector.dart';
import 'widgets/schedule_week_skeleton.dart';

/// Экран 11 «График» — agenda-паттерн (день-селектор + список задач дня).
///
/// Сверху вниз: header (месяц uppercase + «График ухода» serif + кнопка
/// «сегодня»), горизонтальный день-селектор с точками нагрузки, подзаголовок
/// выбранного дня «X из N готово», секции Утро/Вечер/Сделано (или заглушка
/// пустого дня).
///
/// Состояния: header + селектор доступны во всех (зависят от недели), тело
/// рисует loading/error/empty/data. Отметка ухода — оптимистичный
/// `POST /care-events` ([ScheduleMarkController]): строка сразу уходит в
/// «Сделано», на ошибку — откат + баннер.
///
/// Группировка «утро/вечер» и подпись «вид» формируются клиентом — серверного
/// аналога нет (см. `screen-11-redesign.md` §6/§7).
class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final weekStart = ref.watch(scheduleWeekStartProvider);
    final weekAsync = ref.watch(scheduleWeekProvider(weekStart));
    final selectedDay = ref.watch(selectedScheduleDayProvider);

    // Ошибку оптимистичной отметки показываем баннером (snackbar) и гасим.
    ref.listen(
      scheduleMarkControllerProvider,
      (_, next) {
        final error = next.lastError;
        if (error == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.scheduleMarkError)));
        ref.read(scheduleMarkControllerProvider.notifier).clearError();
      },
    );

    void selectDay(DateTime day) =>
        ref.read(selectedScheduleDayProvider.notifier).select(day);

    void onMark(ScheduleTaskItem item) =>
        ref.read(scheduleMarkControllerProvider.notifier).mark(item.task);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _ScheduleHeaderBar(
                month: weekStart,
                onToday: () => ref
                    .read(scheduleWeekStartProvider.notifier)
                    .resetToCurrentWeek(),
              ),
            ),
            // День-селектор + тело зависят от загруженной недели.
            SliverToBoxAdapter(
              child: weekAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: ScheduleWeekSkeleton(),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: ErrorState(
                    message: l10n.messageForError(error),
                    retryLabel: l10n.retry,
                    onRetry: () =>
                        ref.invalidate(scheduleWeekProvider(weekStart)),
                  ),
                ),
                data: (week) => _ScheduleBody(
                  week: week,
                  selectedDay: selectedDay,
                  onSelectDay: selectDay,
                  onMark: onMark,
                ),
              ),
            ),
            // Запас под плавающую навигацию (overlay AppShell).
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

/// Header экрана: надзаголовок «МАЙ 2026» + serif-заголовок + кнопка «сегодня».
class _ScheduleHeaderBar extends StatelessWidget {
  const _ScheduleHeaderBar({required this.month, required this.onToday});

  final DateTime month;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final monthLabel =
        DateFormat.yMMMM(l10n.localeName).format(month).toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monthLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.66,
                    color: c.inkSoft,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.scheduleTitle,
                  style: AppTheme.serif(fontSize: 30, color: c.ink),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: l10n.scheduleToCurrentWeek,
            child: Tooltip(
              message: l10n.scheduleToCurrentWeek,
              child: Material(
                color: c.surface,
                borderRadius: BorderRadius.circular(14),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onToday,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: c.line),
                    ),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: c.ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Тело data-состояния: герой-счётчик задач + subtitle свободных дней +
/// день-селектор + подзаголовок дня + секции/заглушка.
class _ScheduleBody extends ConsumerWidget {
  const _ScheduleBody({
    required this.week,
    required this.selectedDay,
    required this.onSelectDay,
    required this.onMark,
  });

  final ScheduleWeek week;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onSelectDay;
  final void Function(ScheduleTaskItem item) onMark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayAsync = ref.watch(scheduleDayViewProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WeekHero(week: week),
        const SizedBox(height: 14),
        ScheduleDaySelector(
          days: week.days,
          selected: selectedDay,
          onSelect: onSelectDay,
        ),
        const SizedBox(height: 6),
        dayAsync.when(
          loading: () => const SizedBox(height: 120),
          error: (_, _) => const SizedBox.shrink(),
          data: (view) => _DayAgenda(
            day: selectedDay,
            view: view,
            onMark: onMark,
          ),
        ),
      ],
    );
  }
}

/// Hero-блок над день-селектором: число задач с цветовым акцентом +
/// subtitle со списком свободных дней (если есть).
class _WeekHero extends StatelessWidget {
  const _WeekHero({required this.week});

  final ScheduleWeek week;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final totalTasks = week.days.fold(0, (sum, d) => sum + d.tasks.length);

    final Widget heroText;
    if (totalTasks == 0) {
      heroText = Text(
        l10n.scheduleWeekRestTitle,
        style: AppTheme.serif(fontSize: 32, color: c.ink),
      );
    } else {
      heroText = Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: l10n.scheduleWeekTasksPrefix,
              style: AppTheme.serif(fontSize: 32, color: c.ink),
            ),
            TextSpan(
              text: '$totalTasks',
              style: AppTheme.serif(
                fontSize: 32,
                color: c.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
            TextSpan(
              text: l10n.scheduleWeekTasksSuffix(totalTasks),
              style: AppTheme.serif(fontSize: 32, color: c.ink),
            ),
          ],
        ),
      );
    }

    final freeDays = week.days
        .where((d) => d.tasks.isEmpty)
        .map((d) => DateFormat.E(l10n.localeName).format(d.date))
        .toList();

    final String? subtitleText =
        freeDays.isNotEmpty ? l10n.scheduleFreeDaysSubtitle(freeDays.join(', ')) : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 2, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heroText,
          if (subtitleText != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitleText,
              style: TextStyle(fontSize: 13, color: c.inkSoft),
            ),
          ],
        ],
      ),
    );
  }
}

/// Подзаголовок дня + секции задач (или заглушка пустого дня).
class _DayAgenda extends ConsumerWidget {
  const _DayAgenda({
    required this.day,
    required this.view,
    required this.onMark,
  });

  final DateTime day;
  final ScheduleDayView view;
  final void Function(ScheduleTaskItem item) onMark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final dateLabel = DateFormat.MMMMEEEEd(l10n.localeName).format(day);
    final pendingKeys =
        ref.watch(scheduleMarkControllerProvider).pendingKeys;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  _capitalize(dateLabel),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.ink,
                  ),
                ),
              ),
              if (!view.isEmpty) ...[
                const SizedBox(width: 12),
                Text(
                  l10n.scheduleDayProgress(view.doneCount, view.totalCount),
                  style: TextStyle(fontSize: 13, color: c.inkSoft),
                ),
              ],
            ],
          ),
        ),
        if (view.isEmpty)
          const _DayEmpty()
        else
          for (final group in view.groups)
            _AgendaSection(
              group: group,
              pendingKeys: pendingKeys,
              onMark: onMark,
            ),
      ],
    );
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

/// Секция (Утро/Вечер/Сделано): заголовок-лейбл + время + линия, под ним строки.
class _AgendaSection extends StatelessWidget {
  const _AgendaSection({
    required this.group,
    required this.pendingKeys,
    required this.onMark,
  });

  final ScheduleAgendaGroup group;
  final Set<ScheduleTaskKey> pendingKeys;
  final void Function(ScheduleTaskItem item) onMark;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final (label, time) = switch (group.phase) {
      ScheduleAgendaPhase.morning => (
          l10n.schedulePhaseMorning,
          l10n.schedulePhaseMorningTime,
        ),
      ScheduleAgendaPhase.evening => (
          l10n.schedulePhaseEvening,
          l10n.schedulePhaseEveningTime,
        ),
      ScheduleAgendaPhase.done => (l10n.schedulePhaseDone, null),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.66,
                    color: c.inkSoft,
                  ),
                ),
                if (time != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: c.inkMute),
                  ),
                ],
                const SizedBox(width: 8),
                Expanded(child: Container(height: 1, color: c.line)),
              ],
            ),
          ),
          for (var i = 0; i < group.items.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
              child: ScheduleAgendaRow(
                item: group.items[i],
                pending: pendingKeys
                    .contains(scheduleTaskKeyOf(group.items[i].task)),
                onMark: () => onMark(group.items[i]),
              ),
            ),
        ],
      ),
    );
  }
}

/// Заглушка дня без задач.
class _DayEmpty extends StatelessWidget {
  const _DayEmpty();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.line),
        ),
        child: Text(
          l10n.scheduleDayFree,
          textAlign: TextAlign.center,
          style: AppTheme.serif(
            fontSize: 15,
            fontStyle: FontStyle.italic,
            color: c.inkSoft,
          ),
        ),
      ),
    );
  }
}
