import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/care/care_task_type.dart';
import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/plant_care_schedule.dart';
import 'edit_schedule_controller.dart';
import 'edit_schedule_state.dart';
import 'recommended_intervals_provider.dart';
import 'widgets/reset_intervals_card.dart';
import 'widgets/schedule_type_card.dart';

/// Порядок типов ухода на экране (enum-порядок дизайна):
/// полив → опрыскивание → подкормка → проверка грунта.
const _kTypeOrder = [
  CareTaskType.watering,
  CareTaskType.misting,
  CareTaskType.fertilizing,
  CareTaskType.soilCheck,
];

/// Экран 22 «Редактирование расписания ухода».
///
/// Потребляет `editScheduleControllerProvider(plantId)` (драфт + dirty + saving
/// + saveError) и `recommendedIntervalsProvider(plantId)` (видимость «Сбросить»).
/// Стратегия «draft + save on Готово»: правки идут в драфт без сети, сеть — по
/// «Готово» (PUT грязных). Состояния: loading (скелетон) / error загрузки
/// (ErrorState + retry) / empty (нет расписаний) / data (карточки + reset +
/// note). Сохранение: saving блокирует контролы и крутит индикатор на «Готово»;
/// saveError → снэкбар, экран НЕ закрывается; успех (`save()==null`) → pop.
class EditScheduleScreen extends ConsumerWidget {
  const EditScheduleScreen({super.key, required this.plantId, this.plantName});

  final int plantId;

  /// Имя растения для overline шапки (может прийти из карточки 02). `null` →
  /// показываем общий overline без имени.
  final String? plantName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(editScheduleControllerProvider(plantId));
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();

    final saving = async.value?.saving ?? false;
    final isDirty = async.value?.isDirty ?? false;
    final hasData = async.hasValue;

    // Снэкбар ошибки сохранения (реагируем на смену saveError).
    ref.listen(
      editScheduleControllerProvider(plantId)
          .select((s) => s.value?.saveError),
      (prev, next) {
        if (next != null) {
          _showError(context, l10n.messageForError(next));
        }
      },
    );

    Future<void> onDone() async {
      // Нет данных или нет изменений — просто закрываем (без сети).
      final state = async.value;
      if (state == null || !state.isDirty) {
        _pop(context);
        return;
      }
      final error = await ref
          .read(editScheduleControllerProvider(plantId).notifier)
          .save();
      if (!context.mounted) return;
      if (error == null) {
        _pop(context);
      }
      // Ошибка → снэкбар покажет ref.listen, остаёмся на экране.
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _StickyHeader(
              plantName: plantName,
              saving: saving,
              // «Готово» активна, когда экран загружен (даже без изменений —
              // тогда просто pop). Заблокирована во время сохранения.
              onDone: hasData && !saving ? onDone : null,
              dirty: isDirty,
            ),
            Expanded(
              child: async.when(
                loading: () => const _LoadingBody(),
                error: (error, _) => _ErrorBody(
                  message: l10n.messageForError(error),
                  onRetry: () => ref.invalidate(
                    editScheduleControllerProvider(plantId),
                  ),
                ),
                data: (state) => state.draft.isEmpty
                    ? const _EmptyBody()
                    : _DataBody(
                        plantId: plantId,
                        state: state,
                        nowLocal: nowLocal,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  static void _pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }
}

/// Sticky-шапка: назад + overline «Расписание · {имя}» + кнопка «Готово».
class _StickyHeader extends StatelessWidget {
  const _StickyHeader({
    required this.plantName,
    required this.saving,
    required this.onDone,
    required this.dirty,
  });

  final String? plantName;
  final bool saving;
  final VoidCallback? onDone;
  final bool dirty;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final overline = (plantName != null && plantName!.trim().isNotEmpty)
        ? l10n.editScheduleOverline(plantName!.trim())
        : l10n.editScheduleTitle;

    return Container(
      color: c.bg,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          _IconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: l10n.editScheduleBack,
            onPressed: saving
                ? null
                : () => EditScheduleScreen._pop(context),
          ),
          Expanded(
            child: Text(
              overline.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: c.inkSoft,
              ),
            ),
          ),
          _DoneButton(saving: saving, dirty: dirty, onPressed: onDone),
        ],
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton({
    required this.saving,
    required this.dirty,
    required this.onPressed,
  });

  final bool saving;
  final bool dirty;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final enabled = onPressed != null;
    return Material(
      color: enabled ? c.ink : c.inkMute,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44, minWidth: 88),
          child: Center(
            child: Semantics(
              button: true,
              enabled: enabled,
              label: l10n.editScheduleDone,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: saving
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: c.surface,
                        ),
                      )
                    : Text(
                        l10n.editScheduleDone,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: c.surface,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              enabled: onPressed != null,
              label: tooltip,
              child: Icon(
                icon,
                size: 22,
                color: onPressed != null ? c.ink : c.inkMute,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Заголовок «Как часто заботиться?» + подпись.
class _IntroHeader extends StatelessWidget {
  const _IntroHeader();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.editScheduleTitle,
          style: AppTheme.serif(fontSize: 32, color: c.ink),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.editScheduleSubtitle,
          style: TextStyle(fontSize: 13, color: c.inkSoft),
        ),
      ],
    );
  }
}

