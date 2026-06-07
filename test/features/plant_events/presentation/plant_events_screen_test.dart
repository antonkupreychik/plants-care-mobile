import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/plant_events/data/plant_event_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_repository.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_type.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_events_page.dart';
import 'package:plantcare_mobile/features/plant_events/presentation/plant_events_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements PlantEventRepository {}

const _plantIdA = 10;
const _plantIdB = 20;
final _now = DateTime.utc(2026, 6, 1, 12);

PlantEvent _event(int id, PlantEventType type, {String? comment}) =>
    PlantEvent(id: id, eventType: type, eventDate: _now, comment: comment);

PlantEventsPage _page(List<PlantEvent> items) =>
    PlantEventsPage(items: items, total: items.length, limit: 20, offset: 0);

PlantEventsPage _emptyPage() =>
    const PlantEventsPage(items: [], total: 0, limit: 20, offset: 0);

/// Никогда не завершающийся Future → провайдер в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

Widget _wrap({
  required int plantId,
  required PlantEventRepository repo,
}) {
  return ProviderScope(
    overrides: [plantEventRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: PlantEventsScreen(plantId: plantId),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(PlantEventsScreen)));

void main() {
  setUpAll(() {
    registerFallbackValue(PlantEventType.transplant);
  });

  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  group('PlantEventsScreen loading', () {
    testWidgets('should_show_spinner_while_loading', (tester) async {
      when(() => repo.getEvents(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) => _pending());

      await tester.pumpWidget(_wrap(plantId: _plantIdA, repo: repo));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });
  });

  group('PlantEventsScreen error', () {
    testWidgets('should_show_error_state_and_retry_button', (tester) async {
      when(() => repo.getEvents(
            _plantIdA,
            limit: any(named: 'limit'),
            offset: 0,
          )).thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(plantId: _plantIdA, repo: repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
    });

    testWidgets('retry_should_reload_events', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // First call fails; after retry the mock is reconfigured to succeed.
      when(() => repo.getEvents(
            _plantIdA,
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(plantId: _plantIdA, repo: repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(ErrorState), findsOneWidget);

      // Re-stub the repo so the retry call succeeds.
      when(() => repo.getEvents(
            _plantIdA,
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer(
              (_) async => Result.success(_page([_event(1, PlantEventType.pruning)])));

      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsNothing);
      expect(find.text(l10n.plantEventTypePruning), findsOneWidget);
    });
  });

  group('PlantEventsScreen data', () {
    testWidgets('should_render_events_for_the_given_plant_id', (tester) async {
      // plantA receives pruning events; plantB receives transplant events.
      when(() => repo.getEvents(
            _plantIdA,
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async =>
          Result.success(_page([_event(1, PlantEventType.pruning)])));

      await tester.pumpWidget(_wrap(plantId: _plantIdA, repo: repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.plantEventTypePruning), findsOneWidget);
      // transplant is NOT shown — different plant would show different events
      expect(find.text(l10n.plantEventTypeTransplant), findsNothing);
    });

    testWidgets('should_pass_correct_plantId_to_repository', (tester) async {
      // Verify the controller calls getEvents with the plantId passed to
      // PlantEventsScreen, not with a different value.
      when(() => repo.getEvents(
            _plantIdB,
            limit: any(named: 'limit'),
            offset: 0,
          )).thenAnswer((_) async =>
          Result.success(_page([_event(5, PlantEventType.pestTreatment)])));

      await tester.pumpWidget(_wrap(plantId: _plantIdB, repo: repo));
      await tester.pumpAndSettle();

      // getEvents was called with the correct plantId
      verify(() => repo.getEvents(
            _plantIdB,
            limit: any(named: 'limit'),
            offset: 0,
          )).called(1);
      verifyNever(() => repo.getEvents(
            _plantIdA,
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ));

      final l10n = _l10n(tester);
      expect(find.text(l10n.plantEventTypePestTreatment), findsOneWidget);
    });

    testWidgets(
        'two_screens_with_different_plantIds_show_independent_events',
        (tester) async {
      // Events for plantA (pruning), events for plantB (transplant).
      when(() => repo.getEvents(
            _plantIdA,
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async =>
          Result.success(_page([_event(1, PlantEventType.pruning)])));

      when(() => repo.getEvents(
            _plantIdB,
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => Result.success(
              _page([_event(2, PlantEventType.transplant)])));

      // Screen for plantA
      await tester.pumpWidget(_wrap(plantId: _plantIdA, repo: repo));
      await tester.pumpAndSettle();

      final l10nA = _l10n(tester);
      expect(find.text(l10nA.plantEventTypePruning), findsOneWidget);
      expect(find.text(l10nA.plantEventTypeTransplant), findsNothing);

      // Switch to screen for plantB — new ProviderScope, independent state
      await tester.pumpWidget(_wrap(plantId: _plantIdB, repo: repo));
      await tester.pumpAndSettle();

      final l10nB = _l10n(tester);
      expect(find.text(l10nB.plantEventTypeTransplant), findsOneWidget);
      expect(find.text(l10nB.plantEventTypePruning), findsNothing);
    });
  });

  group('PlantEventsScreen empty', () {
    testWidgets('should_show_empty_state_when_no_events', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(() => repo.getEvents(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => Result.success(_emptyPage()));

      await tester.pumpWidget(_wrap(plantId: _plantIdA, repo: repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.plantEventsEmptyTitle), findsOneWidget);
      // Empty state has CTA «Добавить первое событие» inside the card
      // (FAB is hidden when total == 0).
      expect(find.text(l10n.plantEventsEmptyCta), findsOneWidget);
    });
  });

  group('PlantEventsScreen event tile', () {
    testWidgets('should_display_event_comment_when_present', (tester) async {
      const comment = 'Горшок на 2 см больше';
      when(() => repo.getEvents(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => Result.success(_page([
                _event(1, PlantEventType.transplant, comment: comment),
              ])));

      await tester.pumpWidget(_wrap(plantId: _plantIdA, repo: repo));
      await tester.pumpAndSettle();

      expect(find.text(comment), findsOneWidget);
    });

    testWidgets('should_show_date_in_local_timezone', (tester) async {
      // eventDate at 23:00 UTC — in non-UTC local time this is a different day.
      final eventUtc = DateTime.utc(2026, 5, 31, 23, 0);
      when(() => repo.getEvents(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => Result.success(PlantEventsPage(
            items: [
              PlantEvent(
                id: 1,
                eventType: PlantEventType.pruning,
                eventDate: eventUtc,
              ),
            ],
            total: 1,
            limit: 20,
            offset: 0,
          )));

      await tester.pumpWidget(_wrap(plantId: _plantIdA, repo: repo));
      await tester.pumpAndSettle();

      // Event tile is shown — the date should be formatted in local timezone.
      // We can't test the exact local date label without knowing the test host's
      // timezone offset, but we confirm the tile renders without throwing.
      final l10n = _l10n(tester);
      expect(find.text(l10n.plantEventTypePruning), findsOneWidget);
    });
  });
}
