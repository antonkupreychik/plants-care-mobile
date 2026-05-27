import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_detail.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_providers.dart';
import 'package:plantcare_mobile/features/catalog/presentation/species_detail_screen.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_care_section.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_description_card.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_hero.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

Future<T> _pending<T>() => Completer<T>().future;

const _id = 5;

Widget _wrap(Future<SpeciesDetail> Function() detail) {
  return ProviderScope(
    overrides: [
      speciesDetailProvider(_id).overrideWith((ref) => detail()),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const SpeciesDetailScreen(id: _id),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(SpeciesDetailScreen)));

void main() {
  testWidgets('should_show_hero_skeleton_when_loading', (tester) async {
    await tester.pumpWidget(_wrap(_pending<SpeciesDetail>));
    await tester.pump();

    expect(find.byType(SpeciesHeroSkeleton), findsOneWidget);
    expect(find.byType(SpeciesHero), findsNothing);
  });

  testWidgets('should_show_error_with_retry_when_load_fails', (tester) async {
    await tester.pumpWidget(_wrap(() async => throw const ApiError.notFound()));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text(_l10n(tester).retry), findsOneWidget);
  });

  testWidgets('should_render_hero_description_and_care_when_full_data',
      (tester) async {
    await tester.pumpWidget(_wrap(
      () async => const SpeciesDetail(
        id: _id,
        name: 'Монстера',
        latinName: 'Monstera deliciosa',
        wateringDays: 7,
        mistingDays: 3,
        description: 'Тропическая лиана с резными листьями.',
      ),
    ));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    expect(find.byType(SpeciesHero), findsOneWidget);
    expect(find.text('Монстера'), findsOneWidget);
    // Описание видно.
    expect(find.byType(SpeciesDescriptionCard), findsOneWidget);
    expect(find.text('Тропическая лиана с резными листьями.'), findsOneWidget);
    expect(find.text(l10n.speciesDescriptionTitle), findsOneWidget);
    // Секция ухода видна, видимые интервалы отрисованы (полив + опрыскивание).
    expect(find.byType(SpeciesCareSection), findsOneWidget);
    expect(find.text(l10n.speciesCareWatering), findsOneWidget);
    expect(find.text(l10n.speciesCareMisting), findsOneWidget);
    // Подкормка/грунт null → их строк нет.
    expect(find.text(l10n.speciesCareFertilizing), findsNothing);
    expect(find.text(l10n.speciesCareSoilCheck), findsNothing);
  });

  testWidgets('should_hide_description_when_null', (tester) async {
    await tester.pumpWidget(_wrap(
      () async => const SpeciesDetail(
        id: _id,
        name: 'Монстера',
        wateringDays: 7,
      ),
    ));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    expect(find.byType(SpeciesDescriptionCard), findsNothing);
    expect(find.text(l10n.speciesDescriptionTitle), findsNothing);
    // Уход всё ещё есть (один интервал).
    expect(find.byType(SpeciesCareSection), findsOneWidget);
  });

  testWidgets('should_hide_description_when_blank_whitespace', (tester) async {
    await tester.pumpWidget(_wrap(
      () async => const SpeciesDetail(id: _id, name: 'X', description: '   '),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(SpeciesDescriptionCard), findsNothing);
  });

  testWidgets('should_hide_care_section_when_all_intervals_null',
      (tester) async {
    await tester.pumpWidget(_wrap(
      () async => const SpeciesDetail(
        id: _id,
        name: 'Монстера',
        description: 'Только описание.',
      ),
    ));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    expect(find.byType(SpeciesCareSection), findsNothing);
    expect(find.text(l10n.speciesCareTitle), findsNothing);
    // Описание при этом отрисовано.
    expect(find.byType(SpeciesDescriptionCard), findsOneWidget);
  });
}
