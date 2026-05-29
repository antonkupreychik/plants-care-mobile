import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/theme/tokens.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/catalog/domain/care_difficulty.dart';
import 'package:plantcare_mobile/features/catalog/domain/light_preference.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_detail.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_providers.dart';
import 'package:plantcare_mobile/features/catalog/presentation/species_attributes_l10n.dart';
import 'package:plantcare_mobile/features/catalog/presentation/species_detail_screen.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_add_cta.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_care_section.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_description_card.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_facts_grid.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_hero.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_light_meter.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_toxicity_banner.dart';
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

/// Возвращает индекс активной ступени шкалы света: ищет 4 горизонтальные
/// «полоски» (высота 8) внутри [SpeciesLightMeter] и определяет ту, что окрашена
/// `primary` (активная). Честная проверка маппинга `LightPreference` → ступень
/// без знания внутренней структуры, кроме высоты бара.
int _activeLightStep(WidgetTester tester) {
  final c = tester
      .element(find.byType(SpeciesLightMeter))
      .findAncestorWidgetOfExactType<Theme>()!
      .data
      .extension<PcColors>()!;

  final bars = tester
      .widgetList<Container>(
        find.descendant(
          of: find.byType(SpeciesLightMeter),
          matching: find.byType(Container),
        ),
      )
      .where((cn) {
        final box = cn.constraints;
        return box != null && box.minHeight == 8 && box.maxHeight == 8;
      })
      .toList();

  expect(bars.length, 4, reason: 'шкала света должна иметь 4 ступени');

  for (var i = 0; i < bars.length; i++) {
    final deco = bars[i].decoration as BoxDecoration;
    if (deco.color == c.primary) return i;
  }
  return -1;
}

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

  group('facts grid + light meter (enrich)', () {
    testWidgets(
        'should_render_three_facts_and_light_meter_active_step_for_full_data',
        (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const SpeciesDetail(
          id: _id,
          name: 'Монстера',
          wateringDays: 7,
          careDifficulty: CareDifficulty.medium,
          lightPreference: LightPreference.brightIndirect,
        ),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Сетка фактов есть, и все три факта присутствуют.
      expect(find.byType(SpeciesFactsGrid), findsOneWidget);
      expect(find.text(l10n.speciesFactDifficulty.toUpperCase()), findsOneWidget);
      // Значение сложности видно (также дублируется в hero meta-row).
      expect(
        find.text(l10n.labelForDifficulty(CareDifficulty.medium)),
        findsWidgets,
      );
      expect(find.text(l10n.speciesFactLight.toUpperCase()), findsOneWidget);
      // Значение света видно (также как подпись активной ступени шкалы).
      expect(
        find.text(l10n.labelForLight(LightPreference.brightIndirect)),
        findsWidgets,
      );
      expect(find.text(l10n.speciesFactWatering.toUpperCase()), findsOneWidget);

      // Шкала света отрисована, активна ступень 2 (brightIndirect).
      expect(find.byType(SpeciesLightMeter), findsOneWidget);
      expect(_activeLightStep(tester), 2);
    });

    testWidgets('should_map_shade_to_first_light_step', (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const SpeciesDetail(
          id: _id,
          name: 'Сансевиерия',
          lightPreference: LightPreference.shade,
        ),
      ));
      await tester.pumpAndSettle();

      expect(_activeLightStep(tester), 0);
    });

    testWidgets('should_map_full_sun_to_last_light_step', (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const SpeciesDetail(
          id: _id,
          name: 'Кактус',
          lightPreference: LightPreference.fullSun,
        ),
      ));
      await tester.pumpAndSettle();

      expect(_activeLightStep(tester), 3);
    });

    testWidgets(
        'should_hide_light_card_and_meter_when_light_unknown_without_crash',
        (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const SpeciesDetail(
          id: _id,
          name: 'Загадка',
          wateringDays: 5,
          careDifficulty: CareDifficulty.easy,
          // lightPreference по умолчанию unknown.
        ),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Шкала света не отрисована.
      expect(find.byType(SpeciesLightMeter), findsNothing);
      expect(find.text(l10n.speciesLightTitle), findsNothing);
      // Карточка-факт «Свет» тоже отсутствует.
      expect(find.text(l10n.speciesFactLight.toUpperCase()), findsNothing);
      // При этом остальные факты на месте (сетка строится, краша нет).
      expect(find.byType(SpeciesFactsGrid), findsOneWidget);
      expect(find.text(l10n.speciesFactDifficulty.toUpperCase()), findsOneWidget);
      expect(find.text(l10n.speciesFactWatering.toUpperCase()), findsOneWidget);
    });

    testWidgets('should_not_build_watering_fact_when_watering_days_null',
        (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const SpeciesDetail(
          id: _id,
          name: 'Фикус',
          careDifficulty: CareDifficulty.easy,
          // wateringDays == null.
        ),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(SpeciesFactsGrid), findsOneWidget);
      // Карточка «Полив» не строится.
      expect(find.text(l10n.speciesFactWatering.toUpperCase()), findsNothing);
      // Сложность при этом отрисована.
      expect(find.text(l10n.speciesFactDifficulty.toUpperCase()), findsOneWidget);
    });
  });

  group('toxicity banner (G28 — hidden)', () {
    testWidgets('should_not_show_toxicity_banner_in_data_state',
        (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const SpeciesDetail(
          id: _id,
          name: 'Диффенбахия',
          wateringDays: 7,
          careDifficulty: CareDifficulty.medium,
          lightPreference: LightPreference.partialShade,
          description: 'Токсична для животных (в реальности), но баннер скрыт.',
        ),
      ));
      await tester.pumpAndSettle();

      // G28: данных о токсичности нет — баннер не рисуется.
      expect(find.byType(SpeciesToxicityBanner), findsNothing);
      // Защита от случайного включения хардкода: shouldShow == false.
      expect(
        SpeciesToxicityBanner.shouldShow(
          const SpeciesDetail(id: _id, name: 'Диффенбахия'),
        ),
        isFalse,
      );
    });
  });

  group('add CTA navigation', () {
    testWidgets('should_navigate_to_add_with_species_id_when_cta_tapped',
        (tester) async {
      const speciesId = 42;
      final pushedLocations = <String>[];

      final router = GoRouter(
        initialLocation: '/catalog/$speciesId',
        routes: [
          GoRoute(
            path: '/catalog/:id',
            builder: (_, state) => SpeciesDetailScreen(
              id: int.parse(state.pathParameters['id']!),
            ),
            routes: [
              // Заглушка цели CTA: ловит push на /home/add?speciesId=... через
              // тот же путь, что строит экран (`context.push('/home/add?...')`).
            ],
          ),
          GoRoute(
            path: '/home/add',
            builder: (_, state) {
              pushedLocations.add(state.uri.toString());
              return const Scaffold(body: Text('add-target'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            speciesDetailProvider(speciesId).overrideWith(
              (ref) async => const SpeciesDetail(
                id: speciesId,
                name: 'Монстера',
                wateringDays: 7,
                careDifficulty: CareDifficulty.medium,
                lightPreference: LightPreference.brightIndirect,
              ),
            ),
          ],
          child: MaterialApp.router(
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // CTA отрисована в data-состоянии.
      expect(find.byType(SpeciesAddCta), findsOneWidget);

      await tester.tap(find.byType(SpeciesAddCta));
      await tester.pumpAndSettle();

      // Переход ушёл на /home/add c query speciesId = id вида.
      expect(pushedLocations, ['/home/add?speciesId=$speciesId']);
      expect(find.text('add-target'), findsOneWidget);
    });
  });
}
