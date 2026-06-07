import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';
import 'package:plantcare_mobile/features/take_cutting/data/take_cutting_repository_provider.dart';
import 'package:plantcare_mobile/features/take_cutting/domain/take_cutting_repository.dart';
import 'package:plantcare_mobile/features/take_cutting/presentation/take_cutting_screen.dart';
import 'package:plantcare_mobile/features/take_cutting/presentation/widgets/cutting_method_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements TakeCuttingRepository {}

class _FixedClock implements Clock {
  _FixedClock(this._utc);
  final DateTime _utc;
  @override
  DateTime nowUtc() => _utc;
}

const _parentId = 42;
const _parentName = 'Моника';
final _utcNow = DateTime.utc(2026, 5, 13, 9);

const _hostMarker = Key('host-screen');
const _plantCardMarker = Key('plant-card-screen');

Future<void> _pump(
  WidgetTester tester, {
  _MockRepo? repo,
  Plant? parent,
}) async {
  final router = GoRouter(
    initialLocation: '/home/plants/$_parentId/cutting',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) =>
            const Scaffold(body: Center(child: Text('хост', key: _hostMarker))),
        routes: [
          GoRoute(
            path: 'home',
            builder: (_, _) => const SizedBox(),
            routes: [
              GoRoute(
                path: 'plants/:id',
                name: 'plantCard',
                builder: (_, _) => const Scaffold(
                  body: Center(
                    child: Text('карточка', key: _plantCardMarker),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'cutting',
                    name: 'takeCutting',
                    builder: (_, _) =>
                        const TakeCuttingScreen(parentPlantId: _parentId),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(_FixedClock(_utcNow)),
        if (repo != null)
          takeCuttingRepositoryProvider.overrideWithValue(repo),
        plantDetailProvider(_parentId).overrideWith(
          (ref) async =>
              parent ?? const Plant(id: _parentId, name: _parentName),
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
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(TakeCuttingScreen)));

void main() {
  setUpAll(() {
    registerFallbackValue(0);
  });

  testWidgets('shows wizard title with parent name', (tester) async {
    await _pump(tester);
    final l10n = _l10n(tester);
    expect(find.text(l10n.takeCuttingTitle(_parentName)), findsOneWidget);
  });

  testWidgets('name suggestion chip fills the name field', (tester) async {
    await _pump(tester);

    // Чип «Дочка» — статичное предложение, не завязан на родителя.
    final l10n = _l10n(tester);
    await tester.tap(find.text(l10n.takeCuttingSuggestionDaughter));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, l10n.takeCuttingSuggestionDaughter);
  });

  testWidgets('tapping a method card toggles active selection', (tester) async {
    await _pump(tester);
    final l10n = _l10n(tester);

    // По умолчанию активна «В воду».
    final water = tester.widget<CuttingMethodCard>(
      find.widgetWithText(CuttingMethodCard, l10n.takeCuttingMethodWater),
    );
    expect(water.active, isTrue);

    await tester.tap(
      find.widgetWithText(CuttingMethodCard, l10n.takeCuttingMethodSoil),
    );
    await tester.pumpAndSettle();

    final soil = tester.widget<CuttingMethodCard>(
      find.widgetWithText(CuttingMethodCard, l10n.takeCuttingMethodSoil),
    );
    final waterAfter = tester.widget<CuttingMethodCard>(
      find.widgetWithText(CuttingMethodCard, l10n.takeCuttingMethodWater),
    );
    expect(soil.active, isTrue);
    expect(waterAfter.active, isFalse);
  });

  testWidgets('date row shows today by default and opens DatePickerDialog',
      (tester) async {
    await _pump(tester);
    final l10n = _l10n(tester);

    // Подпись «Сегодня …» под датой подтверждает дефолт = сегодня.
    await tester.dragUntilVisible(
      find.text(l10n.takeCuttingDateTodayHint),
      find.byType(ListView),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.takeCuttingDateTodayHint), findsOneWidget);

    await tester.tap(find.text(l10n.takeCuttingDateTodayHint));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('submit creates cutting with parentPlantId and navigates',
      (tester) async {
    final repo = _MockRepo();
    when(() => repo.createCutting(
          name: any(named: 'name'),
          parentPlantId: any(named: 'parentPlantId'),
        )).thenAnswer((_) async => const Result.success(99));

    await _pump(tester, repo: repo);
    final l10n = _l10n(tester);

    await tester.enterText(find.byType(TextField), 'Моник');
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.takeCuttingSubmit));
    await tester.pumpAndSettle();

    verify(() => repo.createCutting(name: 'Моник', parentPlantId: _parentId))
        .called(1);
    // Навигировали на карточку нового ростка.
    expect(find.byKey(_plantCardMarker), findsOneWidget);
  });

  testWidgets('cancel closes wizard without creating', (tester) async {
    final repo = _MockRepo();
    await _pump(tester, repo: repo);
    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.takeCuttingCancel));
    await tester.pumpAndSettle();

    expect(find.byKey(_plantCardMarker), findsOneWidget);
    verifyNever(() => repo.createCutting(
          name: any(named: 'name'),
          parentPlantId: any(named: 'parentPlantId'),
        ));
  });
}
