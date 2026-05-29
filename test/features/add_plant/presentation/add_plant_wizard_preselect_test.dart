import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/add_plant/domain/species_detail.dart';
import 'package:plantcare_mobile/features/add_plant/domain/species_summary.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_controller.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_screen.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/species_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

const _speciesId = 7;

const _ficus = SpeciesSummary(
  id: _speciesId,
  name: 'Фикус',
  latinName: 'Ficus',
  wateringDays: 7,
  fertilizingDays: 30,
);

const _ficusDetail = SpeciesDetail(
  summary: _ficus,
  description: 'Неприхотливое дерево.',
);

const _locations = [
  GardenLocation(id: 1, name: 'Спальня', isDefault: true, emoji: '🛏'),
];

/// Монтирует мастер на маршруте `/add` через настоящий GoRouter с заданным
/// [initialSpeciesId]. [detail]/[detailError]/[detailLoading] управляют ответом
/// [speciesDetailProvider] для предвыбора. Возвращает [ProviderContainer], чтобы
/// тест мог честно прочитать черновик через [addPlantWizardControllerProvider].
Future<ProviderContainer> _pump(
  WidgetTester tester, {
  required int? initialSpeciesId,
  SpeciesDetail? detail,
  Object? detailError,
  bool detailLoading = false,
}) async {
  final router = GoRouter(
    initialLocation: '/add',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('хост')),
        routes: [
          GoRoute(
            path: 'add',
            builder: (_, _) =>
                AddPlantWizardScreen(initialSpeciesId: initialSpeciesId),
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // Шаг 1: пустой результат поиска (не мешает, грузится мгновенно).
        speciesSearchProvider('').overrideWith((ref) async {
          return const <SpeciesSummary>[];
        }),
        homeLocationsProvider.overrideWith((ref) async => _locations),
        if (initialSpeciesId != null)
          speciesDetailProvider(initialSpeciesId).overrideWith((ref) {
            if (detailLoading) return Completer<SpeciesDetail>().future;
            if (detailError != null) return Future.error(detailError);
            return Future.value(detail ?? _ficusDetail);
          }),
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
  await tester.pump();

  return ProviderScope.containerOf(
    tester.element(find.byType(AddPlantWizardScreen)),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(AddPlantWizardScreen)));

void main() {
  testWidgets(
      'should_preselect_species_and_start_on_name_step_when_initial_id_given',
      (tester) async {
    final container = await _pump(tester, initialSpeciesId: _speciesId);
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    // Стартовали сразу на шаге 2 «Как назовём?» (минуя шаг 1 выбора вида).
    expect(find.text(l10n.addPlantNameTitle), findsOneWidget);
    expect(find.text(l10n.addPlantSpeciesTitle), findsNothing);

    // Черновик получил выбранный вид (через контроллер, не из UI).
    final draft = container.read(addPlantWizardControllerProvider).draft;
    expect(draft.species, _ficus);
    // Имя префиллено именем вида.
    expect(draft.name, 'Фикус');
    expect(find.widgetWithText(TextField, 'Фикус'), findsOneWidget);
  });

  testWidgets('should_start_on_species_step_without_selection_when_id_null',
      (tester) async {
    final container = await _pump(tester, initialSpeciesId: null);
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    // Обычный старт: шаг 1 «Какое у тебя растение?», шаг 2 не показан.
    expect(find.text(l10n.addPlantSpeciesTitle), findsOneWidget);
    expect(find.text(l10n.addPlantNameTitle), findsNothing);

    // Вид не выбран, имя пустое.
    final draft = container.read(addPlantWizardControllerProvider).draft;
    expect(draft.species, isNull);
    expect(draft.name, isEmpty);
  });

  testWidgets('should_degrade_to_species_step_when_preselect_load_fails',
      (tester) async {
    final container = await _pump(
      tester,
      initialSpeciesId: _speciesId,
      detailError: const ApiError.notFound(),
    );
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    // Загрузка вида упала → деградация на шаг 1, без краша.
    expect(tester.takeException(), isNull);
    expect(find.text(l10n.addPlantSpeciesTitle), findsOneWidget);
    expect(find.text(l10n.addPlantNameTitle), findsNothing);

    // Вид так и не попал в черновик.
    final draft = container.read(addPlantWizardControllerProvider).draft;
    expect(draft.species, isNull);
  });
}
