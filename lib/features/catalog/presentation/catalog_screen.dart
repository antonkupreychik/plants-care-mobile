import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import 'catalog_providers.dart';
import 'species_list_state.dart';
import 'widgets/catalog_empty.dart';
import 'widgets/catalog_load_more_footer.dart';
import 'widgets/catalog_search_field.dart';
import 'widgets/species_card.dart';

/// Экран 12 «Каталог видов» — список + поиск + пагинация.
///
/// Потребляет [speciesQueryProvider] (committed-строка поиска) и
/// [speciesListProvider] (`AsyncValue<SpeciesListState>`). Дебаунс ввода —
/// в [CatalogSearchField] (Timer). Пагинация — по [ScrollController]: близко к
/// низу при `hasMore && !isLoadingMore` зовём `loadMore()`.
///
/// Состояния: loading (скелетоны), error первичной (`ErrorState` + retry через
/// invalidate), empty (пустой каталог / поиск без результатов), data. Внизу
/// списка — индикатор дозагрузки или компактная ошибка с повтором.
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final ScrollController _scrollController = ScrollController();

  /// Порог в пикселях до низа, при котором стартует дозагрузка.
  static const double _loadMoreThreshold = 400;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - _loadMoreThreshold) return;

    final state = ref.read(speciesListProvider).value;
    if (state == null || state.isLoadingMore || !state.hasMore) return;
    if (state.loadMoreError != null) return; // ждём ручного повтора
    ref.read(speciesListProvider.notifier).loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final query = ref.watch(speciesQueryProvider);
    final listState = ref.watch(speciesListProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
              sliver: SliverToBoxAdapter(
                child: _CatalogHeader(listState: listState),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
              sliver: SliverToBoxAdapter(
                child: CatalogSearchField(
                  initialValue: query,
                  onSubmitted: (value) =>
                      ref.read(speciesQueryProvider.notifier).setQuery(value),
                ),
              ),
            ),

            _CatalogBody(
              listState: listState,
              query: query,
              onTapSpecies: (id) => context.push('/catalog/$id'),
              onRetryInitial: () => ref.invalidate(speciesListProvider),
              onRetryLoadMore: () =>
                  ref.read(speciesListProvider.notifier).retryLoadMore(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

/// Шапка: overline «Каталог», серифный заголовок и счётчик видов (когда есть).
class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader({required this.listState});

  final AsyncValue<SpeciesListState> listState;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final total = listState.value?.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _BackButton(),
            const SizedBox(width: 4),
            Text(
              l10n.catalogTitle.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: c.inkSoft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          l10n.catalogHeading,
          style: AppTheme.serif(fontSize: 32, color: c.ink),
        ),
        if (total != null) ...[
          const SizedBox(height: 2),
          Text(
            l10n.catalogCount(total),
            style: TextStyle(fontSize: 13, color: c.inkSoft),
          ),
        ],
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n.plantCardBack,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: l10n.plantCardBack,
              child: Icon(Icons.arrow_back_rounded, size: 22, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// Тело списка: loading (скелетоны) / error первичной / empty / data со
/// списком + футером (индикатор дозагрузки или компактная ошибка).
class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.listState,
    required this.query,
    required this.onTapSpecies,
    required this.onRetryInitial,
    required this.onRetryLoadMore,
  });

  final AsyncValue<SpeciesListState> listState;
  final String query;
  final void Function(int id) onTapSpecies;
  final VoidCallback onRetryInitial;
  final VoidCallback onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return listState.when(
      loading: () => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        sliver: SliverList.separated(
          itemCount: 6,
          separatorBuilder: _gap,
          itemBuilder: _skeletonBuilder,
        ),
      ),
      error: (error, _) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        sliver: SliverToBoxAdapter(
          child: ErrorState(
            message: l10n.messageForError(error),
            retryLabel: l10n.retry,
            onRetry: onRetryInitial,
          ),
        ),
      ),
      data: (state) {
        if (state.items.isEmpty) {
          final isSearch = query.isNotEmpty;
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            sliver: SliverToBoxAdapter(
              child: CatalogEmpty(
                title: isSearch ? l10n.catalogSearchEmpty : l10n.catalogEmpty,
                hint: isSearch
                    ? l10n.catalogSearchEmptyHint(query)
                    : l10n.catalogEmptyHint,
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          sliver: SliverList.separated(
            // +1 под футер (индикатор / ошибка), если уместен.
            itemCount: state.items.length + (_hasFooter(state) ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                if (state.loadMoreError != null) {
                  return CatalogLoadMoreError(onRetry: onRetryLoadMore);
                }
                return const CatalogLoadMoreIndicator();
              }
              final species = state.items[index];
              return SpeciesCard(
                species: species,
                onTap: () => onTapSpecies(species.id),
              );
            },
          ),
        );
      },
    );
  }

  static bool _hasFooter(SpeciesListState state) =>
      state.isLoadingMore || state.loadMoreError != null;

  static Widget _gap(BuildContext context, int index) =>
      const SizedBox(height: 10);

  static Widget _skeletonBuilder(BuildContext context, int index) =>
      const SpeciesCardSkeleton();
}
