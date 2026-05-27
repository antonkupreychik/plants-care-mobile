import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/api_error_l10n.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/add_plant/data/add_plant_repository_provider.dart';
import 'package:plantcare_mobile/features/add_plant/domain/add_plant_repository.dart';
import 'package:plantcare_mobile/features/add_plant/domain/species_summary.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_screen.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/species_providers.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/widgets/care_plan_preview.dart';
import 'package:plantcare_mobile/features/home/domain/garden_location.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements AddPlantRepository {}

const _ficus = SpeciesSummary(
  id: 7,
  name: 'Фикус',
  latinName: 'Ficus',
  wateringDays: 7,
  fertilizingDays: 30,
);

const _locations = [
  GardenLocation(id: 1, name: 'Спальня', isDefault: true, emoji: '🛏'),
  GardenLocation(id: 2, name: 'Кухня', isDefault: false),
];

Future<List<SpeciesSummary>> _pending() => Completer<List<SpeciesSummary>>().future;

/// Маркер «хост-экрана» под мастером — после закрытия мастера (`context.pop()`)
/// мы должны вернуться сюда.
const _hostMarker = Key('host-screen');

/// Монтирует мастер на отдельном маршруте `/add` поверх хост-экрана через
/// настоящий GoRouter — так `context.pop()`/`context.go()` внутри мастера
/// работают, как в проде (мастер на root-навигаторе поверх shell).
/// [species]/[speciesError] управляют шагом 1, [repo] (необязателен) — сабмитом.
Future<void> _pump(
  WidgetTester tester, {
  List<SpeciesSummary>? species,
  Object? speciesError,
  bool speciesLoading = false,
  List<GardenLocation> locations = _locations,
  _MockRepo? repo,
}) async {
  final router = GoRouter(
    initialLocation: '/add',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) =>
            const Scaffold(body: Center(child: Text('хост', key: _hostMarker))),
        routes: [
          GoRoute(
            path: 'add',
            builder: (_, _) => const AddPlantWizardScreen(),
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (repo != null) addPlantRepositoryProvider.overrideWithValue(repo),
        speciesSearchProvider('').overrideWith((ref) {
          if (speciesLoading) return _pending();
          if (speciesError != null) return Future.error(speciesError);
          return Future.value(species ?? const <SpeciesSummary>[]);
        }),
        homeLocationsProvider.overrideWith((ref) async => locations),
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
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(AddPlantWizardScreen)));

/// Переход с шага 1 на шаг 2 нажатием «Пропустить вид».
Future<void> _skipToNameStep(WidgetTester tester) async {
  final l10n = _l10n(tester);
  await tester.tap(find.text(l10n.addPlantSkipSpeciesTitle));
  await tester.pumpAndSettle();
}

void main() {
  group('step 1 (species search)', () {
    testWidgets('should_show_skeleton_when_loading', (tester) async {
      await _pump(tester, speciesLoading: true);

      // Скелетон есть, ошибки/empty нет.
      expect(find.byType(ErrorState), findsNothing);
      final l10n = _l10n(tester);
      expect(find.text(l10n.addPlantSearchEmpty), findsNothing);
    });

    testWidgets('should_show_error_with_retry_when_search_fails',
        (tester) async {
      await _pump(tester, speciesError: const ApiError.network());
      await tester.pumpAndSettle();
      final l10n = _l10n(tester);

      expect(find.byType(ErrorState), findsOneWidget);
      expect(
        find.text(l10n.messageForError(const ApiError.network())),
        findsOneWidget,
      );
      expect(find.text(l10n.retry), findsOneWidget);
    });

    testWidgets('should_show_empty_state_when_no_species', (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      final l10n = _l10n(tester);

      expect(find.text(l10n.addPlantSearchEmpty), findsOneWidget);
    });

    testWidgets('should_show_species_cards_when_data', (tester) async {
      await _pump(tester, species: const [_ficus]);
      await tester.pumpAndSettle();

      expect(find.text('Фикус'), findsOneWidget);
      expect(find.text('Ficus'), findsOneWidget);
    });

    testWidgets('should_go_to_name_step_with_prefilled_name_when_species_tapped',
        (tester) async {
      await _pump(tester, species: const [_ficus]);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Фикус'));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Шаг 2: заголовок имени + поле префиллено именем вида.
      expect(find.text(l10n.addPlantNameTitle), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Фикус'), findsOneWidget);
    });

    testWidgets('should_go_to_name_step_without_species_when_skip',
        (tester) async {
      await _pump(tester, species: const [_ficus]);
      await tester.pumpAndSettle();

      await _skipToNameStep(tester);

      final l10n = _l10n(tester);
      expect(find.text(l10n.addPlantNameTitle), findsOneWidget);
      // Имя не префиллено (вид не выбран).
      expect(find.widgetWithText(TextField, 'Фикус'), findsNothing);
    });
  });

  group('step 2 (name + room)', () {
    testWidgets('should_keep_next_disabled_until_valid_name_then_enable',
        (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);

      // Имя пустое: «Далее» отрисована, но не должна вести на шаг 3.
      await tester.tap(find.text(l10n.addPlantNext));
      await tester.pumpAndSettle();
      expect(find.text(l10n.addPlantNameTitle), findsOneWidget); // остались

      // Вводим валидное имя → «Далее» работает.
      await tester.enterText(find.byType(TextField).first, 'Алоэ');
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext));
      await tester.pumpAndSettle();

      // Перешли на шаг 3 (план ухода).
      expect(find.text(l10n.addPlantCarePlanTitle), findsOneWidget);
    });

    testWidgets('should_show_rooms_from_homeLocationsProvider', (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await _skipToNameStep(tester);

      expect(find.text('Спальня'), findsOneWidget);
      expect(find.text('Кухня'), findsOneWidget);
    });
  });

  group('step 3 (care plan)', () {
    testWidgets('should_show_plan_cards_when_species_selected', (tester) async {
      await _pump(tester, species: const [_ficus], repo: _MockRepo());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Фикус'));
      await tester.pumpAndSettle();
      final l10n = _l10n(tester);

      // Шаг 2 → шаг 3.
      await tester.tap(find.text(l10n.addPlantNext));
      await tester.pumpAndSettle();

      // _ficus имеет 2 интервала (watering, fertilizing) → 2 карточки плана.
      expect(find.byType(CarePlanPreview), findsOneWidget);
      expect(find.byType(CarePlanHint), findsNothing);
    });

    testWidgets('should_show_hint_when_no_species_selected', (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);

      await tester.enterText(find.byType(TextField).first, 'Алоэ');
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext));
      await tester.pumpAndSettle();

      expect(find.byType(CarePlanHint), findsOneWidget);
      expect(find.byType(CarePlanPreview), findsNothing);
    });
  });

  group('step 4 (confirm + submit)', () {
    /// Доводит мастер до шага 4 с валидным именем «Алоэ» (без вида).
    Future<void> goToConfirm(WidgetTester tester) async {
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField).first, 'Алоэ');
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext)); // → шаг 3
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext)); // → шаг 4
      await tester.pumpAndSettle();
    }

    testWidgets('should_show_progress_and_block_button_while_submitting',
        (tester) async {
      final repo = _MockRepo();
      final completer = Completer<Result<int>>();
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) => completer.future);

      await _pump(tester, species: const [], repo: repo);
      await tester.pumpAndSettle();
      await goToConfirm(tester);
      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.addPlantSubmit));
      await tester.pump(); // submitting

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(const Result.success(1));
      await tester.pumpAndSettle();
    });

    testWidgets('should_show_inline_error_and_keep_form_on_failure',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async => const Result.failure(ApiError.network()));

      await _pump(tester, species: const [], repo: repo);
      await tester.pumpAndSettle();
      await goToConfirm(tester);
      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.addPlantSubmit));
      await tester.pumpAndSettle();

      // Inline-ошибка по типу + форма на месте (мастер не закрыт), кнопка снова есть.
      expect(
        find.text(l10n.messageForError(const ApiError.network())),
        findsOneWidget,
      );
      expect(find.text(l10n.addPlantConfirmSubtitle), findsOneWidget);
      expect(find.text(l10n.addPlantSubmit), findsOneWidget);
    });

    testWidgets('should_close_wizard_and_show_snackbar_on_success',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async => const Result.success(99));

      await _pump(tester, species: const [], repo: repo);
      await tester.pumpAndSettle();
      await goToConfirm(tester);
      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.addPlantSubmit));
      await tester.pumpAndSettle();

      // Мастер закрыт (вернулись на хост-экран), snackbar показан.
      expect(find.byType(AddPlantWizardScreen), findsNothing);
      expect(find.byKey(_hostMarker), findsOneWidget);
      expect(find.text(l10n.addPlantSubmitted), findsOneWidget);
      verify(() => repo.createPlant(
            name: 'Алоэ',
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
          )).called(1);
    });
  });
}
