import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/presentation/catalog_providers.dart';
import 'search_providers.dart';
import 'widgets/search_empty.dart';
import 'widgets/search_field.dart';
import 'widgets/search_result_tile.dart';
import 'widgets/search_section.dart';

/// Экран унифицированного поиска (issue #69) — растения + виды + болезни.
///
/// Полноэкранный, поверх shell (роут `/search` на root-навигаторе, без таб-бара).
/// Автофокус на поле; ввод дебаунсится 400 мс ([SearchField]) и кладётся в
/// [unifiedSearchQueryProvider]. Три раздела ([plantSearchResultsProvider],
/// [speciesSearchResultsProvider], [diseaseSearchResultsProvider]) грузятся
/// параллельно и рисуют состояние независимо.
///
/// Состояния экрана: `q.length < 2` → подсказка «введите 2+ символа»; все секции
/// загрузились и пусты → «ничего не найдено»; иначе — секции (loading рисует
/// skeleton посекционно).
class UnifiedSearchScreen extends ConsumerWidget {
  const UnifiedSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(unifiedSearchQueryProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: c.ink,
                    tooltip: l10n.searchBack,
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: SearchField(
                      onChangedDebounced: (value) => ref
                          .read(unifiedSearchQueryProvider.notifier)
                          .setQuery(value),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: query.length < kSearchMinChars
                  ? SearchEmpty(
                      icon: Icons.search_rounded,
                      message: l10n.searchMinCharsHint,
                    )
                  : _SearchResults(query: query),
            ),
          ],
        ),
      ),
    );
  }
}

/// Список секций при достаточной длине запроса. Сводит три провайдера, рисует
/// «ничего не найдено», когда все секции загружены и пусты.
class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plants = ref.watch(plantSearchResultsProvider(query));
    final species = ref.watch(speciesSearchResultsProvider(query));
    final diseases = ref.watch(diseaseSearchResultsProvider(query));

    // «Ничего не найдено» — только когда все три раздела загрузились (не в
    // loading) и не дали результатов. Пока хоть один грузится — ждём (рисуем
    // секции со skeleton). Ошибка раздела считается «не пусто» (секция её не
    // прячет), но текущие секции тихо сворачиваются при ошибке — поэтому
    // ориентируемся на data-результаты.
    final allLoaded = !plants.isLoading &&
        !species.isLoading &&
        !diseases.isLoading;
    final allEmpty = (plants.value?.isEmpty ?? true) &&
        (species.value?.isEmpty ?? true) &&
        (diseases.value?.isEmpty ?? true);

    if (allLoaded && allEmpty) {
      return SearchEmpty(
        icon: Icons.sentiment_dissatisfied_rounded,
        message: l10n.searchEmptyResult,
      );
    }

    final plantItems = plants.value ?? const [];
    final speciesItems = species.value ?? const [];
    final diseaseItems = diseases.value ?? const [];

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
      children: [
        SearchSection(
          title: l10n.searchSectionPlants,
          isLoading: plants.isLoading,
          count: plantItems.length,
          // «Все растения» → главный экран «Мой сад» (полный список). Фильтра по
          // имени на Home пока нет (Home фильтрует только по локации), поэтому
          // ведём на полный сад без предзаполненного name-фильтра.
          onShowAll: () => context.go('/home'),
          children: [
            for (final plant in plantItems)
              SearchResultTile(
                icon: Icons.eco_rounded,
                title: plant.name,
                subtitle: plant.locationName,
                onTap: () => context.push('/home/plants/${plant.id}'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        SearchSection(
          title: l10n.searchSectionSpecies,
          isLoading: species.isLoading,
          count: speciesItems.length,
          onShowAll: () {
            // «Все виды» → каталог с тем же запросом (committed-строка каталога).
            ref.read(speciesQueryProvider.notifier).setQuery(query);
            context.go('/catalog');
          },
          children: [
            for (final s in speciesItems)
              SearchResultTile(
                icon: Icons.local_florist_rounded,
                title: s.name,
                subtitle: s.latinName,
                onTap: () => context.push('/catalog/${s.id}'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        SearchSection(
          title: l10n.searchSectionDiseases,
          isLoading: diseases.isLoading,
          count: diseaseItems.length,
          // Раздел болезней — заглушка пустого списка до plants-care#225 и #68:
          // кнопка/плитки не появляются (count == 0), переход в детали болезни
          // подключается вместе с фичей болезней.
          onShowAll: () {},
          children: [
            for (final d in diseaseItems)
              SearchResultTile(
                icon: Icons.bug_report_rounded,
                title: d.name,
                subtitle: d.latinName,
                onTap: () {},
              ),
          ],
        ),
      ],
    );
  }
}
