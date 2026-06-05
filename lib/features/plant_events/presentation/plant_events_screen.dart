import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import 'add_plant_event_sheet.dart';
import 'plant_events_providers.dart';
import 'plant_events_state.dart';
import 'widgets/plant_event_tile.dart';
import 'widgets/plant_events_empty.dart';

/// Экран «Журнал событий» растения (вход из карточки 02 → «Все события»).
///
/// Потребляет [plantEventsControllerProvider] (family по [plantId]):
/// loading / error / empty / data c пагинацией и pull-to-refresh.
/// FAB «+ Событие» → [showAddPlantEventSheet].
class PlantEventsScreen extends ConsumerStatefulWidget {
  const PlantEventsScreen({super.key, required this.plantId});

  final int plantId;

  @override
  ConsumerState<PlantEventsScreen> createState() => _PlantEventsScreenState();
}

class _PlantEventsScreenState extends ConsumerState<PlantEventsScreen> {
  final _scrollController = ScrollController();

  /// Порог автозагрузки до конца ленты (px), как в истории ухода.
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

    final state = ref.read(plantEventsControllerProvider(widget.plantId)).value;
    if (state == null || state.isLoadingMore || !state.hasMore) return;
    if (state.loadMoreError != null) return; // ждём ручного повтора
    ref
        .read(plantEventsControllerProvider(widget.plantId).notifier)
        .loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final plantId = widget.plantId;
    final events = ref.watch(plantEventsControllerProvider(plantId));

    return Scaffold(
      backgroundColor: c.bg,
      floatingActionButton: events.maybeWhen(
        // FAB показываем, когда есть данные (в empty CTA внутри карточки).
        data: (state) => state.total == 0
            ? null
            : FloatingActionButton.extended(
                onPressed: () =>
                    showAddPlantEventSheet(context, plantId: plantId),
                backgroundColor: c.fab,
                foregroundColor: c.fabInk,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addPlantEventButton),
              ),
        orElse: () => null,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(title: l10n.plantEventsScreenTitle),
            Expanded(
              child: events.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                  child: ErrorState(
                    message: l10n.messageForError(error),
                    retryLabel: l10n.retry,
                    onRetry: () =>
                        ref.invalidate(plantEventsControllerProvider(plantId)),
                  ),
                ),
                data: (state) => RefreshIndicator(
                  onRefresh: () => ref
                      .read(
                          plantEventsControllerProvider(plantId).notifier)
                      .refresh(),
                  child: state.total == 0
                      ? _EmptyScroll(
                          onAdd: () =>
                              showAddPlantEventSheet(context, plantId: plantId),
                        )
                      : _EventsList(
                          plantId: plantId,
                          state: state,
                          scrollController: _scrollController,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Пустое состояние, обёрнутое в скролл (чтобы pull-to-refresh работал).
class _EmptyScroll extends StatelessWidget {
  const _EmptyScroll({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 40),
      children: [PlantEventsEmpty(onAdd: onAdd)],
    );
  }
}

/// Лента событий + футер пагинации.
class _EventsList extends ConsumerWidget {
  const _EventsList({
    required this.plantId,
    required this.state,
    required this.scrollController,
  });

  final int plantId;
  final PlantEventsState state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final items = state.items;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
          sliver: SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: c.line),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: List.generate(
                  items.length,
                  (i) => PlantEventTile(event: items[i], showDivider: i > 0),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
          sliver: SliverToBoxAdapter(child: _Footer(plantId: plantId, state: state)),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

/// Футер пагинации: ошибка дозагрузки / спиннер / кнопка «Показать ещё».
class _Footer extends ConsumerWidget {
  const _Footer({required this.plantId, required this.state});

  final int plantId;
  final PlantEventsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final controller =
        ref.read(plantEventsControllerProvider(plantId).notifier);

    if (state.loadMoreError != null) {
      return Center(
        child: TextButton.icon(
          onPressed: controller.retryLoadMore,
          icon: Icon(Icons.refresh_rounded, size: 18, color: c.primary),
          label: Text(
            l10n.plantEventsLoadMoreError,
            style: TextStyle(color: c.primary, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    if (state.isLoadingMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      );
    }
    if (state.hasMore) {
      return Center(
        child: TextButton(
          onPressed: controller.loadMore,
          child: Text(
            l10n.plantEventsLoadMore,
            style: TextStyle(color: c.primary, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

/// Шапка: «назад» + серифный заголовок по центру (как в истории ухода).
class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: Row(
        children: [
          _BackButton(onPressed: () => _onBack(context)),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.serif(fontSize: 22, color: c.ink),
            ),
          ),
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
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Material(
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
            child: Icon(Icons.arrow_back_rounded, size: 22, color: c.ink),
          ),
        ),
      ),
    );
  }
}
