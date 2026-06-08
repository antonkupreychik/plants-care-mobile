import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/router/app_router.dart';
import 'package:plantcare_mobile/core/sdui/data/sdui_repository_provider.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_action.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_repository.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_screen_layout.dart';
import 'package:plantcare_mobile/core/sdui/presentation/action_runner.dart';
import 'package:plantcare_mobile/core/sdui/presentation/screen_layout_provider.dart';
import 'package:plantcare_mobile/features/care_event/data/care_event_repository_provider.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_repository.dart';
import 'package:plantcare_mobile/features/care_event/domain/logged_care_event.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';

class _MockCareEventRepo extends Mock implements CareEventRepository {}

class _MockSduiRepo extends Mock implements SduiRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

final _fixedNow = DateTime.utc(2026, 5, 27, 9);

LoggedCareEvent _logged(String? clientId) => LoggedCareEvent(
      id: 1,
      plantId: 9,
      plantName: 'Монстера',
      type: CareEventKind.water,
      performedAtUtc: _fixedNow,
      onTime: true,
      clientId: clientId,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(
      CareEventDraft(
        plantId: 0,
        type: CareEventKind.water,
        performedAtUtc: DateTime.utc(2020),
      ),
    );
  });

  late _MockCareEventRepo careRepo;
  late _MockSduiRepo sduiRepo;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
        careEventRepositoryProvider.overrideWithValue(careRepo),
        sduiRepositoryProvider.overrideWithValue(sduiRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    careRepo = _MockCareEventRepo();
    sduiRepo = _MockSduiRepo();
    when(() => sduiRepo.getHomeLayout()).thenAnswer(
      (_) async => const Result.success(
        SduiScreenLayout(screenId: 'home', version: 1, blocks: []),
      ),
    );
  });

  const action = SduiAction(
    kind: SduiActionKind.logCare,
    method: 'POST',
    path: '/care-events',
    payload: {'plantId': 9, 'type': 'WATER'},
    invalidates: ['home', 'today', 'plant'],
  );

  test('log_care calls care-event repo with idempotent clientId', () async {
    final container = makeContainer();
    CareEventDraft? captured;
    when(() => careRepo.logCareEvent(any())).thenAnswer((invocation) async {
      captured = invocation.positionalArguments.first as CareEventDraft;
      return Result.success(_logged(captured!.clientId));
    });

    final result = await container.read(actionRunnerProvider).run(action);

    expect(result, SduiActionResult.success);
    verify(() => careRepo.logCareEvent(any())).called(1);
    expect(captured, isNotNull);
    expect(captured!.plantId, 9);
    expect(captured!.type, CareEventKind.water);
    // clientId сгенерирован (идемпотентность), не null.
    expect(captured!.clientId, isNotNull);
    expect(captured!.clientId, isNotEmpty);
    expect(captured!.performedAtUtc, _fixedNow);
  });

  test('success invalidates homeScreenLayout (server re-composes)', () async {
    final container = makeContainer();
    when(() => careRepo.logCareEvent(any()))
        .thenAnswer((_) async => Result.success(_logged('cid')));

    // Держим лейаут живым и материализуем его (первый fetch).
    final sub = container.listen(homeScreenLayoutProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(homeScreenLayoutProvider.future);
    verify(() => sduiRepo.getHomeLayout()).called(1);

    await container.read(actionRunnerProvider).run(action);
    await container.read(homeScreenLayoutProvider.future);

    // Инвалидация после успеха → повторный fetch лейаута.
    verify(() => sduiRepo.getHomeLayout()).called(1);
  });

  test('failure returns failure and does NOT invalidate layout', () async {
    final container = makeContainer();
    when(() => careRepo.logCareEvent(any()))
        .thenAnswer((_) async => const Result.failure(ApiError.network()));

    final sub = container.listen(homeScreenLayoutProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(homeScreenLayoutProvider.future);
    clearInteractions(sduiRepo);

    final result = await container.read(actionRunnerProvider).run(action);

    expect(result, SduiActionResult.failure);
    verifyNever(() => sduiRepo.getHomeLayout());
  });

  test('unknown kind is unsupported (no network call)', () async {
    final container = makeContainer();

    const unknown = SduiAction(
      kind: SduiActionKind.unknown,
      method: 'POST',
      path: '/x',
    );
    final result = await container.read(actionRunnerProvider).run(unknown);

    expect(result, SduiActionResult.unsupported);
    verifyNever(() => careRepo.logCareEvent(any()));
  });

  test('log_care with missing plantId is unsupported', () async {
    final container = makeContainer();

    const bad = SduiAction(
      kind: SduiActionKind.logCare,
      method: 'POST',
      path: '/care-events',
      payload: {'type': 'WATER'},
    );
    final result = await container.read(actionRunnerProvider).run(bad);

    expect(result, SduiActionResult.unsupported);
    verifyNever(() => careRepo.logCareEvent(any()));
  });

  group('declarative invalidation (MADR-017)', () {
    test('only invalidates listed keys (home alone → today not refetched)',
        () async {
      careRepo = _MockCareEventRepo();
      sduiRepo = _MockSduiRepo();
      when(() => sduiRepo.getHomeLayout()).thenAnswer(
        (_) async => const Result.success(
          SduiScreenLayout(screenId: 'home', version: 1, blocks: []),
        ),
      );
      when(() => careRepo.logCareEvent(any()))
          .thenAnswer((_) async => Result.success(_logged('cid')));
      final container = makeContainer();

      final sub = container.listen(homeScreenLayoutProvider, (_, _) {});
      addTearDown(sub.close);
      await container.read(homeScreenLayoutProvider.future);
      verify(() => sduiRepo.getHomeLayout()).called(1);

      // Только 'home' в invalidates → лейаут перечитан.
      const homeOnly = SduiAction(
        kind: SduiActionKind.logCare,
        method: 'POST',
        path: '/care-events',
        payload: {'plantId': 9, 'type': 'WATER'},
        invalidates: ['home'],
      );
      await container.read(actionRunnerProvider).run(homeOnly);
      await container.read(homeScreenLayoutProvider.future);
      verify(() => sduiRepo.getHomeLayout()).called(1);
    });

    test('empty invalidates → success but layout NOT refetched', () async {
      final container = makeContainer();
      when(() => careRepo.logCareEvent(any()))
          .thenAnswer((_) async => Result.success(_logged('cid')));

      final sub = container.listen(homeScreenLayoutProvider, (_, _) {});
      addTearDown(sub.close);
      await container.read(homeScreenLayoutProvider.future);
      clearInteractions(sduiRepo);

      const noInval = SduiAction(
        kind: SduiActionKind.logCare,
        method: 'POST',
        path: '/care-events',
        payload: {'plantId': 9, 'type': 'WATER'},
      );
      final result = await container.read(actionRunnerProvider).run(noInval);

      expect(result, SduiActionResult.success);
      verifyNever(() => sduiRepo.getHomeLayout());
    });

    test('unknown invalidate key is skipped gracefully (still success)',
        () async {
      final container = makeContainer();
      when(() => careRepo.logCareEvent(any()))
          .thenAnswer((_) async => Result.success(_logged('cid')));

      const weird = SduiAction(
        kind: SduiActionKind.logCare,
        method: 'POST',
        path: '/care-events',
        payload: {'plantId': 9, 'type': 'WATER'},
        invalidates: ['galaxy', 'home'],
      );
      final result = await container.read(actionRunnerProvider).run(weird);

      // Неизвестный ключ не роняет — действие успешно.
      expect(result, SduiActionResult.success);
    });
  });

  group('navigate action (MADR-017)', () {
    /// Минимальный реальный GoRouter для проверки навигации (push меняет
    /// текущий маршрут). Стартует на '/', есть маршрут '/plants/:id' с
    /// findable-виджетом (проверяем по нему, а не по uri: imperative push в
    /// go_router не всегда отражает целевой path в currentConfiguration.uri).
    GoRouter buildRouter() => GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Text('home', key: Key('homePage')),
            ),
            GoRoute(
              path: '/plants/:id',
              builder: (_, state) => Text(
                'plant ${state.pathParameters['id']}',
                key: const Key('plantPage'),
              ),
            ),
          ],
        );

    testWidgets('navigate pushes target route', (tester) async {
      final router = buildRouter();
      final container = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
          careEventRepositoryProvider.overrideWithValue(careRepo),
          sduiRepositoryProvider.overrideWithValue(sduiRepo),
          appRouterProvider.overrideWithValue(router),
        ],
      );
      addTearDown(container.dispose);

      // Монтируем роутер, чтобы push реально отработал.
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      const nav = SduiAction(
        kind: SduiActionKind.navigate,
        target: '/plants/10',
      );
      final result = await container.read(actionRunnerProvider).run(nav);
      await tester.pumpAndSettle();

      expect(result, SduiActionResult.success);
      // Целевой экран запушен поверх (push '/plants/10').
      expect(find.byKey(const Key('plantPage')), findsOneWidget);
      expect(find.text('plant 10'), findsOneWidget);
    });

    testWidgets('navigate with empty target is no-op (unsupported, no push)',
        (tester) async {
      final router = buildRouter();
      final container = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
          careEventRepositoryProvider.overrideWithValue(careRepo),
          sduiRepositoryProvider.overrideWithValue(sduiRepo),
          appRouterProvider.overrideWithValue(router),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      const nav = SduiAction(kind: SduiActionKind.navigate);
      final result = await container.read(actionRunnerProvider).run(nav);
      await tester.pumpAndSettle();

      expect(result, SduiActionResult.unsupported);
      // Маршрут не изменился — целевой экран не запушен, остались на home.
      expect(find.byKey(const Key('plantPage')), findsNothing);
      expect(find.byKey(const Key('homePage')), findsOneWidget);
    });
  });
}