/// Контент data-состояния: интро, карточки по типам, «Сбросить», заметка.
class _DataBody extends ConsumerWidget {
  const _DataBody({
    required this.plantId,
    required this.state,
    required this.nowLocal,
  });

  final int plantId;
  final EditScheduleState state;
  final DateTime nowLocal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller =
        ref.read(editScheduleControllerProvider(plantId).notifier);

    // Карточки в фиксированном порядке дизайна; типы, которых нет в драфте,
    // пропускаем (нераспознанные/неизвестные — в конце).
    final ordered = <PlantCareSchedule>[
      for (final type in _kTypeOrder) ?state.draftOf(type),
      for (final s in state.draft)
        if (!_kTypeOrder.contains(s.type)) s,
    ];

    // «Сбросить» — только если у вида есть непустые рекомендации.
    final recommended =
        ref.watch(recommendedIntervalsProvider(plantId)).value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: _IntroHeader(),
        ),
        const SizedBox(height: 16),
        for (final schedule in ordered) ...[
          ScheduleTypeCard(
            schedule: schedule,
            nowLocal: nowLocal,
            saving: state.saving,
            onToggle: (_) => controller.toggle(schedule.type),
            onEveryChanged: (v) => controller.setEvery(schedule.type, v),
            onAmountChanged: (v) => controller.setAmountMl(schedule.type, v),
          ),
          const SizedBox(height: 12),
        ],
        if (recommended != null && recommended.isNotEmpty) ...[
          const SizedBox(height: 6),
          ResetIntervalsCard(
            enabled: !state.saving,
            onTap: () => controller.reset(recommended),
          ),
        ],
        const SizedBox(height: 14),
        _NoteCard(text: l10n.editScheduleNote),
      ],
    );
  }
}

/// Декоративная заметка-цитата внизу экрана.
class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTheme.serif(fontSize: 15, color: c.ink).copyWith(
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading: скелетон из 4 карточек-костей.
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 220, height: 30, radius: 10),
              SizedBox(height: 8),
              SkeletonBox(width: 180, height: 13),
            ],
          ),
        ),
        SizedBox(height: 16),
        _CardSkeleton(),
        SizedBox(height: 12),
        _CardSkeleton(),
        SizedBox(height: 12),
        _CardSkeleton(),
        SizedBox(height: 12),
        _CardSkeleton(),
      ],
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 40, height: 40, radius: 13),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 100, height: 14),
                    SizedBox(height: 6),
                    SkeletonBox(width: 140, height: 11),
                  ],
                ),
              ),
              SizedBox(width: 8),
              SkeletonBox(width: 44, height: 26, radius: 13),
            ],
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(width: 80, height: 14),
              SkeletonBox(width: 120, height: 44, radius: 14),
            ],
          ),
        ],
      ),
    );
  }
}

/// Error загрузки: ErrorState по центру с retry.
class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: ErrorState(
          message: message,
          retryLabel: l10n.retry,
          onRetry: onRetry,
        ),
      ),
    );
  }
}

/// Empty: дружелюбная подпись, если backend не вернул ни одного расписания.
class _EmptyBody extends StatelessWidget {
  const _EmptyBody();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy_outlined, size: 36, color: c.inkMute),
            const SizedBox(height: 14),
            Text(
              l10n.editScheduleEmptyTitle,
              textAlign: TextAlign.center,
              style: AppTheme.serif(fontSize: 22, color: c.ink),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.editScheduleEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
