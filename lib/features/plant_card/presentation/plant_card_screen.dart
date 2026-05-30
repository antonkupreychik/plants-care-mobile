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
class PlantCardScreen extends ConsumerWidget {
  const PlantCardScreen({super.key, required this.plantId});

  final int plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();

    void comingSoon() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
    }

    final detail = ref.watch(plantDetailProvider(plantId));
    final streak = ref.watch(plantStreakProvider(plantId));
    final history = ref.watch(plantHistoryProvider(plantId));

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
                    child: _TopBar(onMore: comingSoon),
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
                          ref.invalidate(plantDetailProvider(plantId)),
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
                          ref.invalidate(plantStreakProvider(plantId)),
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
                          pathParameters: {'id': '$plantId'},
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
                          pathParameters: {'id': '$plantId'},
                        ),
                      ),
                    ),
                  ),
                ),

                // ДНЕВНИК — лента (skeleton / ошибка / empty / данные).
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                  sliver: SliverToBoxAdapter(
                    child: _JournalSection(
                      history: history,
                      onRetry: () =>
                          ref.invalidate(plantHistoryProvider(plantId)),
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
                  plantId: plantId,
                  plantName: detail.value?.name,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: кнопка «назад», overline «Карточка», кнопка «ещё».
class _TopBar extends StatelessWidget {
  const _TopBar({required this.onMore});

  final VoidCallback onMore;

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
        _TopBarButton(
          icon: Icons.more_horiz_rounded,
          tooltip: l10n.plantCardMore,
          onPressed: onMore,
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

/// Секция дневника: skeleton / ошибка с retry / empty внутри карточки / данные.
class _JournalSection extends StatelessWidget {
  const _JournalSection({required this.history, required this.onRetry});

  final AsyncValue<List<CareHistoryEntry>> history;
  final VoidCallback onRetry;

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
      data: (entries) => PlantJournalCard(entries: entries),
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
