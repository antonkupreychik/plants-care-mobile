import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../care_event/presentation/log_care_event_sheet.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../../plant_card/domain/care_history_entry.dart';
import '../domain/care_history_summary.dart';
import 'care_history_providers.dart';
import 'care_history_state.dart';
import 'widgets/care_history_empty.dart';
import 'widgets/care_history_filter_chips.dart';
import 'widgets/care_history_load_more.dart';
import 'widgets/care_history_summary_header.dart';
import 'widgets/care_history_timeline.dart';

/// Экран 21 «Полная история ухода».
///
/// Потребляет family-провайдеры по [plantId] (контракт flutter-coder):
/// - [careHistoryControllerProvider] — таймлайн (loading/error/data) +
///   `loadMore`/`retryLoadMore`/`setFilter`;
/// - [careHistorySummaryProvider] — сводка (всего/вовремя%/стрик), `null` пока
///   нет данных (мягкая деградация → skeleton);
/// - [careHistoryPlantProvider] — имя в шапку + `createdAt` (маркер появления).
///
/// Время `performedAt`/`createdAt` приходит в UTC → перед показом и
/// группировкой по месяцам приводим к локальной TZ (`.toLocal()`).
///
/// Состояния: loading (skeleton сводки + таймлайна), error (с retry →
/// `invalidate`), empty (`total == 0` → экран 31), data (таймлайн + пагинация).
class CareHistoryScreen extends ConsumerStatefulWidget {
  const CareHistoryScreen({super.key, required this.plantId});

  final int plantId;

  @override
  ConsumerState<CareHistoryScreen> createState() => _CareHistoryScreenState();
}

class _CareHistoryScreenState extends ConsumerState<CareHistoryScreen> {
  final _scrollController = ScrollController();

  /// Порог автозагрузки до конца ленты (px), как в каталоге.
  static const double _loadMoreThreshold = 400;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels < pos.maxScrollExtent - _loadMoreThreshold) return;

    final state =
        ref.read(careHistoryControllerProvider(widget.plantId)).value;
    if (state == null || state.isLoadingMore || !state.hasMore) return;
    if (state.loadMoreError != null) return; // ждём ручного повтора
    ref.read(careHistoryControllerProvider(widget.plantId).notifier).loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final plantId = widget.plantId;
    final l10n = AppLocalizations.of(context);

    final history = ref.watch(careHistoryControllerProvider(plantId));
    final plant = ref.watch(careHistoryPlantProvider(plantId));
    final summary = ref.watch(careHistorySummaryProvider(plantId));

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(plantName: plant.value?.name),
            Expanded(
              child: history.when(
                loading: () => const _LoadingView(),
                error: (error, _) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                  child: ErrorState(
                    message: l10n.messageForError(error),
                    retryLabel: l10n.retry,
                    onRetry: () => ref.invalidate(
                      careHistoryControllerProvider(plantId),
                    ),
                  ),
                ),
                data: (state) {
                  if (state.total == 0) {
                    return CareHistoryEmpty(
                      plantName: plant.value?.name,
                      speciesName: plant.value?.speciesName,
                      onLogCare: () => showLogCareEventSheet(
                        context,
                        plantId: plantId,
                        plantName: plant.value?.name,
                      ),
                    );
                  }
                  return _DataView(
                    plantId: plantId,
                    state: state,
                    summary: summary,
                    plantName: plant.value?.name,
                    plantCreatedAt: plant.value?.createdAt,
                    scrollController: _scrollController,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: «назад», overline «Дневник ухода» + имя растения.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.plantName});

  final String? plantName;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: Row(
        children: [
          _BackButton(
            tooltip: l10n.plantCardBack,
            onPressed: () => _onBack(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  l10n.careHistoryOverline.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: c.inkSoft,
                  ),
                ),
                if (plantName != null && plantName!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    plantName!.trim(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.serif(fontSize: 20, color: c.ink),
                  ),
                ],
              ],
            ),
          ),
          // Баланс под кнопкой «назад», чтобы заголовок был по центру.
          const SizedBox(width: 44),
        ],
      ),
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

class _BackButton extends StatelessWidget {
  const _BackButton({required this.tooltip, required this.onPressed});

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
              child: Icon(Icons.arrow_back_rounded, size: 22, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// Loading первичной загрузки: skeleton сводки + несколько строк таймлайна.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 40),
      children: const [
        CareHistorySummaryHeaderSkeleton(),
        SizedBox(height: 20),
        CareHistoryLoadMoreIndicator(),
      ],
    );
  }
}

