import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../care_event/presentation/log_care_event_sheet.dart';
import '../../home/domain/plant.dart';
import '../domain/care_event_kind.dart';
import '../domain/care_history_entry.dart';
import '../domain/streak.dart';
import 'plant_card_providers.dart';
import 'widgets/plant_hero.dart';
import 'widgets/plant_journal_card.dart';
import 'widgets/plant_notes_card.dart';
import 'widgets/plant_streak_card.dart';
import 'widgets/section_title.dart';

/// Экран 02 «Карточка растения».
///
/// Потребляет три независимых family-провайдера по [plantId]
/// ([plantDetailProvider], [plantStreakProvider], [plantHistoryProvider]) —
/// каждая секция рисует loading/error/empty/data самостоятельно (как в home).
///
/// Бейдж здоровья (G1) показываем в шапке через `HealthBadge` (см. [PlantHero]);
/// кольцо здоровья — на карточках Home (01). Скрыто как заглушки каркаса
/// (BACKEND-GAPS): реплика-настроение voiceLine (G2) — не показываем (генерится
/// не из данных, экран 01 её тоже не показывает). «Отметить уход» — sheet
/// фичи 06.
class PlantCardScreen extends ConsumerStatefulWidget {
  const PlantCardScreen({super.key, required this.plantId});

  final int plantId;

  @override
  ConsumerState<PlantCardScreen> createState() => _PlantCardScreenState();
}

class _PlantCardScreenState extends ConsumerState<PlantCardScreen> {
  @override
  void initState() {
    super.initState();
    // Слушаем archivePlantProvider, чтобы после успешной архивации вернуться
    // на Home. listen вызывается при каждом изменении state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(
        archivePlantProvider(widget.plantId),
        (prev, next) {
          if (!mounted) return;
          if (next is AsyncData<void> && prev?.isLoading == true) {
            final l10n = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.archivePlantSuccess)),
            );
            context.go('/home');
          }
          if (next is AsyncError) {
            final l10n = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.messageForError(next.error)),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();

    final detail = ref.watch(plantDetailProvider(widget.plantId));
    final streak = ref.watch(plantStreakProvider(widget.plantId));
    final history = ref.watch(plantHistoryProvider(widget.plantId));
    final archiveState = ref.watch(archivePlantProvider(widget.plantId));

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                  sliver: SliverToBoxAdapter(
                    child: _TopBar(
                      isArchiving: archiveState.isLoading,
                      onEdit: () => context.pushNamed(
                        'editPlant',
                        pathParameters: {'id': '${widget.plantId}'},
                      ),
                      onArchive: () => _confirmArchive(context, l10n),
                    ),
                  ),
                ),

                // ДЕТАЛЬ — hero (skeleton / ошибка / данные).
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
                  sliver: SliverToBoxAdapter(
                    child: _DetailSection(
                      detail: detail,
                      now: nowLocal,
                      onRetry: () =>
                          ref.invalidate(plantDetailProvider(widget.plantId)),
                    ),
                  ),
                ),

                // ЗАМЕТКИ — только если деталь загружена и заметка есть.
                if (detail.value?.notes != null &&
                    detail.value!.notes!.trim().isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                    sliver: SliverToBoxAdapter(
                      child: PlantNotesCard(notes: detail.value!.notes!.trim()),
                    ),
                  ),

                // СТРИК — секция (skeleton / ошибка / empty / данные).
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                  sliver: SliverToBoxAdapter(
                    child: _StreakSection(
                      streak: streak,
                      onRetry: () =>
                          ref.invalidate(plantStreakProvider(widget.plantId)),
                    ),
                  ),
                ),

                // РАСПИСАНИЕ — заголовок секции + ссылка-вход в редактирование
                // расписания ухода (экран 22). Имя растения (если деталь
                // загружена) пробрасываем для overline шапки через extra.
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                  sliver: SliverToBoxAdapter(
                    child: SectionTitle(
                      title: l10n.plantCardScheduleTitle,
                      trailing: _ViewAllHistoryLink(
                        label: l10n.plantCardScheduleEdit,
                        onTap: () => context.pushNamed(
                          'editSchedule',
                          pathParameters: {'id': '${widget.plantId}'},
                          extra: detail.value?.name,
                        ),
                      ),
                    ),
                  ),
                ),

                // ДНЕВНИК — заголовок секции + ссылка на полную историю (21).
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                  sliver: SliverToBoxAdapter(
                    child: SectionTitle(
                      title: l10n.plantCardJournalTitle,
                      trailing: _ViewAllHistoryLink(
                        label: l10n.careHistoryViewAll,
                        onTap: () => context.pushNamed(
                          'plantHistory',
                          pathParameters: {'id': '${widget.plantId}'},
                        ),
                      ),
                    ),
                  ),
                ),

                // ДНЕВНИК — лента (skeleton / ошибка / empty (экран 31) / данные).
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                  sliver: SliverToBoxAdapter(
                    child: _JournalSection(
                      history: history,
                      onRetry: () =>
                          ref.invalidate(plantHistoryProvider(widget.plantId)),
                      // CTA «Полить сейчас» (экран 31): открывает sheet (06)
                      // с предвыбором CareEventKind.water.
                      onWaterNow: () => showLogCareEventSheet(
                        context,
                        plantId: widget.plantId,
                        presetType: CareEventKind.water,
                        plantName: detail.value?.name,
                      ),
                    ),
                  ),
                ),

                // Запас под плавающую кнопку действия.
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),

            // Плавающая основная кнопка «Отметить уход» → sheet (фича 06).
            // Имя растения берём из загруженной детали (если есть) для шапки.
            Positioned(
              left: 22,
              right: 22,
              bottom: 16,
              child: _LogCareButton(
                onPressed: () => showLogCareEventSheet(
                  context,
                  plantId: widget.plantId,
                  plantName: detail.value?.name,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Показывает диалог подтверждения архивации. При подтверждении запускает
  /// [ArchivePlant.archive]. Loading-state блокирует повторный тап через
  /// [_TopBar.isArchiving].
  Future<void> _confirmArchive(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.archivePlantConfirmTitle),
        content: Text(l10n.archivePlantConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.archivePlantConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(archivePlantProvider(widget.plantId).notifier).archive();
    }
  }
}

/// Шапка: кнопка «назад», overline «Карточка», кнопка «ещё».
///
/// [isArchiving] — true пока идёт запрос архивации; блокирует кнопку «ещё»
/// чтобы предотвратить двойной тап.
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.isArchiving,
    required this.onEdit,
    required this.onArchive,
  });

  final bool isArchiving;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        _TopBarButton(
          icon: Icons.arrow_back_rounded,
          tooltip: l10n.plantCardBack,
          onPressed: () => _onBack(context),
        ),
        Expanded(
          child: Text(
            l10n.plantCardOverline.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: c.inkSoft,
            ),
          ),
        ),
        if (isArchiving)
          const SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else
          _TopBarButton(
            icon: Icons.more_horiz_rounded,
            tooltip: l10n.plantCardMore,
            onPressed: () => _showMoreMenu(context, l10n),
          ),
      ],
    );
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  /// Показывает меню «ещё» с пунктами «Редактировать» и «В архив».
  void _showMoreMenu(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.plantCardMenuEdit),
              onTap: () {
                Navigator.of(ctx).pop();
                onEdit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: Text(l10n.archivePlantMenuLabel),
              onTap: () {
                Navigator.of(ctx).pop();
                onArchive();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  const _TopBarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

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
              label: tooltip,
              child: Icon(icon, size: 22, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// Секция детали (hero): skeleton / ошибка с retry / данные.
class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.detail,
    required this.now,
    required this.onRetry,
  });

  final AsyncValue<Plant> detail;
  final DateTime now;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return detail.when(
      loading: () => const PlantHeroSkeleton(),
      error: (error, _) => ErrorState(
        message: l10n.messageForError(error),
        retryLabel: l10n.retry,
        onRetry: onRetry,
      ),
      data: (plant) => PlantHero(plant: plant, now: now),
    );
  }
}

