import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../disease_catalog/presentation/disease_catalog_providers.dart';
import '../../disease_catalog/presentation/widgets/disease_empty.dart';
import '../../disease_catalog/presentation/widgets/disease_search_field.dart';
import '../../disease_catalog/presentation/widgets/disease_tile.dart';
import 'catalog_providers.dart';
import 'species_list_state.dart';
import 'widgets/catalog_empty.dart';
import 'widgets/catalog_filter_chips.dart';
import 'widgets/catalog_load_more_footer.dart';
import 'widgets/catalog_search_empty.dart';
import 'widgets/catalog_search_field.dart';
import 'widgets/species_card.dart';

/// Экран 12 «Каталог» — переключатель Растения / Болезни (issue #141) +
/// список видов с поиском и пагинацией / справочник болезней.
///
/// Вкладка сохраняется через [catalogTabSelectionProvider] (keepAlive) при
/// уходе/возврате на таб. Состояние поиска каждой ветки живёт независимо.
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final ScrollController _scrollController = ScrollController();

  /// Порог в пикселях до низа, при котором стартует дозагрузка (только виды).
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

    final tab = ref.read(catalogTabSelectionProvider);
    if (tab != CatalogTab.plants) return;

    final state = ref.read(speciesListProvider).value;
    if (state == null || state.isLoadingMore || !state.hasMore) return;
    if (state.loadMoreError != null) return; // ждём ручного повтора
    ref.read(speciesListProvider.notifier).loadMore();
  }

  Future<void> _onRefresh() async {
    ref.invalidate(speciesListProvider);
    try {
      await ref.read(speciesListProvider.future);
    } catch (_) {
      // Ошибку обрабатывает UI через AsyncValue.error — индикатор гасим.
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final selectedTab = ref.watch(catalogTabSelectionProvider);

    if (selectedTab == CatalogTab.diseases) {
      return _DiseaseCatalogBody();
    }

    final query = ref.watch(speciesQueryProvider);
    final listState = ref.watch(speciesListProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
                sliver: SliverToBoxAdapter(
                  child: _CatalogHeader(listState: listState),
                ),
              ),

              // Переключатель Растения / Болезни
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                sliver: SliverToBoxAdapter(
                  child: _CatalogSegmentSwitcher(
                    selected: selectedTab,
                    onSelect: (tab) => ref
                        .read(catalogTabSelectionProvider.notifier)
                        .select(tab),
                  ),
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

              SliverPadding(
                padding: const EdgeInsets.only(top: 12),
                sliver: SliverToBoxAdapter(
                  child: CatalogFilterChips(total: listState.value?.total),
                ),
              ),

              _CatalogBody(
                listState: listState,
                query: query,
                onTapSpecies: (id) => context.push('/catalog/$id'),
                onRetryInitial: () => ref.invalidate(speciesListProvider),
                onRetryLoadMore: () =>
                    ref.read(speciesListProvider.notifier).retryLoadMore(),
                onAddPlant: () => context.go('/home/add'),
                onSuggestionTap: (name) =>
                    ref.read(speciesQueryProvider.notifier).setQuery(name),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Переключатель вкладок Растения / Болезни (SegmentedButton, Material 3).
class _CatalogSegmentSwitcher extends StatelessWidget {
  const _CatalogSegmentSwitcher({
    required this.selected,
    required this.onSelect,
  });

  final CatalogTab selected;
  final ValueChanged<CatalogTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SegmentedButton<CatalogTab>(
      segments: [
        ButtonSegment(
          value: CatalogTab.plants,
          label: Text(l10n.catalogTabPlants),
        ),
        ButtonSegment(
          value: CatalogTab.diseases,
          label: Text(l10n.catalogTabDiseases),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (set) {
        if (set.isNotEmpty) onSelect(set.first);
      },
      showSelectedIcon: false,
    );
  }
}

/// Встроенное тело болезней — показывается когда выбрана вкладка «Болезни».
///
/// Не использует [DiseaseCatalogScreen] напрямую (тот ставит свой Scaffold и
/// AppBar с pop-кнопкой). Повторяет его контент без Scaffold-обёртки,
/// добавляя шапку с заголовком и переключателем.
class _DiseaseCatalogBody extends ConsumerWidget {
  const _DiseaseCatalogBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final selectedTab = ref.watch(catalogTabSelectionProvider);
    final query = ref.watch(diseaseQueryProvider);
    final listState = ref.watch(diseaseListProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Шапка с заголовком
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
              child: _DiseasesHeader(count: listState.value?.length),
            ),
            // Переключатель Растения / Болезни
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
              child: _CatalogSegmentSwitcher(
                selected: selectedTab,
                onSelect: (tab) =>
                    ref.read(catalogTabSelectionProvider.notifier).select(tab),
              ),
            ),
            const SizedBox(height: 4),
            // Поле поиска
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
              child: DiseaseSearchField(
                initialValue: query,
                onSubmitted: (value) =>
                    ref.read(diseaseQueryProvider.notifier).setQuery(value),
              ),
            ),
            const SizedBox(height: 12),
            // Список болезней
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(diseaseListProvider),
                color: c.primary,
                child: listState.when(
                  loading: () => ListView.separated(
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
                    itemCount: 6,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, _) => const _DiseaseTileSkeleton(),
                  ),
                  error: (error, _) => ListView(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                    children: [
                      ErrorState(
                        message: l10n.messageForError(error),
                        retryLabel: l10n.retry,
                        onRetry: () => ref.invalidate(diseaseListProvider),
                      ),
                    ],
                  ),
                  data: (diseases) {
                    if (diseases.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                        children: [
                          DiseaseEmpty(title: l10n.diseaseCatalogEmpty),
                        ],
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
                      itemCount: diseases.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final disease = diseases[index];
                        return DiseaseTile(
                          disease: disease,
                          onTap: () =>
                              context.push('/profile/diseases/${disease.id}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка вкладки «Болезни»: серифный заголовок с акцентом и счётчик болезней
/// под ним (по образцу [_CatalogHeader] вкладки «Растения»).
class _DiseasesHeader extends StatelessWidget {
  const _DiseasesHeader({this.count});

  /// Число болезней в справочнике; null пока список не загружен.
  final int? count;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: l10n.catalogHeadingLead,
                style: AppTheme.serif(fontSize: 38, color: c.ink),
              ),
              TextSpan(
                text: l10n.catalogTabDiseases.toLowerCase(),
                style: AppTheme.serif(
                  fontSize: 38,
                  color: c.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        if (count != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.diseaseCatalogCount(count!),
            style: TextStyle(fontSize: 13, color: c.inkSoft),
          ),
        ],
      ],
    );
  }
}

/// Шапка каталога: серифный заголовок «Каталог *растений*» (акцент primary
/// italic) и счётчик видов под ним. Без back button и overline — каталог это
/// корневой таб нижней навигации (issue #80, п.5–6, дизайн `screens-v4`).
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
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: l10n.catalogHeadingLead,
                style: AppTheme.serif(fontSize: 38, color: c.ink),
              ),
              TextSpan(
                text: l10n.catalogHeadingAccent,
                style: AppTheme.serif(
                  fontSize: 38,
                  color: c.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        if (total != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.catalogCount(total),
            style: TextStyle(fontSize: 13, color: c.inkSoft),
          ),
        ],
      ],
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
    required this.onAddPlant,
    required this.onSuggestionTap,
  });

  final AsyncValue<SpeciesListState> listState;
  final String query;
  final void Function(int id) onTapSpecies;
  final VoidCallback onRetryInitial;
  final VoidCallback onRetryLoadMore;
  final VoidCallback onAddPlant;
  final ValueChanged<String> onSuggestionTap;

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
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            sliver: SliverToBoxAdapter(
              child: query.isNotEmpty
                  ? CatalogSearchEmpty(
                      query: query,
                      onSuggestionTap: onSuggestionTap,
                      onAddPlant: onAddPlant,
                    )
                  : CatalogEmpty(
                      title: l10n.catalogEmpty,
                      hint: l10n.catalogEmptyHint,
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

/// Скелетон строки болезни во время загрузки.
class _DiseaseTileSkeleton extends StatelessWidget {
  const _DiseaseTileSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
    );
  }
}
