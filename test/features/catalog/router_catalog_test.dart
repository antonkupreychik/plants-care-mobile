import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/router/app_router.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/catalog/data/catalog_repository_provider.dart';
import 'package:plantcare_mobile/features/catalog/domain/catalog_repository.dart';
import 'package:plantcare_mobile/features/catalog/domain/species.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_detail.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_page.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_providers.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_screen.dart';
import 'package:plantcare_mobile/features/catalog/presentation/species_detail_screen.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements CatalogRepository {}

Widget _app(CatalogRepository repo) => ProviderScope(
      overrides: [catalogRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        routerConfig: appRouter,
      ),
    );

void main() {
  setUp(() {
    appRouter.go('/home');
  });

  testWidgets(
      'should_navigate_to_species_detail_with_tapped_id_when_card_tapped',
      (tester) async {
    final repo = _MockRepo();
    final detailIds = <int>[];

    when(() => repo.searchSpecies(
          query: any(named: 'query'),
          offset: any(named: 'offset'),
          limit: any(named: 'limit'),
        )).thenAnswer(
      (_) async => Result.success(
        SpeciesPage(
          items: const [
            Species(id: 7, name: 'Монстера'),
            Species(id: 8, name: 'Фикус'),
          ],
          total: 2,
          offset: 0,
          limit: kSpeciesPageLimit,
        ),
      ),
    );
    when(() => repo.getSpecies(any())).thenAnswer((inv) async {
      detailIds.add(inv.positionalArguments.first as int);
      return const Result.success(
        SpeciesDetail(id: 7, name: 'Монстера', latinName: 'Monstera'),
      );
    });

    await tester.pumpWidget(_app(repo));

    // Стартуем на каталоге.
    appRouter.go('/catalog');
    await tester.pumpAndSettle();
    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(find.byType(SpeciesCard), findsNWidgets(2));

    // Тап по первой карточке → push на /catalog/7 → деталь с id 7.
    await tester.tap(find.text('Монстера'));
    await tester.pumpAndSettle();

    expect(find.byType(SpeciesDetailScreen), findsOneWidget);
    final screen =
        tester.widget<SpeciesDetailScreen>(find.byType(SpeciesDetailScreen));
    expect(screen.id, 7);
    expect(detailIds, contains(7));
  });
}