/// Секция стрика: skeleton / ошибка (compact) / empty внутри карточки / данные.
class _StreakSection extends StatelessWidget {
  const _StreakSection({required this.streak, required this.onRetry});

  final AsyncValue<Streak> streak;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return streak.when(
      loading: () => const PlantStreakCardSkeleton(),
      error: (error, _) => ErrorState(
        message: l10n.messageForError(error),
        retryLabel: l10n.retry,
        onRetry: onRetry,
        compact: true,
      ),
      data: (data) => PlantStreakCard(streak: data),
    );
  }
}

/// Секция дневника: skeleton / ошибка с retry / empty (экран 31) / данные.
///
/// При пустой истории ([entries.isEmpty]) показывает speech-bubble от растения
/// «Жду первого ухода…» и CTA «Полить сейчас» → sheet (экран 06, полив).
class _JournalSection extends StatelessWidget {
  const _JournalSection({
    required this.history,
    required this.onRetry,
    required this.onWaterNow,
  });

  final AsyncValue<List<CareHistoryEntry>> history;
  final VoidCallback onRetry;

  /// Открывает sheet (экран 06) с предвыбором полива — передаётся в [PlantJournalCard].
  final VoidCallback onWaterNow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return history.when(
      loading: () => const PlantJournalCardSkeleton(),
      error: (error, _) => ErrorState(
        message: l10n.messageForError(error),
        retryLabel: l10n.retry,
        onRetry: onRetry,
      ),
      data: (entries) => PlantJournalCard(
        entries: entries,
        onWaterNow: onWaterNow,
      ),
    );
  }
}

/// Ссылка-вход в полную историю ухода (экран 21): «Всё ›».
class _ViewAllHistoryLink extends StatelessWidget {
  const _ViewAllHistoryLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Semantics(
          button: true,
          label: label,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.primary,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, size: 18, color: c.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogCareButton extends StatelessWidget {
  const _LogCareButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: c.fab,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      child: InkWell(
        onTap: onPressed,
        child: Semantics(
          button: true,
          label: l10n.plantCardLogCare,
          child: SizedBox(
            height: 56,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      size: 20, color: c.fabInk),
                  const SizedBox(width: 10),
                  Text(
                    l10n.plantCardLogCare,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.fabInk,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