/// Данные: сводка + фильтр-чипы + сгруппированный по месяцам таймлайн +
/// маркер появления растения + футер пагинации.
class _DataView extends ConsumerWidget {
  const _DataView({
    required this.plantId,
    required this.state,
    required this.summary,
    required this.plantName,
    required this.plantCreatedAt,
    required this.scrollController,
  });

  final int plantId;
  final CareHistoryState state;
  final CareHistorySummary? summary;
  final String? plantName;
  final DateTime? plantCreatedAt;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller =
        ref.read(careHistoryControllerProvider(plantId).notifier);

    final visible = state.visibleEntries;
    final groups = _groupByMonth(visible, l10n.localeName);
    // Маркер появления показываем только когда подгружены все страницы и фильтр
    // не активен — иначе «начало истории» вводит в заблуждение.
    final showCreatedMarker = !state.hasMore &&
        state.filter == null &&
        plantCreatedAt != null;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
          sliver: SliverToBoxAdapter(
            child: CareHistorySummaryHeader(summary: summary),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 14, bottom: 4),
          sliver: SliverToBoxAdapter(
            child: CareHistoryFilterChips(
              totalLoaded: state.entries.length,
              countByKind: _countByKind(state.entries),
              active: state.filter,
              onSelected: controller.setFilter,
            ),
          ),
        ),
        if (visible.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
            sliver: SliverToBoxAdapter(
              child: _FilteredEmpty(),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
            sliver: SliverList.builder(
              itemCount: groups.length,
              itemBuilder: (context, i) => CareHistoryMonthGroup(
                monthLabel: groups[i].label,
                entries: groups[i].entries,
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
          sliver: SliverToBoxAdapter(
            child: _Footer(
              plantId: plantId,
              state: state,
              showCreatedMarker: showCreatedMarker,
              plantName: plantName,
              plantCreatedAt: plantCreatedAt,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  /// Группировка по локальному месяцу/году с сохранением порядка backend
  /// (новые сверху): идём по списку, открывая новую группу при смене месяца.
  static List<_MonthGroup> _groupByMonth(
    List<CareHistoryEntry> entries,
    String locale,
  ) {
    final fmt = DateFormat.yMMMM(locale);
    final groups = <_MonthGroup>[];
    int? curYear;
    int? curMonth;
    for (final e in entries) {
      final local = e.performedAt.toLocal();
      if (groups.isEmpty || local.year != curYear || local.month != curMonth) {
        curYear = local.year;
        curMonth = local.month;
        groups.add(
          _MonthGroup(
            label: fmt.format(DateTime(local.year, local.month)),
            entries: [e],
          ),
        );
      } else {
        groups.last.entries.add(e);
      }
    }
    return groups;
  }

  static Map<CareEventKind, int> _countByKind(List<CareHistoryEntry> entries) {
    final map = <CareEventKind, int>{};
    for (final e in entries) {
      map[e.kind] = (map[e.kind] ?? 0) + 1;
    }
    return map;
  }
}

class _MonthGroup {
  const _MonthGroup({required this.label, required this.entries});
  final String label;
  final List<CareHistoryEntry> entries;
}

/// Футер: маркер появления растения (если уместен) + состояние пагинации.
class _Footer extends ConsumerWidget {
  const _Footer({
    required this.plantId,
    required this.state,
    required this.showCreatedMarker,
    required this.plantName,
    required this.plantCreatedAt,
  });

  final int plantId;
  final CareHistoryState state;
  final bool showCreatedMarker;
  final String? plantName;
  final DateTime? plantCreatedAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.read(careHistoryControllerProvider(plantId).notifier);

    return Column(
      children: [
        if (state.loadMoreError != null)
          CareHistoryLoadMoreError(onRetry: controller.retryLoadMore)
        else if (state.isLoadingMore)
          const CareHistoryLoadMoreIndicator()
        else if (state.hasMore)
          CareHistoryLoadMoreButton(onPressed: controller.loadMore),
        if (showCreatedMarker && plantCreatedAt != null)
          CareHistoryPlantCreatedMarker(
            plantName: plantName ?? '',
            createdAtLocal: plantCreatedAt!.toLocal(),
          ),
      ],
    );
  }
}

/// Пусто под активным фильтром (загруженных записей этого типа нет).
class _FilteredEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Icon(Icons.filter_alt_off_outlined, size: 28, color: c.inkMute),
          const SizedBox(height: 10),
          Text(
            l10n.plantCardJournalEmpty,
            textAlign: TextAlign.center,
            style: AppTheme.serif(fontSize: 20, color: c.ink),
          ),
        ],
      ),
    );
  }
}
