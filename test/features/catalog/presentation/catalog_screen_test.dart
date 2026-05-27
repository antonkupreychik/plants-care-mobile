import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/catalog/domain/species.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_providers.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_screen.dart';
import 'package:plantcare_mobile/features/catalog/presentation/species_list_state.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/catalog_empty.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/catalog_load_more_footer.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

/// Никогда не завершающийся Future → провайдер остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

List<Species> _species(int n) =>
    List.generate(n, (i) => Species(id: i + 1, name: 'Вид ${i + 1}'));

Widget _wrap({
  Future<SpeciesListState> Function()? list,
  String query = '',
}) {
  return ProviderScope(
    overrides: [
      speciesQueryProvider.overrideWith(() => _StubQuery(query)),
      speciesListProvider.overrideWith(
        () => _StubList(
          list ??
              () async => SpeciesListState(items: _species(3), total: 3),
        ),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const CatalogScreen(),
    ),
  );
}

class _StubQuery extends SpeciesQuery {
  _StubQuery(this._initial);
  final String _initial;
  @override
  String build() => _initial;
}

class _StubList extends SpeciesList {
  _StubList(this._build);
  final Future<SpeciesListState> Function() _build;
  @override
  Future<SpeciesListState> build() => _build();
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(CatalogScreen)));

void main() {
  group('CatalogScreen states', () {
    testWidgets('should_show_skeletons_when_loading', (tester) async {
      await tester.pumpWidget(_wrap(list: _pending<SpeciesListState>));
      await tester.pump();

      expect(find.byType(SpeciesCardSkeleton), findsWidgets);
      expect(find.byType(SpeciesCard), findsNothing);
    });

    testWidgets('should_show_error_with_retry_when_initial_load_fails',
        (tester) async {
      await tester.pumpWidget(_wrap(
        list: () async => throw const ApiError.network(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(_l10n(tester).retry), findsOneWidget);
    });

    testWidgets('should_show_empty_catalog_when_no_query_and_no_items',
        (tester) async {
      await tester.pumpWidget(_wrap(
        query: '',
        list: () async => const SpeciesListState(items: [], total: 0),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(CatalogEmpty), findsOneWidget);
      expect(find.text(l10n.catalogEmpty), findsOneWidget);
    });

    testWidgets('should_show_search_empty_with_query_text_when_no_results',
        (tester) async {
      await tester.pumpWidget(_wrap(
        query: 'кактус',
        list: () async => const SpeciesListState(items: [], total: 0),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(CatalogEmpty), findsOneWidget);
      expect(find.text(l10n.catalogSearchEmpty), findsOneWidget);
      // Подсказка содержит сам запрос — load-bearing для empty-search ветки.
      expect(find.text(l10n.catalogSearchEmptyHint('кактус')), findsOneWidget);
    });

    testWidgets('should_render_species_cards_when_data', (tester) async {
      await tester.pumpWidget(_wrap(
        list: () async => SpeciesListState(items: _species(3), total: 3),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(SpeciesCard), findsNWidgets(3));
      expect(find.text('Вид 1'), findsOneWidget);
    });
  });

  group('CatalogScreen loadMore footer', () {
    testWidgets('should_show_loadMore_indicator_when_isLoadingMore',
        (tester) async {
      await tester.pumpWidget(_wrap(
        list: () async => SpeciesListState(
          items: _species(3),
          total: 10,
          isLoadingMore: true,
        ),
      ));
      // Не pumpAndSettle: CircularProgressIndicator анимируется бесконечно.
      await tester.pump();
      await tester.pump();

      expect(find.byType(CatalogLoadMoreIndicator), findsOneWidget);
      expect(find.byType(CatalogLoadMoreError), findsNothing);
    });

    testWidgets('should_show_loadMore_error_with_retry_when_loadMoreError_set',
        (tester) async {
      await tester.pumpWidget(_wrap(
        list: () async => SpeciesListState(
          items: _species(3),
          total: 10,
          loadMoreError: const ApiError.network(),
        ),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(CatalogLoadMoreError), findsOneWidget);
      expect(find.text(l10n.catalogLoadMoreError), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
      expect(find.byType(CatalogLoadMoreIndicator), findsNothing);
    });

    testWidgets('should_call_retryLoadMore_when_retry_tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            speciesQueryProvider.overrideWith(() => _StubQuery('')),
            speciesListProvider.overrideWith(
              () => _RetrySpyList(() => retried = true),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(),
            home: const CatalogScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(retried, isTrue);
    });
  });

  group('CatalogScreen search debounce', () {
    testWidgets(
        'should_call_setQuery_once_with_final_value_after_debounce_on_fast_typing',
        (tester) async {
      final queries = <String>[];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            speciesQueryProvider
                .overrideWith(() => _SpyQuery(queries.add)),
            speciesListProvider.overrideWith(
              () => _StubList(
                () async => const SpeciesListState(items: [], total: 0),
              ),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(),
            home: const CatalogScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final field = find.byType(TextField);
      // Быстрый ввод нескольких символов — каждый перезапускает таймер 350мс.
      await tester.enterText(field, 'м');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(field, 'мо');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(field, 'мон');

      // До истечения дебаунса setQuery не должен вызываться.
      expect(queries, isEmpty);

      await tester.pump(const Duration(milliseconds: 400));

      // Ровно один вызов с финальным значением.
      expect(queries, ['мон']);
    });
  });
}

class _RetrySpyList extends SpeciesList {
  _RetrySpyList(this._onRetry);
  final VoidCallback _onRetry;
  @override
  Future<SpeciesListState> build() async => SpeciesListState(
        items: _species(2),
        total: 10,
        loadMoreError: const ApiError.network(),
      );
  @override
  Future<void> retryLoadMore() async => _onRetry();
}

class _SpyQuery extends SpeciesQuery {
  _SpyQuery(this._onSet);
  final void Function(String) _onSet;
  @override
  String build() => '';
  @override
  void setQuery(String query) => _onSet(query.trim());
}
