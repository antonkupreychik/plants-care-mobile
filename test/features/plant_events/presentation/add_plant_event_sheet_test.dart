import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/plant_events/data/plant_event_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_repository.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_type.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_events_page.dart';
import 'package:plantcare_mobile/features/plant_events/presentation/add_plant_event_sheet.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements PlantEventRepository {}

const _plantId = 11;
final _now = DateTime.utc(2026, 6, 1, 9);

PlantEventsPage _emptyPage() =>
    const PlantEventsPage(items: [], total: 0, limit: 20, offset: 0);

PlantEvent _logged(PlantEventType type) =>
    PlantEvent(id: 99, eventType: type, eventDate: _now);

Future<void> _openSheet(WidgetTester tester, _MockRepo repo) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [plantEventRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () =>
                    showAddPlantEventSheet(context, plantId: _plantId),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    registerFallbackValue(PlantEventType.transplant);
  });

  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
    when(() => repo.getEvents(any(),
            limit: any(named: 'limit'), offset: any(named: 'offset')))
        .thenAnswer((_) async => Result.success(_emptyPage()));
  });

  testWidgets('should_render_four_type_buttons', (tester) async {
    await _openSheet(tester, repo);
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    expect(find.text(l10n.plantEventTypeTransplant), findsOneWidget);
    expect(find.text(l10n.plantEventTypeSoilChange), findsOneWidget);
    expect(find.text(l10n.plantEventTypePruning), findsOneWidget);
    expect(find.text(l10n.plantEventTypePestTreatment), findsOneWidget);
  });

  testWidgets('tap_type_should_post_event_and_close_sheet', (tester) async {
    when(() => repo.addEvent(_plantId, PlantEventType.pruning))
        .thenAnswer((_) async => Result.success(_logged(PlantEventType.pruning)));
    await _openSheet(tester, repo);
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    await tester.tap(find.text(l10n.plantEventTypePruning));
    await tester.pumpAndSettle();

    verify(() => repo.addEvent(_plantId, PlantEventType.pruning)).called(1);
    // Sheet закрыт: кнопок типов больше нет.
    expect(find.text(l10n.plantEventTypePruning), findsNothing);
    // Снэкбар подтверждения.
    expect(find.text(l10n.plantEventAddedSnackbar), findsOneWidget);
  });

  testWidgets('conflict_should_show_duplicate_toast_and_close', (tester) async {
    when(() => repo.addEvent(_plantId, PlantEventType.soilChange))
        .thenAnswer((_) async => const Result.failure(ApiError.conflict()));
    await _openSheet(tester, repo);
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    await tester.tap(find.text(l10n.plantEventTypeSoilChange));
    await tester.pumpAndSettle();

    expect(find.text(l10n.plantEventDuplicateSnackbar), findsOneWidget);
  });
}
