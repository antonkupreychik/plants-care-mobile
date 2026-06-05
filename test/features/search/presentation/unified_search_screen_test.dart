import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/catalog/domain/species.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/search/domain/disease.dart';
import 'package:plantcare_mobile/features/search/presentation/search_providers.dart';
import 'package:plantcare_mobile/features/search/presentation/unified_search_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

Widget _wrap({
  String query = '',
  List<Plant> plants = const [],
  List<Species> species = const [],
  List<Disease> diseases = const [],
}) =>
    ProviderScope(
      overrides: [
        unifiedSearchQueryProvider.overrideWith(() {
          final n = _SeededQuery(query);
          return n;
        }),
        plantSearchResultsProvider.overrideWith((ref, q) async => plants),
        speciesSearchResultsProvider.overrideWith((ref, q) async => species),
        diseaseSearchResultsProvider.overrideWith((ref, q) async => diseases),
      ],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const UnifiedSearchScreen(),
      ),
    );

class _SeededQuery extends UnifiedSearchQuery {
  _SeededQuery(this._seed);
  final String _seed;

  @override
  String build() => _seed;
}

void main() {
  testWidgets('should_show_min_chars_hint_when_query_too_short',
      (tester) async {
    await tester.pumpWidget(_wrap(query: 'м'));
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));
    expect(find.text(l10n.searchMinCharsHint), findsOneWidget);
  });

  testWidgets('should_show_empty_result_when_all_sections_empty',
      (tester) async {
    await tester.pumpWidget(_wrap(query: 'кактус'));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));
    expect(find.text(l10n.searchEmptyResult), findsOneWidget);
  });

  testWidgets('should_render_section_headers_and_results_when_data_present',
      (tester) async {
    await tester.pumpWidget(_wrap(
      query: 'мон',
      plants: [const Plant(id: 1, name: 'Монстера', locationName: 'Гостиная')],
      species: [const Species(id: 2, name: 'Monstera deliciosa')],
    ));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));
    expect(find.text(l10n.searchSectionPlants), findsOneWidget);
    expect(find.text(l10n.searchSectionSpecies), findsOneWidget);
    expect(find.text('Монстера'), findsOneWidget);
    expect(find.text('Monstera deliciosa'), findsOneWidget);
    // «Показать все» появляется в секциях с результатами (растения + виды).
    expect(find.text(l10n.searchShowAll), findsNWidgets(2));
  });
}
