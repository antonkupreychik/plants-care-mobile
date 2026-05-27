import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/schedule_week.dart';
import 'schedule_providers.dart';
import 'schedule_week_start_provider.dart';
import 'widgets/schedule_day_row.dart';
import 'widgets/schedule_header.dart';
import 'widgets/schedule_ics_card.dart';
import 'widgets/schedule_week_skeleton.dart';

/// Экран 11 «График» — недельный календарь ухода.
///
/// Потребляет [scheduleWeekStartProvider] (понедельник выбранной недели) и
/// [scheduleWeekProvider] (family по weekStart → `AsyncValue<ScheduleWeek>`).
/// Хедер недели и листание доступны во всех состояниях (зависят только от
/// weekStart), тело рисует loading/error/empty/data.
///
/// BACKEND-GAP: `/calendar` отдаёт только запланированные задачи без статуса
/// выполнения → счётчик дня показывает число задач, а не прогресс «done/count»;
/// «Готово» не показываем. Блок .ics инертен (эндпоинта `/calendar.ics` нет).
class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final weekStart = ref.watch(scheduleWeekStartProvider);
    final weekAsync = ref.watch(scheduleWeekProvider(weekStart));
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();
    final weekNotifier = ref.read(scheduleWeekStartProvider.notifier);

    void comingSoon() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverToBoxAdapter(
                child: ScheduleHeader(
                  weekStart: weekStart,
                  onPreviousWeek: weekNotifier.previousWeek,
                  onNextWeek: weekNotifier.nextWeek,
                  onCurrentWeek: weekNotifier.resetToCurrentWeek,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              sliver: SliverToBoxAdapter(
                child: weekAsync.when(
                  loading: () => const ScheduleWeekSkeleton(),
                  error: (error, _) => ErrorState(
                    message: l10n.messageForError(error),
                    retryLabel: l10n.retry,
                    onRetry: () =>
                        ref.invalidate(scheduleWeekProvider(weekStart)),
                  ),
                  data: (week) => _WeekBody(
                    week: week,
                    now: nowLocal,
                    onIcsTap: comingSoon,
                  ),
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

/// Тело недели (data): hero-заголовок + 7 строк дней + блок .ics.
///
/// Признаки «сегодня»/«прошлый день» и сумма задач за неделю — presentation-
/// вывод из [ScheduleWeek] и [now] (clock), не domain-логика.
class _WeekBody extends StatelessWidget {
  const _WeekBody({
    required this.week,
    required this.now,
    required this.onIcsTap,
  });

  final ScheduleWeek week;
  final DateTime now;
  final VoidCallback onIcsTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final days = week.days;
    final totalTasks = days.fold<int>(0, (sum, d) => sum + d.tasks.length);
    final today = DateTime(now.year, now.month, now.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.scheduleWeekTasksCount(totalTasks),
          style: AppTheme.serif(fontSize: 32, color: c.ink),
        ),
        const SizedBox(height: 16),
        ...List.generate(days.length, (i) {
          final day = days[i];
          final date = DateTime(day.date.year, day.date.month, day.date.day);
          final isToday = date == today;
          final isPast = date.isBefore(today);
          // Разделитель только между обычными днями (не у последнего, не у today
          // и не перед today, чтобы карточка today «дышала»).
          final showDivider = !isToday &&
              i < days.length - 1 &&
              !_isToday(days[i + 1].date, today);
          return ScheduleDayRow(
            key: ValueKey(date),
            day: day,
            now: now,
            isToday: isToday,
            isPast: isPast,
            showDivider: showDivider,
          );
        }),
        const SizedBox(height: 18),
        ScheduleIcsCard(onComingSoon: onIcsTap),
      ],
    );
  }

  static bool _isToday(DateTime date, DateTime today) =>
      DateTime(date.year, date.month, date.day) == today;
}
